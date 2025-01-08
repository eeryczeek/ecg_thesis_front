import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers.dart';

class HeaderInformation extends StatelessWidget {
  const HeaderInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<AnalysisEcgProvider>(
                builder: (context, originalEcgProvider, child) {
                  return Text(
                    originalEcgProvider
                        .ecgs["original"]!.header.generalHeader.entries
                        .map((entry) => '${entry.key}: ${entry.value}\n')
                        .join(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<AnalysisEcgProvider>(
                builder: (context, analysisEcgProvider, child) {
                  final selectedChannel = analysisEcgProvider.channel;
                  final channelHeader = analysisEcgProvider
                      .ecgs["original"]!.header.channelHeaders[selectedChannel];
                  if (channelHeader == null) {
                    return Text(
                      'No data for selected channel',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }
                  return Text(
                    channelHeader.header.entries
                        .map((entry) => '${entry.key}: ${entry.value}\n')
                        .join(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
