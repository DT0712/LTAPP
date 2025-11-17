import 'package:flutter/material.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/filter_panel.dart';
import '../widgets/home_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/suggested_places_section.dart';
import '../../../schedule/presentation/pages/schedule_page.dart';
import '../../../chat/chat_page.dart';
import '../../../notification/notification_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Màu nền cũ & màu bar
  static const Color kBarColor = Color(0xFFAED2FF);      // màu cũ
  static const Color kBgColor  = Color(0xFFF7F9FC);
  static const Color kIndicator = Color(0xFF86B9FF);     // màu đậm hơn để nổi

  int _pageIndex = 2; // 0: lịch, 1: chat, 2: home, 3: thông báo, 4: profile

  // Danh sách trang
  late final List<Widget> _pages = [
    const SchedulePage(),
    const ChatPage(),
    // Home scroll content
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setHomeState) {
        String? selectedQuan;
        bool showFilterPanel = false;
        return SingleChildScrollView(
          child: Column(
            children: [
              HomeAppBar(
                onFilterTap: () =>
                    setHomeState(() => showFilterPanel = !showFilterPanel),
              ),
              if (showFilterPanel)
                FilterPanel(
                  selectedQuan: selectedQuan,
                  onQuanSelected: (quan) => setHomeState(() {
                    selectedQuan = quan;
                    showFilterPanel = false;
                  }),
                  onClear: () => setHomeState(() {
                    selectedQuan = null;
                    showFilterPanel = false;
                  }),
                ),
              const HomeBanner(),
              const CategoriesSection(),
              SuggestedPlacesSection(selectedQuan: selectedQuan),
            ],
          ),
        );
      },
    ),
    const NotificationPage(),
    const ProfilePage(),
  ];

  // Icon cho từng tab
  final List<Map<String, IconData>> _navIcons = const [
    {'filled': Icons.calendar_today, 'outlined': Icons.calendar_today_outlined},
    {'filled': Icons.chat_bubble,    'outlined': Icons.chat_bubble_outline},
    {'filled': Icons.home,           'outlined': Icons.home_outlined},
    {'filled': Icons.notifications,  'outlined': Icons.notifications_outlined},
    {'filled': Icons.person,         'outlined': Icons.person_outline},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _pageIndex,
          children: _pages,
        ),
      ),
      // Thanh điều hướng custom
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _pageIndex,
        icons: _navIcons,
        barColor: kBarColor,
        indicatorColor: kIndicator,
        onTap: (i) => setState(() => _pageIndex = i),
      ),
    );
  }
}

/// ================== Bottom Nav tùy biến có hình tròn trượt ==================
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.icons,
    required this.onTap,
    required this.barColor,
    required this.indicatorColor,
  });

  final int currentIndex;
  final List<Map<String, IconData>> icons;
  final ValueChanged<int> onTap;
  final Color barColor;
  final Color indicatorColor;

  static const double _barHeight = 66;
  static const double _indicatorSize = 46;
  static const Duration _animDur = Duration(milliseconds: 260);
  static const Curve _animCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        // Không padding/margin để phủ full bề ngang & chạm đáy
        height: _barHeight,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final itemCount = icons.length;
            final slotWidth = width / itemCount;
            final indicatorCenterX = slotWidth * (currentIndex + 0.5);

            return Stack(
              children: [
                // NỀN: hình chữ nhật phủ toàn bộ bên dưới & 2 bên
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                  ),
                ),

                // VÒNG TRÒN CHỈ BÁO (trượt)
                AnimatedPositioned(
                  duration: _animDur,
                  curve: _animCurve,
                  left: indicatorCenterX - (_indicatorSize / 2),
                  // canh giữa theo trục dọc trong thanh
                  top: (_barHeight - _indicatorSize) / 2,
                  child: Container(
                    width: _indicatorSize,
                    height: _indicatorSize,
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: indicatorColor.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),

                // HÀNG ICON (chia đều full width)
                Row(
                  children: List.generate(itemCount, (i) {
                    final isActive = (i == currentIndex);
                    final iconPair = icons[i];

                    return Expanded(
                      child: InkWell(
                        onTap: () => onTap(i),
                        child: Center(
                          child: AnimatedScale(
                            scale: isActive ? 1.05 : 1.0,
                            duration: _animDur,
                            curve: _animCurve,
                            child: Icon(
                              isActive ? iconPair['filled']! : iconPair['outlined']!,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
