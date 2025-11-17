// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/filter_panel.dart';
import '../widgets/home_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/suggested_places_section.dart';

// 🔥 THAY SchedulePage → TourPage
import '../../../tour/presentation/pages/tour_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryBlue = Color(0xFFAED2FF);
  static const Color backgroundColor = Color(0xFFF7F9FC);

  int _currentIndex = 2;
  String? selectedQuan;
  bool showFilterPanel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            // 🔥 Trang 0 = TourPage thay cho SchedulePage
            const TourPage(),

            const Center(child: Text('Chat Page')),

            SingleChildScrollView(
              child: Column(
                children: [
                  HomeAppBar(
                    onFilterTap: () =>
                        setState(() => showFilterPanel = !showFilterPanel),
                  ),
                  if (showFilterPanel)
                    FilterPanel(
                      selectedQuan: selectedQuan,
                      onQuanSelected: (quan) => setState(() {
                        selectedQuan = quan;
                        showFilterPanel = false;
                      }),
                      onClear: () => setState(() {
                        selectedQuan = null;
                        showFilterPanel = false;
                      }),
                    ),
                  const HomeBanner(),
                  const CategoriesSection(),
                  SuggestedPlacesSection(selectedQuan: selectedQuan),
                ],
              ),
            ),

            const Center(child: Text('Notifications Page')),
            const Center(child: Text('Profile Page')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryBlue,
        elevation: 8.0,
        shape: const CircleBorder(),
        child: Icon(
          _navIcons[_currentIndex]['filled'],
          color: Colors.black,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: primaryBlue,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: _buildSideItems(left: true),
              ),
              const SizedBox(width: 56),
              Row(
                children: _buildSideItems(left: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  List<Widget> _buildSideItems({required bool left}) {
    final all = [0, 1, 2, 3, 4];
    final others = all.where((i) => i != _currentIndex).toList();

    final leftItems = others.take(2).toList();
    final rightItems = others.skip(2).toList();

    final pick = left ? leftItems : rightItems;

    return pick.map((idx) {
      final filled = _navIcons[idx]['filled']!;
      final outlined = _navIcons[idx]['outlined']!;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: IconButton(
          icon: Icon(
            _currentIndex == idx ? filled : outlined,
            color: Colors.white,
          ),
          onPressed: () => setState(() => _currentIndex = idx),
        ),
      );
    }).toList();
  }
}
