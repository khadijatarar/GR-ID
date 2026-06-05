import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static Future<Map<String, dynamic>> predictImage(String imagePath) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${AppConstants.baseUrl}/predict"),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', imagePath),
    );

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    print("RAW RESPONSE: $responseData");

    return jsonDecode(responseData) as Map<String, dynamic>;
  }
}