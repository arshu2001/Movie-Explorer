import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_movie_database/core/theme/app_theme.dart';
import 'package:the_movie_database/providers/movie_provider.dart';
import 'package:the_movie_database/views/booking_screen.dart';

class MovieDetailsScreen extends HookConsumerWidget {
  final String imdbId;

  const MovieDetailsScreen({super.key, required this.imdbId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailsProvider(imdbId));

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        body: movieAsync.when(
          data: (movie) => CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: AppTheme.scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: movie.poster,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[900],
                          child: const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black87,
                              AppTheme.scaffoldBackgroundColor,
                            ],
                            stops: [0.5, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.black),
                                const SizedBox(width: 4),
                                Text(
                                  movie.imdbRating,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${movie.year} • ${movie.genre} • ${movie.runtime}',
                        style: const TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Plot Summary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.plot,
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoRow('Director', movie.director),
                      const SizedBox(height: 12),
                      _buildInfoRow('Cast', movie.actors),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(
                                  movieTitle: movie.title,
                                  poster: movie.poster,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text('Error: $err', style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.secondaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
