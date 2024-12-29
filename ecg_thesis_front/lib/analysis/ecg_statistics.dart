import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers.dart';

class HeaderInformation extends StatelessWidget {
  const HeaderInformation({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<FileDataProvider>().ecg.header.generalHeader.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final channel = context.watch<EcgPlotSettings>().selectedChannel;
    final values = context
        .watch<FileDataProvider>()
        .ecg
        .data
        .map((data) => data[channel]!)
        .toList();
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
