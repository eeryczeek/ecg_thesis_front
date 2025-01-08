// FILE: lib/visualizations/visualizations_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers.dart';
import '../ecg_plot.dart';
import '../control_panel.dart';

class VisualizationsTab extends StatelessWidget {
  const VisualizationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ControlPanel(
                provider: AnalysisEcgProvider(), channelSelection: false),
          ),
        ),
        Expanded(
          child: context
                  .read<AnalysisEcgProvider>()
                  .ecgs["original"]!
                  .data
                  .isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 2,
                    ),
                    itemCount: context
                        .read<AnalysisEcgProvider>()
                        .ecgs["original"]!
                        .data
                        .first
                        .keys
                        .length,
                    itemBuilder: (context, index) {
                      String channel = context
                          .read<AnalysisEcgProvider>()
                          .ecgs["original"]!
                          .header
                          .channelHeaders
                          .keys
                          .elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ECGPlot(
                          provider: context.read<AnalysisEcgProvider>(),
                          channel: channel,
                        ),
                      );
                    },
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
