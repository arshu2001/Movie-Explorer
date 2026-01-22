import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:the_movie_database/core/theme/app_theme.dart';
import 'package:the_movie_database/views/success.dart';

class BookingScreen extends HookWidget {
  final String movieTitle;
  final String poster;

  const BookingScreen({
    super.key,
    required this.movieTitle,
    required this.poster,
  });

  @override
  Widget build(BuildContext context) {
    // State for selection
    final selectedDate = useState(DateTime.now());
    final selectedTime = useState<String?>(null);
    final confirmed = useState(false);

    // Dummy data
    final dates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
    final times = ['10:00 AM', '1:00 PM', '4:00 PM', '7:00 PM', '10:00 PM'];

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Select Date & Time'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Info Summary
            Row(
              children: [
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(poster),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Cineplex Downtown',
                        style: TextStyle(color: AppTheme.secondaryTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Date Selection
            const Text(
              'Select Date',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final date = dates[index];
                  final isSelected = date.day == selectedDate.value.day && 
                                   date.month == selectedDate.value.month;
                  
                  return GestureDetector(
                    onTap: () => selectedDate.value = date,
                    child: Container(
                      width: 70,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected ? null : Border.all(color: Colors.grey[800]!),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getMonth(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date.day.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getWeekday(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // Time Selection
            const Text(
              'Select Time',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: times.map((time) {
                final isSelected = selectedTime.value == time;
                return GestureDetector(
                  onTap: () => selectedTime.value = time,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(25),
                      border: isSelected ? null : Border.all(color: Colors.grey[800]!),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessScreen(),));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  disabledBackgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, String title, DateTime date, String time) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              QrImageView(
                data: '$title|$date|$time',
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                'Bring this code to the cinema',
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).popUntil((route) => route.isFirst); // Go to Home
                  },
                  child: const Text('Done', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonth(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  }

  String _getWeekday(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
