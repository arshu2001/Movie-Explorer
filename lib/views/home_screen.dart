import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_movie_database/core/theme/app_theme.dart';
import 'package:the_movie_database/core/widgets/customtext.dart';
import 'package:the_movie_database/core/widgets/dimention.dart';
import 'package:the_movie_database/models/movie.dart';
import 'package:the_movie_database/providers/movie_provider.dart';
import 'package:the_movie_database/views/movie_details_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final movieNotifier = ref.read(movieProvider.notifier);
    final pageController = usePageController(viewportFraction: 0.6);
    final activeIndex = useState(0);
    
    // Fetch some initial data for "Upcoming" or "Trending" pseudo-lists
    useEffect(() {
      Future.microtask(() => movieNotifier.search('Marvel'));
      return null;
    }, []);

    final movieState = ref.watch(movieProvider);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section (Featured)
            // Top Section (Featured)
            SizedBox(
              height: 550.h,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Background Image
                  Container(
                    height: 450.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/movie/home__background.png'),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.scaffoldBackgroundColor.withOpacity(0.1),
                          AppTheme.scaffoldBackgroundColor.withOpacity(0.8),
                          AppTheme.scaffoldBackgroundColor,
                        ],
                        stops: const [0.0, 0.4, 0.7, 1.0],
                      ),
                    ),
                  ),

                  // Content Overlay
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          // Search Bar
                          SizedBox(height: 10.h),
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: TextField(
                              controller: searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Search Movie',
                                hintStyle: TextStyle(color: Colors.white70, fontSize: 14.spMin),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Image.asset(
                                    "assets/images/icon/search-normal.png",
                                    height: 20.h,
                                    width: 20.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                              ),
                              onSubmitted: (val) {
                                movieNotifier.search(val);
                                activeIndex.value = 0;
                              },
                            ),
                          ),
                          
                          SizedBox(height: 60.h),
                          
                          // Featured Movie Info
                          Column( 
                            children: [
                              // Play Button
                              Container(
                                width: 42.w,
                                height: 60.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: Image.asset("assets/images/icon/play.png",height: 42.h,),
                              ),
                              SizedBox(height: 16.h),
                              
                              // Tags
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildTag('Drama'),
                                  SizedBox(width: 10.w),
                                  _buildTag('12+'),
                                  SizedBox(width: 10.w),
                                  _buildTag('Action'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Hero Carousel (Positioned at bottom of stack)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 220.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 192.h,
                          child: PageView.builder(
                            controller: pageController,
                            onPageChanged: (index) {
                              activeIndex.value = index;
                            },
                            itemCount: movieState.movies.length > 5 ? 5 : movieState.movies.length,
                            itemBuilder: (context, index) {
                              return AnimatedBuilder(
                                animation: pageController,
                                builder: (context, child) {
                                  double diff = 0;
                                  if (pageController.position.haveDimensions) {
                                      diff = (index - (pageController.page ?? 0.0)).abs().toDouble();
                                  } else {
                                      diff = (index - activeIndex.value).abs().toDouble(); 
                                  }
                                  diff = diff.clamp(0.0, 1.0);
                                  double w = 133.w + (173.w - 133.w) * diff;
                                  double h = 192.h - (192.h - 119.h) * diff;
                                  
                                  return Center(
                                    child: SizedBox(
                                      height: h,
                                      width: w,
                                      child: _buildHeroCard(context, movieState.movies[index], index, diff),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Dots Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(movieState.movies.length > 5 ? 5 : movieState.movies.length, (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: index == activeIndex.value ? 24.w : 6.w, 
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: index == activeIndex.value ? Colors.white : Colors.white24,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Trending Movie Near You
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const CustomText(
                text: 'Trending Movie Near You',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontColor: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            
            // Mock Horizontal List 1 (Wide Cards)
            SizedBox(
              height: 160.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                scrollDirection: Axis.horizontal,
                itemCount: movieState.movies.length > 5 ? 5 : movieState.movies.length,
                separatorBuilder: (_, __) => SizedBox(width: 16.w),
                itemBuilder: (context, index) {
                  final movie = movieState.movies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsScreen(imdbId: movie.imdbID),
                        ),
                      );
                    },
                    child: Container(
                      width: 250.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        image: DecorationImage(
                          image: NetworkImage(movie.poster),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                          ),
                        ),
                        padding: EdgeInsets.all(12.w),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.spMin,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 24.h),

            // Upcoming
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const CustomText(
                text: 'Upcoming',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontColor: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            
            // Mock Horizontal List 2 (Portrait Cards with Book Button)
            SizedBox(
              height: 220.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                scrollDirection: Axis.horizontal,
                 itemCount: movieState.movies.length > 5 ? 5 : movieState.movies.length,
                separatorBuilder: (_, __) => SizedBox(width: 16.w),
                itemBuilder: (context, index) {
                  // Reverse order for variety
                   final movie = movieState.movies[movieState.movies.length - 1 - index];
                  return GestureDetector(
                    onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(imdbId: movie.imdbID),
                          ),
                        );
                    },
                    child: Container(
                      width: 140.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        image: DecorationImage(
                          image: NetworkImage(movie.poster),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                           Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Text(
                                  'Book Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.spMin,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 100.h), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, Movie movie, int index, double diff) {
    double buttonScale = (1.0 - diff * 2).clamp(0.0, 1.0);
    
    return GestureDetector(
      onTap: () {
         Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(imdbId: movie.imdbID),
            ),
          );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          image: DecorationImage(
            image: NetworkImage(movie.poster),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                    stops: const [0.5, 1.0]),
              ),
            ),
            
            // Book Now Button
            if (buttonScale > 0.1)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Transform.scale(
                scale: buttonScale,
                child: Opacity(
                  opacity: buttonScale,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(color: Colors.white54),
                      boxShadow: [
                         BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ],
                      // Glassmorphism effect
                    ),
                    child: CustomText(
                      text: "Book Now",
                      fontSize: Dimensions.fontSize14.spMin,
                      fontWeight: FontWeight.w400,
                      fontColor: AppTheme.kWhite,
                    )
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.spMin,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
