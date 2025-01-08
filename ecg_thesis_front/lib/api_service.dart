import 'dart:convert';

import 'package:ecg_thesis_front/parser.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> requestAnalysis(Ecg ecg) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ecg/analyze'),
      headers: {'Content-Type': 'text/plain'},
      body: ecg.toString(),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> resultMap;
      final Map<String, dynamic> json = jsonDecode(response.body);

      final original = await ECGTxtParser().parse(json['original'] as String);
      final noPacemaker =
          await ECGTxtParser().parse(json['no_pacemaker'] as String);
      final cleaned = await ECGTxtParser().parse(json['cleaned'] as String);
      final qrsSlices = QRSParser().parse(json['qrs_slices'] as List<dynamic>);

      resultMap = {
        'original': original,
        'no_pacemaker': noPacemaker,
        'cleaned': cleaned,
        'qrs_slices': qrsSlices,
      };
      return resultMap;
    } else {
      throw Exception('Failed to request analysis: ${response.body}');
    }
  }
}

final apiService = ApiService('http://127.0.0.1:8000');
