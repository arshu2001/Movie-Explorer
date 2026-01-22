import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_movie_database/core/theme/app_theme.dart';
import 'package:the_movie_database/views/home_screen.dart';

class BottomNavScreen extends HookWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    final screens = useMemoized(() => [
      const HomeScreen(),
      const DummyScreen(title: 'Find Movies'),
      const DummyScreen(title: 'Saved Movies'),
      const DummyScreen(title: 'Profile'),
    ]);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: currentIndex.value,
        children: screens,
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: const Color(0xFF2C0002),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              currentIndex: currentIndex.value,
              iconPath: 'assets/images/icon/home.png',
              label: 'Home',
              onTap: () => currentIndex.value = 0,
            ),
            _buildNavItem(
              index: 1,
              currentIndex: currentIndex.value,
              iconPath: 'assets/images/icon/search.png',
              label: 'Find',
              onTap: () => currentIndex.value = 1,
            ),
            _buildNavItem(
              index: 2,
              currentIndex: currentIndex.value,
              iconPath: 'assets/images/icon/saved.png',
              label: 'Saved',
              onTap: () => currentIndex.value = 2,
            ),
            _buildNavItem(
              index: 3,
              currentIndex: currentIndex.value,
              iconPath: 'assets/images/icon/profile (3).png',
              label: 'Profile',
              onTap: () => currentIndex.value = 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = index == currentIndex;
    
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              iconPath,
              width: 24.w,
              height: 24.w,
              color: index == 3 
                  ? null // Profile image 
                  : (isSelected ? AppTheme.primaryColor : Colors.grey), // Icons -> Tint Red (active) or Grey (inactive)
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12.spMin,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class DummyScreen extends StatelessWidget {
  final String title;
  const DummyScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title Page',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
