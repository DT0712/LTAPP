// features/home/presentation/widgets/home_banner.dart
import 'dart:async';
import 'package:flutter/material.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> bannerImages = [
    'assets/images/banner/Banner1.jpg',
    'assets/images/banner/Banner2.jpg',
    'assets/images/banner/Banner3.jpg',
    'assets/images/banner/Banner4.jpg',
    'assets/images/banner/Banner5.jpg',
    'assets/images/banner/Banner6.jpg',
    'assets/images/banner/Banner7.jpg',
  ];

  @override
  void initState() {
    super.initState();

    // Tự động chuyển ảnh 3 giây
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % bannerImages.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          bannerImages.length,
          (index) {
            bool isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 10 : 6,
              height: isActive ? 10 : 6,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.white54,
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: PageView.builder(
                controller: _pageController,
                itemCount: bannerImages.length,
                onPageChanged: (value) {
                  setState(() => _currentIndex = value);
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    bannerImages[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),

          // Indicator
          _buildIndicator(),
        ],
      ),
    );
  }
}
