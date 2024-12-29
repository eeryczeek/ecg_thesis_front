import 'package:flutter/material.dart';
import 'ecg_parser.dart';

class ECGDataProvider extends ChangeNotifier {
  Ecg _ecg = Ecg(EcgHeader({}, {}), []);

  Ecg get ecg => _ecg;

  void updateEcgFile(Ecg newEcg) {
    _ecg = newEcg;
    notifyListeners();
  }
}

class EcgPlotSettings extends ChangeNotifier {
  double _range = 100;
  int _step = 1;
  String _selectedChannel = 'I';
  double _minX = 0;
  double _maxX = 100;

  double get range => _range;
  int get step => _step;
  String get selectedChannel => _selectedChannel;
  double get minX => _minX;
  double get maxX => _maxX;

  void setRange(double newRange) {
    _range = newRange;
    notifyListeners();
  }

  void setStep(int newStep) {
    _step = newStep;
    notifyListeners();
  }

  void setSelectedChannel(String newChannel) {
    _selectedChannel = newChannel;
    notifyListeners();
  }

  void setMinX(double newMinX) {
    _minX = newMinX;
    notifyListeners();
  }

  void setMaxX(double newMaxX) {
    _maxX = newMaxX;
    notifyListeners();
  }
}
