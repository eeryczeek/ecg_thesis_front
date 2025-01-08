import 'dart:convert';
import 'package:csv/csv.dart';

class Ecg {
  final EcgHeader header;
  final List<Map<String, double>> data;

  Ecg(this.header, this.data);

  @override
  String toString() {
    final buffer = StringBuffer();

    buffer.writeln('[Header]');

    header.generalHeader.forEach((key, value) {
      buffer.writeln('$key: $value');
    });

    header.channelHeaders.forEach((channel, channelHeader) {
      buffer.writeln('Channel #$channel');
      channelHeader.header.forEach((key, value) {
        buffer.writeln('$key: $value');
      });
    });

    buffer.writeln('\n[Data]');
    final csvConverter = ListToCsvConverter();
    for (var dataRow in data) {
      final row =
          header.channelHeaders.keys.map((key) => dataRow[key]).toList();
      buffer.writeln(csvConverter.convert([row]));
    }
    return buffer.toString();
  }
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

class QRS {
  final int Q;
  final int R;
  final int S;

  QRS(this.Q, this.R, this.S);

  @override
  String toString() {
    return 'Q: $Q, R: $R, S: $S';
  }
}

class QRSParser {
  List<QRS> parse(List<dynamic> jsonList) {
    final List<QRS> qrsList = [];
    for (var item in jsonList) {
      final Map<String, dynamic> qrsMap = jsonDecode(item);
      qrsList.add(QRS(qrsMap['Q'], qrsMap['R'], qrsMap['S']));
    }

    return qrsList;
  }
}
