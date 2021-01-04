import 'package:flutter/material.dart';
import 'package:add_store/screens/home_screen.dart';
import 'package:add_store/screens/login_screen.dart';
import 'package:add_store/utility/local_storage.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Add Store',
      home: await home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.lightGreenAccent,
      ),
      routes: <String, WidgetBuilder>{
        //"/home": (BuildContext context) => HomeScreen(),
        "/login": (BuildContext context) => LoginScreen(),
      }));
}

Future<Widget> home() async {
  await LocalStorage.init();
  var userLoggedIn = LocalStorage.prefs.getBool("rememberUser") ?? false;
  if (userLoggedIn) {
    var userDataJson = LocalStorage.prefs.getString("userJson");
    Map<String, dynamic> userData = jsonDecode(userDataJson);
    return HomeScreen(userData);
  } else {
    return LoginScreen();
  }
}
