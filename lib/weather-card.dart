import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForecastCard(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          spacing: 5,
          children: [
            Text(
              time,
              maxLines: 1,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              icon,
              size: 18,
            ),
            Text(
              temperature,
            ),
          ],
        ),
      ),
    );
  }
}
