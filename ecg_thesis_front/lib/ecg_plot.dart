import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'ecg_parser.dart';
import 'providers.dart';

class ECGPlot extends StatefulWidget {
  final Ecg ecg;
  final String? selectedChannel;

  const ECGPlot({
    super.key,
    required this.ecg,
    this.selectedChannel,
  });

  @override
  _ECGPlotState createState() => _ECGPlotState();
}

class _ECGPlotState extends State<ECGPlot> {
  List<FlSpot> _spots = [];

  @override
  void initState() {
    super.initState();
    _spots = _generateSpots(
        widget.ecg.data,
        widget.selectedChannel ??
            context.read<EcgPlotSettings>().selectedChannel,
        context.read<EcgPlotSettings>().step);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<EcgPlotSettings>().addListener(_updateRange);
  }

  @override
  void dispose() {
    context.read<EcgPlotSettings>().removeListener(_updateRange);
    super.dispose();
  }

  void _updateRange() {
    setState(() {
      _spots = _generateSpots(
          widget.ecg.data,
          widget.selectedChannel ??
              context.read<EcgPlotSettings>().selectedChannel,
          context.read<EcgPlotSettings>().step);
    });
  }

  List<FlSpot> _generateSpots(
      List<Map<String, double>> data, String channel, int step) {
    return List<FlSpot>.generate(
      data.length ~/ step,
      (i) => FlSpot(i * step.toDouble(), data[i * step][channel]!),
    );
  }

  double _parseSampleRate(String sampleRateString) {
    final match = RegExp(r'(\d+)').firstMatch(sampleRateString);
    return match != null ? double.parse(match.group(0)!) : 1.0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final ecgPlotSettings = context.read<EcgPlotSettings>();
    setState(() {
      final deltaX =
          details.primaryDelta! / context.size!.width * ecgPlotSettings.range;
      double newMinX = ecgPlotSettings.minX - deltaX;
      double newMaxX = ecgPlotSettings.maxX - deltaX;

      // Ensure the plot is always contained within the chart
      if (newMinX < 0) {
        newMinX = 0;
        newMaxX = ecgPlotSettings.range;
      }
      if (newMaxX > widget.ecg.data.length.toDouble()) {
        newMaxX = widget.ecg.data.length.toDouble();
        newMinX = newMaxX - ecgPlotSettings.range;
      }

      ecgPlotSettings.setMinX(newMinX);
      ecgPlotSettings.setMaxX(newMaxX);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sampleRate =
        _parseSampleRate(widget.ecg.header.generalHeader['Sample Rate'] ?? '1');
    final step = context.watch<EcgPlotSettings>().step;
    final minX = context.watch<EcgPlotSettings>().minX;
    final maxX = context.watch<EcgPlotSettings>().maxX;

    _spots = _generateSpots(
        widget.ecg.data,
        widget.selectedChannel ??
            context.read<EcgPlotSettings>().selectedChannel,
        step);

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
            final scaledValue = value / 1000;
            return Text(
              scaledValue.toStringAsFixed(1),
              style: const TextStyle(color: Colors.white, fontSize: 10),
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
            return SideTitleWidget(
              axisSide: AxisSide.bottom,
              child: Text(
                scaledValue.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          },
        ),
      ),
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border.all(color: Colors.white),
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
