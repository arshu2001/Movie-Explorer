import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_movie_database/models/booking.dart';

class BookingNotifier extends StateNotifier<List<Booking>> {
  BookingNotifier() : super([]);

  void addBooking(Booking booking) {
    state = [...state, booking];
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, List<Booking>>((ref) {
  return BookingNotifier();
});
