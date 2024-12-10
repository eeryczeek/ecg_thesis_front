import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class ECGPlot extends StatefulWidget {
  final List<Map<String, double>> ecgData;

  const ECGPlot({super.key, required this.ecgData});

  @override
  _ECGPlotState createState() => _ECGPlotState();
}

class _ECGPlotState extends State<ECGPlot> {
  String? selectedChannel;
  double? startX;
  double? endX;
  int? startIndex;
  int? endIndex;

  @override
  void initState() {
    super.initState();
    if (widget.ecgData.isNotEmpty) {
      selectedChannel = widget.ecgData.first.keys.first;
    }
  }

  List<FlSpot> _getSpots(List<Map<String, double>> data, String channel) {
    const int step = 10;
    final spots = <FlSpot>[];
    for (int i = 0; i < data.length; i += step) {
      spots.add(FlSpot(i.toDouble(), data[i][channel]!));
    }
    return spots;
  }

  void _onPanStart(DragStartDetails details, double plotWidth) {
    setState(() {
      startX = details.localPosition.dx;
      endX = null;
    });
  }

  void _onPanUpdate(DragUpdateDetails details, double plotWidth) {
    setState(() {
      endX = details.localPosition.dx;
    });
  }

  void _onPanEnd(DragEndDetails details, double plotWidth) {
    setState(() {
      startIndex = min((startX! / plotWidth * widget.ecgData.length).toInt(),
          (endX! / plotWidth * widget.ecgData.length).toInt());
      endIndex = max((startX! / plotWidth * widget.ecgData.length).toInt(),
          (endX! / plotWidth * widget.ecgData.length).toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    final channels =
        widget.ecgData.isNotEmpty ? widget.ecgData.first.keys.toList() : [];

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          DropdownButton<String>(
            value: selectedChannel,
            dropdownColor: Colors.black,
            onChanged: (String? newValue) {
              setState(() {
                selectedChannel = newValue;
              });
            },
            items: channels.map<DropdownMenuItem<String>>((dynamic channel) {
              return DropdownMenuItem<String>(
                value: channel,
                child:
                    Text(channel, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
          if (selectedChannel != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Channel: $selectedChannel',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      height: 200,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final plotWidth = constraints.maxWidth;
                          return MouseRegion(
                            child: GestureDetector(
                              onHorizontalDragStart: (details) =>
                                  _onPanStart(details, plotWidth),
                              onHorizontalDragUpdate: (details) =>
                                  _onPanUpdate(details, plotWidth),
                              onHorizontalDragEnd: (details) =>
                                  _onPanEnd(details, plotWidth),
                              child: Stack(
                                children: [
                                  LineChart(
                                    LineChartData(
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: _getSpots(
                                              widget.ecgData, selectedChannel!),
                                          isCurved: true,
                                          barWidth: 2,
                                          color: Colors.purpleAccent,
                                          belowBarData:
                                              BarAreaData(show: false),
                                          dotData: const FlDotData(show: false),
                                        ),
                                      ],
                                      titlesData:
                                          const FlTitlesData(show: false),
                                      borderData: FlBorderData(show: false),
                                      gridData: const FlGridData(show: false),
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                  if (startX != null && endX != null)
                                    Positioned(
                                      left: startX! < endX! ? startX! : endX!,
                                      width: (endX! - startX!).abs(),
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        color: Colors.blue.withOpacity(0.3),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
