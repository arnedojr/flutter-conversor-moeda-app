
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
//import 'Dart:io';


//const request = "https://api.hgbrasil.com/finance?format=json&key=c60df7606";
const request = "https://api.hgbrasil.com/finance?key=c8412341";
//const request = "https://api.hgbrasil.com/finance?format=json-cors&key=c8412341";
//const request = "http://[2804:14d:5494:8fa7:e979:55d:e85b:2c3b]";

void main() async {

  //print("Iniciou o request...");
  //print(json.decode(response.body)["results"]["currencies"]["USD"]);
  //print("Passou pelo await...");
  //print(await getData());

  runApp(MaterialApp(
      title: "Conversor de Moedas",
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          )
      ),
      )
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro /dolar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor de Moedas \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child:
                      Text("Carregando dados...",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,)
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                      child:
                      Text("Erro ao carregar dados...",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center,)
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  //print("teste $dolar");
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                        buildTextFielder("Reais", "R\$ ", realController, _realChanged),
                        Divider(),
                        buildTextFielder("Dólares", "US\$ ", dolarController, _dolarChanged),
                        Divider(),
                        buildTextFielder("Euros", "E\$ ", euroController, _euroChanged),
                      ],
                    ),
                  );
                }
          }

            }
        ),
    );
  }

  Widget buildTextFielder(String moeda, String prefix, TextEditingController c, Function f) {

    return TextField(
      controller: c,
      decoration: InputDecoration(
          labelText: moeda,
          labelStyle: TextStyle(
              color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix,
          prefixStyle: TextStyle(color: Colors.amber, fontSize: 15.0)
      ),
      style: TextStyle(fontSize: 25.0, color: Colors.amber),
      onChanged: f,
      keyboardType: TextInputType.number,
    );
  }
  //==============================================================babayte

  /*
  void _chamadaTestHTTP() async {
    final response = await http.get("https://jsonplaceholder.typicode.com/posts/2");
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print("Falha ao carregar um post");
    }
  }

  void _verificaInternetAtiva() async {
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
  */

}
