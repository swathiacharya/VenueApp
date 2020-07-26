import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sahyadri/menu/sidebar_layout.dart';
import 'authentication/login.dart';
import 'authentication/register.dart';
import 'authentication/splash.dart';

void main() {
  runApp(MyApp());
}
final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // so the it will not have autoRotate with the phone
        SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      // debug symbol will no be their
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => SideBarLayout() ,
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
      }
    );
  }
}
