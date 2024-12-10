import 'dart:convert';
import 'package:csv/csv.dart';

class Ecg {
  final EcgHeader header;
  final List<Map<String, double>> data;

  Ecg(this.header, this.data);
}

class EcgHeader {
  final Map<String, String> generalHeader;
  final Map<String, ChannelHeader> channelHeaders;

  EcgHeader(this.generalHeader, this.channelHeaders);
}

class ChannelHeader {
  final Map<String, String> header;

  ChannelHeader(this.header);
}

class ECGTxtParser {
  Future<Ecg> parse(String content) async {
    final lines = LineSplitter.split(content).toList();
    final dataStart = lines.indexOf('[Data]') + 1;
    final headers = _parseHeaders(lines.sublist(0, dataStart));
    final data = _parseData(lines.sublist(dataStart + 1), headers);

    return Ecg(headers, data);
  }

  EcgHeader _parseHeaders(List<String> lines) {
    final channelHeaderIndexes = <int>[];
    final generalHeader = <String, String>{};
    final channelHeaders = <String, ChannelHeader>{};

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('Channel #')) {
        channelHeaderIndexes.add(i);
      }
    }

    for (var line in lines.sublist(0, channelHeaderIndexes[0])) {
      final parts = line.split(': ');
      if (parts.length == 2) {
        generalHeader[parts[0].trim()] = parts[1].trim();
      }
    }

    for (var i = 0; i < channelHeaderIndexes.length; i++) {
      final start = channelHeaderIndexes[i];
      final end = (i + 1 < channelHeaderIndexes.length)
          ? channelHeaderIndexes[i + 1]
          : lines.length;
      final channelHeader = _parseChannelHeader(lines.sublist(start, end));
      final channelLabel = lines[start + 1].split(' ')[1];
      channelHeaders[channelLabel] = channelHeader;
    }

    return EcgHeader(generalHeader, channelHeaders);
  }

  ChannelHeader _parseChannelHeader(List<String> lines) {
    final header = <String, String>{};

    for (var line in lines) {
      final parts = line.split(': ');
      if (parts.length == 2) {
        header[parts[0].trim()] = parts[1].trim();
      }
    }

    return ChannelHeader(header);
  }

  List<Map<String, double>> _parseData(List<String> lines, EcgHeader header) {
    final data = <Map<String, double>>[];
    final csvConverter = CsvToListConverter();

    for (var line in lines) {
      final row = csvConverter.convert(line).first;
      final dataRow = <String, double>{};

      for (var i = 0; i < row.length; i++) {
        final channelLabel = header.channelHeaders.keys.elementAt(i);
        dataRow[channelLabel] = row[i].toDouble();
      }

      data.add(dataRow);
    }

    return data;
  }
}
