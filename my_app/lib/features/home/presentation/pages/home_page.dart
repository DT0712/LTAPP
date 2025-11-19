import 'package:flutter/material.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/filter_panel.dart';
import '../widgets/home_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/suggested_places_section.dart';
import '../../../chat/chat_page.dart';
import '../../../notification/notification_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../tour/presentation/pages/tour_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const Color kBarColor = Color(0xFFAED2FF);
  static const Color kBgColor = Color(0xFFF7F9FC);
  static const Color kIndicator = Color(0xFF86B9FF);

  int _pageIndex = 2;

  // ⭐ FIX: state thực sự nằm ở HomePage
  String? selectedQuan;
  bool showFilterPanel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _pageIndex,
          children: [
            const TourPage(),
            const ChatPage(),

            // ⭐ HOME PAGE KHÔNG DÙNG StatefulBuilder NỮA
            SingleChildScrollView(
              child: Column(
                children: [
                  HomeAppBar(
                    onFilterTap: () {
                      setState(() {
                        showFilterPanel = !showFilterPanel;
                      });
                    },
                  ),

                  if (showFilterPanel)
                    FilterPanel(
                      selectedQuan: selectedQuan,
                      onQuanSelected: (quan) {
                        setState(() {
                          selectedQuan = quan;
                          showFilterPanel = false;
                        });
                      },
                      onClear: () {
                        setState(() {
                          selectedQuan = null;
                          showFilterPanel = false;
                        });
                      },
                    ),

                  const HomeBanner(),
                  const CategoriesSection(),

                  // ⭐ truyền selectedQuan xuống để lọc
                  SuggestedPlacesSection(selectedQuan: selectedQuan),
                ],
              ),
            ),

            const NotificationPage(),
            const ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _pageIndex,
        icons: _navIcons,
        barColor: kBarColor,
        indicatorColor: kIndicator,
        onTap: (i) {
          setState(() => _pageIndex = i);
        },
      ),
    );
  }

  // Icon cho từng tab
  final List<Map<String, IconData>> _navIcons = const [
    {'filled': Icons.calendar_today, 'outlined': Icons.calendar_today_outlined},
    {'filled': Icons.chat_bubble, 'outlined': Icons.chat_bubble_outline},
    {'filled': Icons.home, 'outlined': Icons.home_outlined},
    {'filled': Icons.notifications, 'outlined': Icons.notifications_outlined},
    {'filled': Icons.person, 'outlined': Icons.person_outline},
  ];
}

/// ================== Bottom Nav ==================
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

                // VÒNG TRÒN TRƯỢT
                AnimatedPositioned(
                  duration: _animDur,
                  curve: _animCurve,
                  left: indicatorCenterX - (_indicatorSize / 2),
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

                // ICON TAB
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
                              isActive
                                  ? iconPair['filled']!
                                  : iconPair['outlined']!,
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
