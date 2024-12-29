import 'package:flutter/material.dart';
import 'parser.dart';

class FileDataProvider extends ChangeNotifier {
  Ecg _ecg = Ecg(EcgHeader({}, {}), []);
  double _sampleRate = 1;

  Ecg get ecg => _ecg;
  double get sampleRate => _sampleRate;

  void updateEcgFile(Ecg newEcg) {
    _ecg = newEcg;
    _sampleRate =
        _parseSampleRate(_ecg.header.generalHeader['Sample Rate'] ?? '1');
    notifyListeners();
  }
}

class EcgPlotSettings extends ChangeNotifier {
  String _selectedChannel = 'I';
  int _step = 1;
  double _minX = 0;
  double _maxX = 2000;

  int get step => _step;
  String get selectedChannel => _selectedChannel;
  double get minX => _minX;
  double get maxX => _maxX;

  void setStep(int newStep) {
    _step = newStep;
    notifyListeners();
  }

  void setSelectedChannel(String newChannel) {
    _selectedChannel = newChannel;
    notifyListeners();
  }

  void setRange(double newRange) {
    _maxX = _minX + newRange;
    notifyListeners();
  }

  void moveRange(double deltaX) {
    _minX += deltaX;
    _maxX += deltaX;
    notifyListeners();
  }

  void resetToDefault() {
    _selectedChannel = 'I';
    _step = 1;
    _minX = 0;
    _maxX = 2000;
    notifyListeners();
  }
}

double _parseSampleRate(String sampleRateString) {
  final match = RegExp(r'(\d+)').firstMatch(sampleRateString);
  return match != null ? double.parse(match.group(0)!) : 1.0;
}
