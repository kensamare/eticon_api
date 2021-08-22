## Simple Example
```dart
import 'package:eticon_api/api_errors.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:flutter/material.dart';

void main() async {
  bool tokenLoaded = await Api.loadTokenFromMemory();
  if(tokenLoaded){
    print(Api.token);
  }
  Api.setBaseUrl('https://example.com/');
  Api.setHeaders({"Content-type": 'application/json'});
  Api.enableUtf8Decoding(true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ETICON API Example'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: getRequest,
          child: Container(
            width: 150,
            height: 150,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> getRequest() async {
    try{
      Map<String, dynamic> response = await Api.get(method: 'product',);
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
}
```
