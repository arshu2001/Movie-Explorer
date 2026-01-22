class Booking {
  final String movieTitle;
  final String poster;
  final DateTime date;
  final String time;
  final int seats;
  final String cinema; // Dummy field

  Booking({
    required this.movieTitle,
    required this.poster,
    required this.date,
    required this.time,
    this.seats = 2,
    this.cinema = 'Cineplex Downtown',
  });
}
