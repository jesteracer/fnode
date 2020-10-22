import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          loadFromNetwork();
        },
        child: Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'This was loaded from network:',
            ),
            Expanded(
              child: Container(child: Text(content)),
            ),
            Text(
              'This was loaded from webview:',
            ),
            Container(
                height: 250,
                child: WebView(
                  initialUrl: _url(),
                ))
          ],
        ),
      ),
    );
  }

  String _url() {
    return 'https://meduza.io/api/f1/en/news/2020/10/01/russian-state-duma-speaker-says-navalny-should-thank-putin-for-saving-his-life-not-blame-him-for-an-attempted-assassination';
  }

  String content = "nothing yet";

  loadFromNetwork() async {
    try {
      HttpClient client = new HttpClient();
      // client.findProxy = HttpClient.findProxyFromEnvironment;

      client.getUrl(Uri.parse(_url())).then((HttpClientRequest request) {
        return request.close();
      }).then((HttpClientResponse response) {
        response.transform(utf8.decoder).listen((contents) {
          setState(() {
            content = contents;
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
