import 'package:flutter/material.dart';
import 'parser.dart';

abstract class EcgProvider extends ChangeNotifier {
  Map<String, Ecg> get ecgs;
  List<QRS> get qrsSlices;
  String get source;
  String get channel;
  double get sampleRate;
  int get resolution;
  double get minY;
  double get maxY;
  double get minX;
  double get maxX;

  void update(Map<String, dynamic> input);
  void setSource(String name);
  void setStep(int newResolution);
  void setSelectedChannel(String newChannel);
  void setRange(double newRange);
  void moveRange(double deltaX);
  void resetToDefault();
}

class AnalysisEcgProvider extends EcgProvider {
  final Map<String, Ecg> _ecgs = {"original": Ecg(EcgHeader({}, {}), [])};
  List<QRS> _qrsSlices = [QRS(0, 0, 0)];
  String _source = "original";
  String _channel = 'I';
  double _sampleRate = 1;
  int _resolution = 1;
  double _minY = 0;
  double _maxY = 0;
  double _minX = 0;
  double _maxX = 2000;

  @override
  Map<String, Ecg> get ecgs => _ecgs;
  @override
  List<QRS> get qrsSlices => _qrsSlices;
  @override
  String get source => _source;
  @override
  String get channel => _channel;
  @override
  double get sampleRate => _sampleRate;
  @override
  int get resolution => _resolution;
  @override
  double get minY => _minY;
  @override
  double get maxY => _maxY;
  @override
  double get minX => _minX;
  @override
  double get maxX => _maxX;

  @override
  void update(Map<String, dynamic> input) {
    _ecgs["original"] = input["original"] ?? Ecg(EcgHeader({}, {}), []);
    _ecgs["no_pacemaker"] = input["no_pacemaker"] ?? Ecg(EcgHeader({}, {}), []);
    _ecgs["cleaned"] = input["cleaned"] ?? Ecg(EcgHeader({}, {}), []);
    _qrsSlices = input["qrs_slices"] ?? [QRS(0, 0, 0)];
    _sampleRate = _parseSampleRate(
        _ecgs[_source]?.header.generalHeader['Sample Rate']?.toString() ?? '1');
    _minY = _ecgs[_source]!
        .data
        .map((e) => e.values
            .reduce((value, element) => value < element ? value : element))
        .reduce((value, element) => value < element ? value : element);
    _maxY = _ecgs[_source]!
        .data
        .map((e) => e.values
            .reduce((value, element) => value > element ? value : element))
        .reduce((value, element) => value > element ? value : element);
    notifyListeners();
  }

  @override
  void setStep(int newResolution) {
    _resolution = newResolution;
    notifyListeners();
  }

  @override
  void setSource(String source) {
    _source = source;
    notifyListeners();
  }

  @override
  void setSelectedChannel(String newChannel) {
    _channel = newChannel;
    notifyListeners();
  }

  @override
  void setRange(double newRange) {
    _maxX = _minX + newRange;
    notifyListeners();
  }

  @override
  void moveRange(double deltaX) {
    _minX += deltaX;
    _maxX += deltaX;
    notifyListeners();
  }

  @override
  void resetToDefault() {
    _channel = 'I';
    _resolution = 1;
    _minX = 0;
    _maxX = 2000;
    notifyListeners();
  }
}

class EcgBeforeProvider extends EcgProvider {
  final Map<String, Ecg> _ecgs = {"original": Ecg(EcgHeader({}, {}), [])};
  List<QRS> _qrsSlices = [QRS(0, 0, 0)];
  String _source = "original";
  String _channel = 'I';
  double _sampleRate = 1;
  int _resolution = 1;
  double _minY = 0;
  double _maxY = 0;
  double _minX = 0;
  double _maxX = 2000;

  @override
  Map<String, Ecg> get ecgs => _ecgs;
  @override
  List<QRS> get qrsSlices => _qrsSlices;
  @override
  String get source => _source;
  @override
  String get channel => _channel;
  @override
  double get sampleRate => _sampleRate;
  @override
  int get resolution => _resolution;
  @override
  double get minY => _minY;
  @override
  double get maxY => _maxY;
  @override
  double get minX => _minX;
  @override
  double get maxX => _maxX;

