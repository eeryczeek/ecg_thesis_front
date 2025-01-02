import 'package:ecg_thesis_front/parser.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<String> requestAnalysis(Ecg ecg) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ecg/clean'),
      headers: {'Content-Type': 'text/plain'},
      body: ecg.toString(),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to request analysis: ${response.body}');
    }
  }
}

final apiService = ApiService('http://127.0.0.1:8000');
