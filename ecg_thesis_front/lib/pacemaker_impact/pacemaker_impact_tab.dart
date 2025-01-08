import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers.dart';
import '../analysis/ecg_dropzone_plot.dart';
import '../api_service.dart';

class PacemakerImpactTab extends StatefulWidget {
  const PacemakerImpactTab({super.key});

  @override
  _PacemakerImpactTabState createState() => _PacemakerImpactTabState();
}

class _PacemakerImpactTabState extends State<PacemakerImpactTab> {
  @override
  Widget build(BuildContext context) {
    final ecgBeforeProvider = context.watch<EcgBeforeProvider>();
    final ecgAfterProvider = context.watch<EcgAfterProvider>();
    final beforSources = ecgBeforeProvider.ecgs.keys
        .where((key) => ecgBeforeProvider.ecgs[key]?.data.isNotEmpty ?? false)
        .toList();
    final afterSources = ecgAfterProvider.ecgs.keys
        .where((key) => ecgAfterProvider.ecgs[key]?.data.isNotEmpty ?? false)
        .toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ECG Before Treatment:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  ECGDropzonePlot(provider: ecgBeforeProvider),
                  const SizedBox(height: 20),
                  Row(children: [
                    ElevatedButton(
                      onPressed: () async {
                        final result = await apiService.requestAnalysis(
                            ecgBeforeProvider.ecgs["original"]!);
                        ecgBeforeProvider.update(result);
                      },
                      child: const Text('Request Analysis Before Treatment'),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: beforSources.map((source) {
                        return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  ecgBeforeProvider.setSource(source);
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    ecgBeforeProvider.source == source
                                        ? Colors.green
                                        : Colors.transparent),
                              ),
                              child: Text(source,
                                  style: TextStyle(color: Colors.white)),
                            ));
                      }).toList(),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton(
                      items: ecgBeforeProvider
                                  .ecgs["original"]?.data.isNotEmpty ??
                              false
                          ? ecgBeforeProvider.ecgs["original"]?.data.first.keys
                              .map((key) {
                              return DropdownMenuItem(
                                  value: key, child: Text(key));
                            }).toList()
                          : [],
                      onChanged: (value) {
                        ecgBeforeProvider.setSelectedChannel(value.toString());
                      },
                      value: ecgBeforeProvider.channel,
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const VerticalDivider(
              color: Colors.white,
              thickness: 20,
              width: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ECG After Treatment:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  ECGDropzonePlot(provider: ecgAfterProvider),
                  const SizedBox(height: 20),
                  Row(children: [
                    ElevatedButton(
                      onPressed: () async {
                        final result = await apiService.requestAnalysis(
                            ecgAfterProvider.ecgs["original"]!);
                        ecgAfterProvider.update(result);
                      },
                      child: const Text('Request Analysis After Treatment'),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: afterSources.map((source) {
                        return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  ecgAfterProvider.setSource(source);
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    ecgAfterProvider.source == source
                                        ? Colors.green
                                        : Colors.transparent),
                              ),
                              child: Text(source,
                                  style: TextStyle(color: Colors.white)),
                            ));
                      }).toList(),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton(
                      items: ecgAfterProvider
                                  .ecgs["original"]?.data.isNotEmpty ??
                              false
                          ? ecgAfterProvider.ecgs["original"]?.data.first.keys
                              .map((key) {
                              return DropdownMenuItem(
                                  value: key, child: Text(key));
                            }).toList()
                          : [],
                      onChanged: (value) {
                        ecgAfterProvider.setSelectedChannel(value.toString());
                      },
                      value: ecgAfterProvider.channel,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
