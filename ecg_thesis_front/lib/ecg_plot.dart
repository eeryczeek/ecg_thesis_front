import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'providers.dart';

class ECGPlot extends StatefulWidget {
  final EcgProvider provider;
  final String? channel;

  const ECGPlot({required this.provider, this.channel, super.key});

  @override
  _ECGPlotState createState() => _ECGPlotState();
}

class _ECGPlotState extends State<ECGPlot> {
  List<FlSpot> _spots = [];

  @override
  void initState() {
    super.initState();
    _spots = _generateSpots(widget.provider.ecgs[widget.provider.source]!.data,
        widget.provider.resolution);
    widget.provider.addListener(() {
      setState(() {
        _spots = _generateSpots(
            widget.provider.ecgs[widget.provider.source]!.data,
            widget.provider.resolution);
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
      (i) => FlSpot(i * step.toDouble(),
          data[i * step][widget.channel ?? widget.provider.channel]!),
    );
  }

  double _parseSampleRate(String sampleRateString) {
    final match = RegExp(r'(\d+)').firstMatch(sampleRateString);
    return match != null ? double.parse(match.group(0)!) : 1.0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final deltaX = details.primaryDelta! /
        context.size!.width *
        (widget.provider.maxX - widget.provider.minX);
    widget.provider.moveRange(-deltaX);
  }

  List<VerticalRangeAnnotation> _generateQRSAnnotations(
      double minX, double maxX) {
    return widget.provider.qrsSlices
        .where((qrs) => qrs.Q.toDouble() >= minX && qrs.S.toDouble() <= maxX)
        .map((qrs) {
      return VerticalRangeAnnotation(
        x1: qrs.Q.toDouble(),
        x2: qrs.S.toDouble(),
        color: Colors.greenAccent.withOpacity(0.23),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final sampleRate = _parseSampleRate(widget
            .provider
            .ecgs[widget.provider.source]!
            .header
            .generalHeader['Sample Rate'] ??
        '1');
    final minX = widget.provider.minX;
    final maxX = widget.provider.maxX;

    double minY = 0;
    double maxY = 0;

    if (widget.provider.ecgs[widget.provider.source]!.data.isNotEmpty) {
      minY = widget.provider.ecgs[widget.provider.source]!.data
          .map((e) => e.values
              .reduce((value, element) => value < element ? value : element))
          .reduce((value, element) => value < element ? value : element);
      maxY = widget.provider.ecgs[widget.provider.source]!.data
          .map((e) => e.values
              .reduce((value, element) => value > element ? value : element))
          .reduce((value, element) => value > element ? value : element);
    }

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
                minY: minY,
                maxY: maxY,
                borderData: _buildBorderData(),
                gridData: _buildGridData(),
                lineTouchData: LineTouchData(enabled: false),
                rangeAnnotations: RangeAnnotations(
                  verticalRangeAnnotations: _generateQRSAnnotations(minX, maxX),
                ),
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
