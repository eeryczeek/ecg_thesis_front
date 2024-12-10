import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'ecg_parser.dart';
import 'ecg_plot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG Plotter',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'ECG Plotter Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DropzoneViewController controller;
  List<Map<String, double>> ecgData = [];

  void _handleFileDrop(Uint8List fileData) async {
    final content = utf8.decode(fileData);
    final parser = ECGTxtParser();
    final ecg = await parser.parse(content);
    setState(() {
      ecgData = ecg.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          DropzoneView(
            onCreated: (controller) => this.controller = controller,
            onDropFile: (ev) async {
              final file = await controller.getFileData(ev);
              _handleFileDrop(file);
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Drop your ECG recording file here:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                ecgData.isNotEmpty
                    ? Expanded(child: ECGPlot(ecgData: ecgData))
                    : const Text('No ECG data to display'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
