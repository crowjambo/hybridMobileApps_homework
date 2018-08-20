import 'package:flutter/material.dart';

import 'utility/globals.dart' as globals;
import 'views/home_view.dart';
import 'utility/QRscanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'qr App',
    debugShowCheckedModeBanner: false,
    home: HomeView(),
    theme: ThemeData(
      primarySwatch: globals.kThemeColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    routes: <String, WidgetBuilder>{
      "/qr_scan": (BuildContext context) => QRScanner()
    },
  ));
}