import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_movie_database/core/theme/app_theme.dart';
import 'package:the_movie_database/core/widgets/customtext.dart';
import 'package:the_movie_database/core/widgets/dimention.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.kWhite,
        leading: Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.kdark),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/movie/success.png",height: 106.h,),
            SizedBox(height: 24.h,),
            CustomText(
              text: "Booking successful",
              fontSize: Dimensions.fontSize20.spMin,
              fontWeight: FontWeight.w700,
              fontColor: AppTheme.kblack,
            ),
            CustomText(
              text: "for avengers",
              fontSize: Dimensions.fontSize20.spMin,
              fontWeight: FontWeight.w400,
              fontColor: Color(0xFF4A4F62)
            ),
          SizedBox(height: 32.h,),
          Image.asset("assets/images/movie/marvel.png",height: 478,)
          ],
        ),
      ),
    );
  }
}