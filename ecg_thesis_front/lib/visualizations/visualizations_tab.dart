import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers.dart';
import '../analysis/ecg_dropzone_plot.dart';
import '../ecg_plot.dart';
import '../control_panel.dart';

class VisualizationsTab extends StatelessWidget {
  const VisualizationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ecgDataProvider = Provider.of<FileDataProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ControlPanel(channelSelection: false),
        ),
        Expanded(
          child: ecgDataProvider.ecg.data.isEmpty
              ? ECGDropzonePlot()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: ecgDataProvider.ecg.data.first.keys.length,
                    itemBuilder: (context, index) {
                      String channel = ecgDataProvider
                          .ecg.header.channelHeaders.keys
                          .elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ECGPlot(
                          ecg: ecgDataProvider.ecg,
                          selectedChannel: channel,
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
