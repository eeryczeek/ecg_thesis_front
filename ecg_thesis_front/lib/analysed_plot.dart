// FILE: lib/analysed_plot.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'providers.dart';

class AnalysedPlot extends StatefulWidget {
  const AnalysedPlot({super.key});

  @override
  _AnalysedPlotState createState() => _AnalysedPlotState();
}

class _AnalysedPlotState extends State<AnalysedPlot> {
  List<FlSpot> _spots = [];

  @override
  void initState() {
    super.initState();
    _spots = _generateSpots(
        context.read<AnalysisEcgProvider>().ecgs["original"]!.data,
        context.read<AnalysisEcgProvider>().resolution);
    context.read<AnalysisEcgProvider>().addListener(() {
      setState(() {
        _spots = _generateSpots(
            context.read<AnalysisEcgProvider>().ecgs["original"]!.data,
            context.read<AnalysisEcgProvider>().resolution);
      });
    });
  }

  List<FlSpot> _generateSpots(List<Map<String, double>> data, int step) {
    return List<FlSpot>.generate(
      data.length ~/ step,
      (i) => FlSpot(i * step.toDouble(),
          data[i * step][context.read<AnalysisEcgProvider>().channel]!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sampleRate = context.read<AnalysisEcgProvider>().sampleRate;
    final minX = context.watch<AnalysisEcgProvider>().minX;
    final maxX = context.watch<AnalysisEcgProvider>().maxX;

    return Column(
      children: [
        Expanded(
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
              borderData: _buildBorderData(),
              gridData: _buildGridData(),
              lineTouchData: LineTouchData(enabled: false),
            ),
          ),
        ),
      ],
    );
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
}
