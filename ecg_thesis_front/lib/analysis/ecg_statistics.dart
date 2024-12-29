import 'package:flutter/material.dart';

class ECGStatistics extends StatelessWidget {
  final List<Map<String, double>> ecgData;

  const ECGStatistics({super.key, required this.ecgData});

  @override
  Widget build(BuildContext context) {
    if (ecgData.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final channel = ecgData.first.keys.first;
    final values = ecgData.map((data) => data[channel]!).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final avgValue = values.reduce((a, b) => a + b) / values.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics for channel: $channel',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          'Min Value: $minValue',
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          'Max Value: $maxValue',
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          'Average Value: $avgValue',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
