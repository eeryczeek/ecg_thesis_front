import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import '../parser.dart';
import '../ecg_plot.dart';
import '../providers.dart';

class ECGDropzonePlot extends StatefulWidget {
  final EcgProvider provider;

  const ECGDropzonePlot({
    super.key,
    required this.provider,
  });

  @override
  _ECGDropzonePlotState createState() => _ECGDropzonePlotState();
}

class _ECGDropzonePlotState extends State<ECGDropzonePlot> {
  late DropzoneViewController controller;

  void _handleFileDrop(Uint8List fileData) async {
    final content = utf8.decode(fileData);
    final parser = ECGTxtParser();
    final ecg = await parser.parse(content);
    widget.provider.update({"original": ecg});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: widget.provider.ecgs["original"] == null
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
          if (widget.provider.ecgs["original"] == null)
            Center(
              child: Text(
                'Drop your ECG recording file here:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          if (widget.provider.ecgs["original"] != null)
            ECGPlot(provider: widget.provider),
        ],
      ),
    );
  }
}
