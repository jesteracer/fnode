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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This was loaded from network:',
            ),
            renderFromNetwork(),
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

  renderFromNetwork() {
    return FutureBuilder(
        future: _networkCall(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data != null) {
            return Container(
                padding: EdgeInsets.all(10),
                color: Colors.green,
                child: Text(snapshot.data['title']));
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Text('We FAILED with the request ... ${snapshot.error}'));
          }

          return Container(child: Text('loading'));
        });
    // StreamBuilder(stream: ,)
  }

  String _url() {
    return 'https://meduza.io/api/f1/en/news/2020/10/01/russian-state-duma-speaker-says-navalny-should-thank-putin-for-saving-his-life-not-blame-him-for-an-attempted-assassination';
  }

  _networkCall() async {
    try {
      return http.get(_url()).then((rsp) {
        return convert.jsonDecode(rsp.body);
      });
    } catch (e) {
      print('Errored out with:');
      print(e);
      return Future.error(e.toString());
    }
  }
}
