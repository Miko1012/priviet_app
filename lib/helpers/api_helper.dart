import 'dart:convert';
import 'package:http/http.dart' as http;

class APIHelper {
  static const String url = 'http://10.0.2.2:5000';

  Future<int> registerUser(
      String name, String login, String password, String publicKey) async {
    String json = jsonEncode(<String, String>{
      'name': name,
      'login': login,
      'password': password,
      'public_key': publicKey
    });
    final response = await http.post(Uri.parse(url + '/register'),
        headers: {"Content-Type": "application/json"}, body: json);
    return response.statusCode;
  }

  Future<int> loginUser(String login, String password) async {
    String json = jsonEncode(<String, String>{
      'login': login,
      'password': password
    });
    final response = await http.post(Uri.parse(url + '/login'),
        headers: {"Content-Type": "application/json"}, body: json);
    return response.statusCode;
  }
}
