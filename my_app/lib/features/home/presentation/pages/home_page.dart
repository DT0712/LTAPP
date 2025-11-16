import 'package:flutter/material.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/filter_panel.dart';
import '../widgets/home_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/suggested_places_section.dart';
import '../../../schedule/presentation/pages/schedule_page.dart';
import '../../../chat/chat_page.dart';
import '../../../notification/notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryBlue = Color(0xFFAED2FF);
  static const Color backgroundColor = Color(0xFFF7F9FC);

  // --- State chính cho điều hướng ---
  int _pageIndex = 2; // Bắt đầu ở trang chủ (index 2)

  // Danh sách các trang, không thay đổi
  final List<Widget> _pages = [
    //Lịch (Index 0)
    const SchedulePage(),

    //Chat (Index 1)
    const ChatPage(),

    //Trang chủ (Index 2)
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

    //Thông báo (Index 3)
    const NotificationPage(),

    // Profile (Index 4)
    const Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    // Không cần 'fabIconIndex' hay '_iconSlots' nữa

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
      //FloatingActionButton (Luôn là Trang chủ)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Khi nhấn FAB, luôn đặt _pageIndex = 2
          setState(() {
            _pageIndex = 2;
          });
        },
        backgroundColor: primaryBlue,
        elevation: 8.0,
        shape: const CircleBorder(),
        child: Icon(
          _navIcons[2]['filled'], // Luôn hiển thị icon 'home' (index 2)
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
              // 2 item bên trái (Cố định)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //icon cho Lịch (index 0)
                  _buildBarIcon(iconIndex: 0),
                  //icon cho Chat (index 1)
                  _buildBarIcon(iconIndex: 1),
                ],
              ),
              const SizedBox(width: 56), // Khoảng trống cho FAB
              // 2 item bên phải (Cố định)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //icon cho Thông báo (index 3)
                  _buildBarIcon(iconIndex: 3),
                  //icon cho Profile (index 4)
                  _buildBarIcon(iconIndex: 4),
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

  // Hàm build icon
  Widget _buildBarIcon({required int iconIndex}) {
    bool isSelected = (_pageIndex == iconIndex);
    final icons = _navIcons[iconIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: IconButton(
        icon: Icon(
          isSelected ? icons['filled']! : icons['outlined']!,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _pageIndex = iconIndex;
          });
        },
      ),
    );
  }
}
