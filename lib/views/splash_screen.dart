import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ensure ScreenUtil is available
import 'package:the_movie_database/core/theme/app_theme.dart';
import 'package:the_movie_database/core/widgets/custom_button.dart';
import 'package:the_movie_database/core/widgets/customtext.dart';
import 'package:the_movie_database/core/widgets/dimention.dart';
import 'package:the_movie_database/views/bottom_nav_screen.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final index = useState(0);

    final pages = useMemoized(() => [
      {
        'image': 'assets/images/logo/splash1.png',
        'text': 'Catch Every Blockbuster Without\nthe Queue',
        'textColor': AppTheme.kdark,
        'btnColor': Colors.black.withValues(alpha: 0.1),
        'btnTextColor': Colors.white,
        'gradientColor': const Color(0xFF9C9F8E), 
        'gradientStops': [0.0, 0.4, 1.0], 
      },
      {
        'image': 'assets/images/logo/splash2.png',
        'text': 'Because MoviesDeserve\nMore Than Queues',
        'textColor': AppTheme.kWhite,
        'btnColor': Colors.black.withValues(alpha:  0.1),
        'btnTextColor': Colors.white,
        'gradientColor': const Color(0xFF2B527A),
        'gradientStops': [0.0, 0.5, 1.0],
      }
    ]);

    void goToHome() {
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNavScreen()),
      );
    }

    void next() {
      if (index.value < pages.length - 1) {
        index.value++;
      } else {
        goToHome();
      }
    }

    useEffect(() {
      final timer = Timer(const Duration(seconds: 400), () {
        next();
      });
      return timer.cancel;
    }, [index.value]);

    final activePage = pages[index.value];
    final gradientColor = activePage['gradientColor'] as Color;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            activePage['image'] as String,
            fit: BoxFit.cover, 
            errorBuilder: (context, error, stackTrace) {
               return Container(color: AppTheme.scaffoldBackgroundColor);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 0.7.sh, // Responsive height
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    gradientColor.withValues(alpha:  0.0), 
                    gradientColor.withValues(alpha:  0.6),
                    gradientColor,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: activePage['text'] as String,
                    fontSize: 33.spMin, // Large text
                    fontWeight: FontWeight.w700,
                    fontColor: activePage['textColor'] as Color,
                    height: 1.2,
                  ),
                  SizedBox(height: 40.h),
                  DefaultElevatedButton(
                    onPressed: next,
                    backgroundColor: activePage['btnColor'] as Color,
                    width: double.infinity,
                    height: 48.h,
                    borderRadius: 30,
                    child: CustomText(
                      text: 'NEXT',
                      fontColor: activePage['btnTextColor'] as Color,
                      fontSize: Dimensions.fontSize16.spMin,
                      fontWeight: FontWeight.w500,
                      // style: TextStyle(
                      //   color: activePage['btnTextColor'] as Color,
                      //   fontSize: 16.spMin,
                      //   fontWeight: FontWeight.bold,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}