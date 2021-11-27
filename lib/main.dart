import 'dart:io';

import 'package:flutter/material.dart';

import 'Screens/landind_screen.dart';


void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: ''),
    );
  }
}
