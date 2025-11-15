// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/filter_panel.dart';
import '../widgets/home_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/suggested_places_section.dart';
import '../../../schedule/presentation/pages/schedule_page.dart';

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
            const SchedulePage(),
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
                  const CategoriesSection(), // ← XÓA `const` → vì không có const constructor
                  SuggestedPlacesSection(selectedQuan: selectedQuan),
                ],
              ),
            ),
            const Center(child: Text('Notifications Page')),
            const Center(child: Text('Profile Page')),
          ],
        ),
      ),
      //FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryBlue,
        elevation: 8.0,
        shape: const CircleBorder(),
        child: Icon(
          _navIcons[_currentIndex]
              ['filled'], // Hiển thị icon của trang hiện tại
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
                children: _buildSideItems(left: true),
              ),
              const SizedBox(width: 56),
              // 2 item bên phải
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _buildSideItems(left: false),
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
  // Build the left or right side items (two icons each)
  List<Widget> _buildSideItems({required bool left}) {
    // all indices
    final all = [0, 1, 2, 3, 4];
    // remove the selected index
    final others = all.where((i) => i != _currentIndex).toList();
    // left takes first 2, right takes last 2
    final leftItems = others.take(2).toList();
    final rightItems = others.skip(2).toList();
    final pick = left ? leftItems : rightItems;
    return pick.map((idx) {
      final icons = _navIcons[idx];
      final filled = icons['filled']!;
      final outlined = icons['outlined']!;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: IconButton(
          icon: Icon(_currentIndex == idx ? filled : outlined,
              color: Colors.white),
          onPressed: () => setState(() => _currentIndex = idx),
        ),
      );
    }).toList();
  }
}
