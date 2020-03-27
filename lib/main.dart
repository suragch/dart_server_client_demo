import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("API demo"),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Register'),
          onTap: () => _register(),
        ),
        ListTile(
          title: Text('Login'),
          onTap: () => _login(),
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () => _logout(),
        ),
        ListTile(
          title: Text('GET (get all words)'),
          onTap: () => _getAllWords(),
        ),
        ListTile(
          title: Text('GET (get single word)'),
          onTap: () => _getSingleWord(),
        ),
        ListTile(
          title: Text('POST (add word)'),
          onTap: () => _addWord(),
        ),
        ListTile(
          title: Text('PUT (update word)'),
          onTap: () => _updateWord(),
        ),
        ListTile(
          title: Text('DELETE (delete word)'),
          onTap: () => _deleteWord(),
        )
      ],
    );
  }
}

var token = '';

String _host() {
  if (Platform.isAndroid)
    return 'http://10.0.2.2:8888';
  else
    return 'http://127.0.0.1:8888';
}

void _register() async {
  String url = '${_host()}/register';
  Map<String, String> headers = {"Content-type": "application/json"};
  final jsonString = '{"username":"bob2", "password":"password"}';
  Response response = await post(url, headers: headers, body: jsonString);
  print('${response.statusCode} ${response.body}');
}

void _login() async {
  String url = '${_host()}/auth/token';

  var username = 'bob';
  var password = 'password';
  var clientID = 'com.mydartserver.demo.app';
  var clientSecret = '';
  var body = 'username=$username&password=$password&grant_type=password';
  var clientCredentials =
      Base64Encoder().convert('$clientID:$clientSecret'.codeUnits);

  Map<String, String> headers = {
    'Content-type': 'application/x-www-form-urlencoded',
    'authorization': 'Basic $clientCredentials'
  };
  var response = await post(url, headers: headers, body: body);
  final statusCode = response.statusCode;
  final responseBody = response.body;
  _printResponse(response);

  if (response.statusCode != 200) {
    return;
  }

  final map = json.decode(responseBody);
  token = map['access_token'];
}

void _logout() async {
  String url = '${_host()}/logout';
  Map<String, String> headers = {
    'authorization': 'Bearer $token'
  };
  Response response = await delete(url, headers: headers);
  token = '';
  _printResponse(response);
}

void _getAllWords() async {
  String url = '${_host()}/words';
  Map<String, String> headers = {'authorization': 'Bearer $token'};
  Response response = await get(url, headers: headers);
  _printResponse(response);
}

void _getSingleWord() async {
  String url = '${_host()}/words/1';
  Map<String, String> headers = {'authorization': 'Bearer $token'};
  Response response = await get(url, headers: headers);
  _printResponse(response);
}

void _addWord() async {
  String url = '${_host()}/words';
  Map<String, String> headers = {
    'authorization': 'Bearer $token',
    'Content-type': 'application/json',
  };
  final body = '{"word": "snake", "content": "long and skinny"}';
  Response response = await post(url, headers: headers, body: body);
  _printResponse(response);
}

void _updateWord() async {
  String url = '${_host()}/words/10';
  Map<String, String> headers = {
    'authorization': 'Bearer $token',
    'Content-type': 'application/json',
  };
  final body = '{"word":"snake","content":{"description":"bites its prey"}}';
  Response response = await put(url, headers: headers, body: body);
  _printResponse(response);
}

void _deleteWord() async {
  String url = '${_host()}/words/10';
  Map<String, String> headers = {
    'authorization': 'Bearer $token'
  };
  Response response = await delete(url, headers: headers);
  _printResponse(response);
}

void _printResponse(Response response) {
  print('${response.statusCode} ${response.body}');
}
