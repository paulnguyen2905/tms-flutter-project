import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiHelper {
  final storage = new FlutterSecureStorage();
  final String _loginUrl = 'http://api.tanthanhdat.local/api/v1/';

  postData(data, apiUrl) async {
    return await http.post(
      apiUrl,
      body: jsonEncode(data),
      headers: _setHeaders()
    );
  }

  getData(apiUrl) async {
    return await http.get(
      apiUrl,
      headers: _setHeaders()
    );
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<void> storeLoginData(String key, var value) async {
    await storage.write(key: key, value: value);
  }

  Future getLoginData(String key) async {
    return await storage.read(key: key);
  }

  Future<void> clearLoginData(String key) async {
    await storage.delete(key: key);
  }

  Future<void> clearAllLoginData() async {
    await storage.deleteAll();
  }
}