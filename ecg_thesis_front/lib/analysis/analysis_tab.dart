// FILE: lib/analysis/analysis_tab.dart

import 'package:ecg_thesis_front/parser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api_service.dart';
import '../control_panel.dart';
import '../providers.dart';
import '../analysed_plot.dart';
import 'ecg_dropzone_plot.dart';
import 'ecg_statistics.dart';

class AnalysisTab extends StatefulWidget {
  const AnalysisTab({super.key});

  @override
  _AnalysisTabState createState() => _AnalysisTabState();
}

class _AnalysisTabState extends State<AnalysisTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ECGDropzonePlot(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ControlPanel(),
                      ),
                      Text(
                        'Additional Information:',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      HeaderInformation(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final originalEcgProvider =
                              context.read<OriginalEcgProvider>();
                          final analysedEcgProvider =
                              context.read<AnalysedEcgProvider>();

                          final result = await apiService
                              .requestAnalysis(originalEcgProvider.ecg);
                          final parsedEcg = await ECGTxtParser().parse(result);

                          if (!mounted) return;
                          analysedEcgProvider.update(parsedEcg);
                        },
                        child: const Text('Request Analysis'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (context.watch<AnalysedEcgProvider>().ecg.data.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(height: 600, child: AnalysedPlot()),
            ),
        ],
      ),
    );
  }
}
