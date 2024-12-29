import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';
import '../providers.dart';
import '../ecg_parser.dart';
import '../ecg_plot.dart';

class ECGDropzonePlot extends StatefulWidget {
  const ECGDropzonePlot({super.key});

  @override
  _ECGDropzonePlotState createState() => _ECGDropzonePlotState();
}

class _ECGDropzonePlotState extends State<ECGDropzonePlot> {
  late DropzoneViewController controller;

  void _handleFileDrop(Uint8List fileData) async {
    final content = utf8.decode(fileData);
    final parser = ECGTxtParser();
    final ecg = await parser.parse(content);
    Provider.of<ECGDataProvider>(context, listen: false).updateEcgFile(ecg);
  }

  @override
  Widget build(BuildContext context) {
    final ecgDataProvider = Provider.of<ECGDataProvider>(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: ecgDataProvider.ecg.data.isEmpty
            ? Colors.grey.shade800
            : Colors.black,
      ),
      width: double.infinity,
      height: 400,
      child: Stack(
        children: [
          DropzoneView(
            onCreated: (controller) => this.controller = controller,
            onDropFile: (ev) async {
              final file = await controller.getFileData(ev);
              _handleFileDrop(file);
            },
          ),
          if (ecgDataProvider.ecg.data.isEmpty)
            Center(
              child: Text(
                'Drop your ECG recording file here:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          if (ecgDataProvider.ecg.data.isNotEmpty)
            ECGPlot(ecg: ecgDataProvider.ecg),
        ],
      ),
    );
  }
}
