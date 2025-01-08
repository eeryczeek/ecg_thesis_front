import 'package:flutter/material.dart';
import 'providers.dart';

class ControlPanel extends StatelessWidget {
  final EcgProvider provider;
  final bool channelSelection;
  const ControlPanel(
      {super.key, required this.provider, this.channelSelection = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            provider.setRange(2 * provider.sampleRate);
          },
          child: Text('2s'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            provider.setRange(4 * provider.sampleRate);
          },
          child: Text('4s'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            provider.setRange(8 * provider.sampleRate);
          },
          child: Text('8s'),
        ),
        const SizedBox(width: 8),
        Text('Precision:'),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: provider.resolution,
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
              provider.setStep(value);
            }
          },
        ),
        const SizedBox(width: 8),
        if (channelSelection) ...[
          const SizedBox(width: 8),
          _ChannelSelection(provider: provider),
        ],
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            provider.resetToDefault();
          },
          child: Text('Reset'),
        ),
      ],
    );
  }
}

class _ChannelSelection extends StatelessWidget {
  final EcgProvider provider;
  const _ChannelSelection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Text('Channel:'),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: provider.channel,
          items: provider.ecgs[provider.source]?.header.channelHeaders.keys
              .map<DropdownMenuItem<String>>((String channel) {
            return DropdownMenuItem<String>(
              value: channel,
              child: Text(channel),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              provider.setSelectedChannel(value);
            }
          },
        ),
      ],
    );
  }
}
