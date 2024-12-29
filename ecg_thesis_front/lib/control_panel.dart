import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers.dart';

class ControlPanel extends StatelessWidget {
  final bool channelSelection;
  const ControlPanel({super.key, this.channelSelection = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            context
                .read<EcgPlotSettings>()
                .setRange(2 * context.read<FileDataProvider>().sampleRate);
          },
          child: Text('2s'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            context
                .read<EcgPlotSettings>()
                .setRange(4 * context.read<FileDataProvider>().sampleRate);
          },
          child: Text('4s'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            context
                .read<EcgPlotSettings>()
                .setRange(8 * context.read<FileDataProvider>().sampleRate);
          },
          child: Text('8s'),
        ),
        const SizedBox(width: 8),
        Text('Precision:'),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: context.watch<EcgPlotSettings>().step,
          items: const [
            DropdownMenuItem(value: 1, child: Text('1/1')),
            DropdownMenuItem(value: 2, child: Text('1/2')),
            DropdownMenuItem(value: 4, child: Text('1/4')),
            DropdownMenuItem(value: 8, child: Text('1/8')),
            DropdownMenuItem(value: 16, child: Text('1/16')),
            DropdownMenuItem(value: 32, child: Text('1/32')),
          ],
          onChanged: (value) {
            if (value != null) {
              context.read<EcgPlotSettings>().setStep(value);
            }
          },
        ),
        if (channelSelection) ...[
          const SizedBox(width: 8),
          _ChannelSelection(),
        ],
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            context.read<EcgPlotSettings>().resetToDefault();
          },
          child: Text('Reset'),
        ),
      ],
    );
  }
}

class _ChannelSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Text('Channel:'),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: context.watch<EcgPlotSettings>().selectedChannel,
          items: context
              .read<FileDataProvider>()
              .ecg
              .header
              .channelHeaders
              .keys
              .map<DropdownMenuItem<String>>((String channel) {
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
