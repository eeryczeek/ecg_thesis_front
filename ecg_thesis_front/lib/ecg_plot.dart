import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'parser.dart';
import 'providers.dart';

class ECGPlot extends StatefulWidget {
  final Ecg ecg;
  final String? selectedChannel;

  const ECGPlot({required this.ecg, this.selectedChannel, Key? key})
      : super(key: key);

  @override
  _ECGPlotState createState() => _ECGPlotState();
}

class _ECGPlotState extends State<ECGPlot> {
  List<FlSpot> _spots = [];

  @override
  void initState() {
    super.initState();
    _spots =
        _generateSpots(widget.ecg.data, context.read<EcgPlotSettings>().step);
    context.read<EcgPlotSettings>().addListener(() {
      setState(() {
        _spots = _generateSpots(
            widget.ecg.data, context.read<EcgPlotSettings>().step);
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<FlSpot> _generateSpots(List<Map<String, double>> data, int step) {
    return List<FlSpot>.generate(
      data.length ~/ step,
      (i) => FlSpot(
          i * step.toDouble(),
          data[i * step][widget.selectedChannel ??
              context.read<EcgPlotSettings>().selectedChannel]!),
    );
  }

  double _parseSampleRate(String sampleRateString) {
    final match = RegExp(r'(\d+)').firstMatch(sampleRateString);
    return match != null ? double.parse(match.group(0)!) : 1.0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final deltaX = details.primaryDelta! /
        context.size!.width *
        (context.read<EcgPlotSettings>().maxX -
            context.read<EcgPlotSettings>().minX);
    context.read<EcgPlotSettings>().moveRange(-deltaX);
  }

  @override
  Widget build(BuildContext context) {
    final sampleRate =
        _parseSampleRate(widget.ecg.header.generalHeader['Sample Rate'] ?? '1');
    final minX = context.watch<EcgPlotSettings>().minX;
    final maxX = context.watch<EcgPlotSettings>().maxX;

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onHorizontalDragUpdate: _onPanUpdate,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots
                        .where((spot) => spot.x >= minX && spot.x <= maxX)
                        .toList(),
                    isCurved: true,
                    barWidth: 2,
                    color: Colors.white,
                    belowBarData: BarAreaData(show: false),
                    dotData: const FlDotData(show: false),
                  ),
                ],
                titlesData: _buildTitlesData(sampleRate),
                backgroundColor: Colors.black,
                minX: minX,
                maxX: maxX,
                borderData: _buildBorderData(),
                gridData: _buildGridData(),
                lineTouchData: LineTouchData(enabled: false),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

FlTitlesData _buildTitlesData(double sampleRate) {
  return FlTitlesData(
    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      axisNameWidget: Text(
        'Voltage [mV]',
        style: const TextStyle(color: Colors.white),
      ),
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          final scaledValue = value / 10000;
          return Text(
            scaledValue.toStringAsFixed(1),
            style: const TextStyle(color: Colors.white),
          );
        },
      ),
    ),
    bottomTitles: AxisTitles(
      axisNameWidget: Text(
        'Time [s]',
        style: const TextStyle(color: Colors.white),
      ),
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          final scaledValue = value / sampleRate;
          return Text(
            scaledValue.toStringAsFixed(1),
            style: const TextStyle(color: Colors.white),
          );
        },
      ),
    ),
  );
}

FlBorderData _buildBorderData() {
  return FlBorderData(
    show: true,
    border: Border.all(color: Colors.white, width: 1),
  );
}

FlGridData _buildGridData() {
  return FlGridData(
    show: true,
    drawVerticalLine: true,
    drawHorizontalLine: true,
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: Colors.white.withOpacity(0.2),
        strokeWidth: 1,
      );
    },
    getDrawingVerticalLine: (value) {
      return FlLine(
        color: Colors.white.withOpacity(0.2),
        strokeWidth: 1,
      );
    },
  );
}
