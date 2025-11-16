// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/filter_panel.dart';
import '../widgets/home_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/suggested_places_section.dart';
import '../../../schedule/presentation/pages/schedule_page.dart';
import '../../../chat/chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryBlue = Color(0xFFAED2FF);
  static const Color backgroundColor = Color(0xFFF7F9FC);

  // --- State chính cho điều hướng ---
  int _pageIndex = 2;
  List<int> _iconSlots = [0, 1, 2, 3, 4];
  final List<Widget> _pages = [
    //Lịch
    const SchedulePage(),
    //Chat
    const ChatPage(),
    //Trang chủ
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
    const Center(child: Text('Notifications Page')),
    const Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    // Xác định icon nào đang ở vị trí FAB
    int fabIconIndex = _iconSlots[2];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _pageIndex, // Hiển thị trang theo _pageIndex
          children: _pages,
        ),
      ),
      //FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Khi nhấn FAB, chỉ cần đảm bảo trang đúng được hiển thị
          setState(() {
            _pageIndex = fabIconIndex;
          });
        },
        backgroundColor: primaryBlue,
        elevation: 8.0,
        shape: const CircleBorder(),
        child: Icon(
          _navIcons[fabIconIndex]['filled'], // Hiển thị icon ở slot 2
          color: Colors.black,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //BottomAppBar
      bottomNavigationBar: BottomAppBar(
        color: primaryBlue,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 2 item bên trái
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Xây dựng icon cho slot 0
                  _buildBarIcon(slotIndex: 0),
                  // Xây dựng icon cho slot 1
                  _buildBarIcon(slotIndex: 1),
                ],
              ),
              const SizedBox(width: 56),
              // 2 item bên phải
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Xây dựng icon cho slot 3
                  _buildBarIcon(slotIndex: 3),
                  // Xây dựng icon cho slot 4
                  _buildBarIcon(slotIndex: 4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Icon data mapping for each page index
  List<Map<String, IconData>> get _navIcons => [
        {
          'filled': Icons.calendar_today,
          'outlined': Icons.calendar_today_outlined
        },
        {'filled': Icons.chat_bubble, 'outlined': Icons.chat_bubble_outline},
        {'filled': Icons.home, 'outlined': Icons.home_outlined},
        {
          'filled': Icons.notifications,
          'outlined': Icons.notifications_outlined
        },
        {'filled': Icons.person, 'outlined': Icons.person_outline},
      ];

  // Hàm build icon và xử lý SWAP (KHÔNG ĐỔI)
  Widget _buildBarIcon({required int slotIndex}) {
    //Lấy icon index (0-4) từ slot (0, 1, 3, 4)
    int iconIndex = _iconSlots[slotIndex];
    //Icon này có đang được chọn không (so sánh với trang đang hiển thị)
    bool isSelected = (_pageIndex == iconIndex);
    //Lấy icon filled/outlined
    final icons = _navIcons[iconIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: IconButton(
        icon: Icon(
          isSelected ? icons['filled']! : icons['outlined']!,
          color: Colors.white,
        ),
        onPressed: () {
          //logic "SWAP"
          setState(() {
            // Lấy icon index hiện tại của FAB
            int currentFabIconIndex = _iconSlots[2];

            //Cập nhật trang sẽ hiển thị
            _pageIndex = iconIndex;

            //Đưa icon của FAB (cũ) vào slot vừa nhấn
            _iconSlots[slotIndex] = currentFabIconIndex;

            //Đưa icon vừa nhấn (mới) vào slot FAB
            _iconSlots[2] = iconIndex;
          });
        },
      ),
    );
  }
}
