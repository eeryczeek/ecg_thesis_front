import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers.dart';

class ECGControlPanel extends StatelessWidget {
  const ECGControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ecgDataProvider = Provider.of<ECGDataProvider>(context);
    final channels = ecgDataProvider.ecg.header.channelHeaders.keys.toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => context.read<EcgPlotSettings>().setRange(2000),
          child: const Text('2s'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => context.read<EcgPlotSettings>().setRange(4000),
          child: const Text('4s'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => context.read<EcgPlotSettings>().setRange(8000),
          child: const Text('8s'),
        ),
        const SizedBox(width: 8),
        Text('Precision:'),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: context.watch<EcgPlotSettings>().step,
          items: const [
            DropdownMenuItem(value: 1, child: Text('1/1')),
            DropdownMenuItem(value: 4, child: Text('1/4')),
            DropdownMenuItem(value: 16, child: Text('1/16')),
            DropdownMenuItem(value: 64, child: Text('1/64')),
          ],
          onChanged: (value) {
            if (value != null) {
              context.read<EcgPlotSettings>().setStep(value);
            }
          },
        ),
        const SizedBox(width: 8),
        Text('Channel:'),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: context.watch<EcgPlotSettings>().selectedChannel,
          items: channels.map<DropdownMenuItem<String>>((String channel) {
            return DropdownMenuItem<String>(
              value: channel,
              child: Text(channel),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<EcgPlotSettings>().setSelectedChannel(value);
            }
          },
        ),
      ],
    );
  }
}
