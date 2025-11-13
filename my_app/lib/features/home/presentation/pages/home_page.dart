// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/filter_panel.dart';
import '../widgets/home_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/suggested_places_section.dart';

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
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            const Center(child: Text('Schedule Page')),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _currentIndex = 2),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.black,
        elevation: 6,
        shape: const CircleBorder(),
        child: Icon(
          _currentIndex == 2 ? Icons.home : Icons.home_outlined,
          color: Colors.black,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: primaryBlue,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
                0, Icons.calendar_today, Icons.calendar_today_outlined),
            _buildNavItem(1, Icons.chat_bubble, Icons.chat_bubble_outline),
            const SizedBox(width: 40),
            _buildNavItem(3, Icons.notifications, Icons.notifications_outlined),
            _buildNavItem(4, Icons.person, Icons.person_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData filled, IconData outlined) {
    return IconButton(
      icon:
          Icon(_currentIndex == index ? filled : outlined, color: Colors.white),
      onPressed: () => setState(() => _currentIndex = index),
    );
  }
}
