import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../control_panel.dart';
import '../providers.dart';
import 'ecg_dropzone_plot.dart';
import 'ecg_statistics.dart';

class AnalysisTab extends StatelessWidget {
  const AnalysisTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ecgDataProvider = Provider.of<FileDataProvider>(context);

    return SingleChildScrollView(
      child: Row(
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
                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        ecgDataProvider.ecg.header.generalHeader.entries
                            .map((entry) => '${entry.key}: ${entry.value}\n')
                            .join(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  HeaderInformation(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle analysis request
                    },
                    child: const Text('Request Analysis'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