  @override
  void update(Map<String, dynamic> input) {
    _ecgs["original"] = input["original"] ?? Ecg(EcgHeader({}, {}), []);
    _ecgs["no_pacemaker"] = input["no_pacemaker"] ?? Ecg(EcgHeader({}, {}), []);
    _ecgs["cleaned"] = input["cleaned"] ?? Ecg(EcgHeader({}, {}), []);
    _qrsSlices = input["qrs_slices"] ?? [QRS(0, 0, 0)];
    _sampleRate = _parseSampleRate(
        _ecgs[_source]?.header.generalHeader['Sample Rate']?.toString() ?? '1');
    _minY = _ecgs[_source]!
        .data
        .map((e) => e.values
            .reduce((value, element) => value < element ? value : element))
        .reduce((value, element) => value < element ? value : element);
    _maxY = _ecgs[_source]!
        .data
        .map((e) => e.values
            .reduce((value, element) => value > element ? value : element))
        .reduce((value, element) => value > element ? value : element);
    notifyListeners();
  }

  @override
  void setStep(int newResolution) {
    _resolution = newResolution;
    notifyListeners();
  }

  @override
  void setSource(String source) {
    _source = source;
    notifyListeners();
  }

  @override
  void setSelectedChannel(String newChannel) {
    _channel = newChannel;
    notifyListeners();
  }

  @override
  void setRange(double newRange) {
    _maxX = _minX + newRange;
    notifyListeners();
  }

  @override
  void moveRange(double deltaX) {
    _minX += deltaX;
    _maxX += deltaX;
    notifyListeners();
  }

  @override
  void resetToDefault() {
    _channel = 'I';
    _resolution = 1;
    _minX = 0;
    _maxX = 2000;
    notifyListeners();
  }
}

class EcgAfterProvider extends EcgProvider {
  final Map<String, Ecg> _ecgs = {"original": Ecg(EcgHeader({}, {}), [])};
  List<QRS> _qrsSlices = [QRS(0, 0, 0)];
  String _source = "original";
  String _channel = 'I';
  double _sampleRate = 1;
  int _resolution = 1;
  double _minY = 0;
  double _maxY = 0;
  double _minX = 0;
  double _maxX = 2000;

  @override
  Map<String, Ecg> get ecgs => _ecgs;
  @override
  List<QRS> get qrsSlices => _qrsSlices;
  @override
  String get source => _source;
  @override
  String get channel => _channel;
  @override
  double get sampleRate => _sampleRate;
  @override
  int get resolution => _resolution;
  @override
  double get minY => _minY;
  @override
  double get maxY => _maxY;
  @override
  double get minX => _minX;
  @override
  double get maxX => _maxX;

  @override
  void update(Map<String, dynamic> input) {
    _ecgs["original"] = input["original"] ?? Ecg(EcgHeader({}, {}), []);
    _ecgs["no_pacemaker"] = input["no_pacemaker"] ?? Ecg(EcgHeader({}, {}), []);
    _ecgs["cleaned"] = input["cleaned"] ?? Ecg(EcgHeader({}, {}), []);
    _qrsSlices = input["qrs_slices"] ?? [QRS(0, 0, 0)];
    _sampleRate = _parseSampleRate(
        _ecgs[_source]?.header.generalHeader['Sample Rate']?.toString() ?? '1');
    _minY = _ecgs[_source]!
        .data
        .map((e) => e.values
            .reduce((value, element) => value < element ? value : element))
        .reduce((value, element) => value < element ? value : element);
    _maxY = _ecgs[_source]!
        .data
        .map((e) => e.values
            .reduce((value, element) => value > element ? value : element))
        .reduce((value, element) => value > element ? value : element);
    notifyListeners();
  }

  @override
  void setStep(int newResolution) {
    _resolution = newResolution;
    notifyListeners();
  }

  @override
  void setSource(String source) {
    _source = source;
    notifyListeners();
  }

  @override
  void setSelectedChannel(String newChannel) {
    _channel = newChannel;
    notifyListeners();
  }

  @override
  void setRange(double newRange) {
    _maxX = _minX + newRange;
    notifyListeners();
  }

  @override
  void moveRange(double deltaX) {
    _minX += deltaX;
    _maxX += deltaX;
    notifyListeners();
  }

  @override
  void resetToDefault() {
    _channel = 'I';
    _resolution = 1;
    _minX = 0;
    _maxX = 2000;
    notifyListeners();
  }
}

double _parseSampleRate(String sampleRateString) {
  final match = RegExp(r'(\d+)').firstMatch(sampleRateString);
  return match != null ? double.parse(match.group(0)!) : 1.0;
}
