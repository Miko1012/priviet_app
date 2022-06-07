import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:priviet_app/helpers/rsa_helper.dart';

//import '../objects/chat_position.dart';

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
      await storage.write(key: 'logged-as', value: login);
    }
    return response.statusCode;
  }

  Future<int> createNewChat(String addressee) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    RSAHelper rsa = RSAHelper();
    String? token = await storage.read(key: 'access-token');

    //  get addressee public key from redis database
    final responseAddresseePublicKey = await http.get(Uri.parse(url + '/public-key/' + addressee),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + token!,
        }
    );
    if(responseAddresseePublicKey.statusCode != 200) {
      return responseAddresseePublicKey.statusCode;
    }
    String addresseePublicKey = responseAddresseePublicKey.body;
    String? loggedInAs = await storage.read(key: 'logged-as');
    String? senderPublicKey = await storage.read(key: 'public-' + loggedInAs!);

    String senderEncryptedMessage = await rsa.encryptMessage("To jest start konwersacji.", senderPublicKey);
    String addresseeEncryptedMessage = await rsa.encryptMessage("To jest start konwersacji.", addresseePublicKey);

    print('addresseePublicKey: '+addresseePublicKey);
    print('senderPublicKey: '+senderPublicKey!);
    print('senderEncryptedMessage: '+senderEncryptedMessage);
    print('addresseeEncryptedMessage: '+addresseeEncryptedMessage);

    String json = jsonEncode(<String, String>{
      'addressee': addressee,
      'sender_encrypted_message': senderEncryptedMessage,
      'addressee_encrypted_message': addresseeEncryptedMessage
    });

    final response = await http.post(Uri.parse(url + '/chats'),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ' + token!,
        },
        body: json);
    return response.statusCode;
  }

  Future<List> getChats() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access-token');
    final response = await http
        .get(Uri.parse('http://10.0.2.2:5000/chats'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+token!,
        }
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body) as List;
      print('got chats!');
      return responseJson;
    }
    // #TODO zrobić obsługę błędów z api
    return [];
  }
}
