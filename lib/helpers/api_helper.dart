import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    String json =
        jsonEncode(<String, String>{'login': login, 'password': password});
    final response = await http.post(Uri.parse(url + '/login'),
        headers: {"Content-Type": "application/json"}, body: json);
    if (response.statusCode == 200) {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.write(
          key: 'access-token',
          value: jsonDecode(response.body)["access_token"]);
      await storage.write(
        key: 'logged-as',
        value: login
      );
    }

    return response.statusCode;
  }
}
