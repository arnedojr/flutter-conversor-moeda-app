import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart';

import 'Dart:io';


//const request = "https://api.hgbrasil.com/finance?format=json&key=c60df7606";
//const request = "https://api.hgbrasil.com/finance?key=c8412341";
//const request = "https://api.hgbrasil.com/finance?format=json-cors&key=c8412341";
const request = "http://localhost";

void main() async {

  print("Iniciou o request...");

  http.Response response = await http.get(request);
  print(response.body);

  print("Passou pelo await...");

  runApp(MaterialApp(
      title: "Conversor de Moedas",
      home: Container()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  void _chamadaTestHTTP() {
    final response = await http.get("https://jsonplaceholder.typicode.com/posts/2");
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print("Falha ao carregar um post");
    }
  }

  void _verificaInternetAtiva() {
    try {
      final result = await InternetAddress.lookup('google.com');
      print(result.toString());
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("TEste"),);
  }
}
