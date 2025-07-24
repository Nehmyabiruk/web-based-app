import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:neh/Auth/login.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

import 'homepage/homepage.dart'; // ✅ Corrected import path

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    WebViewPlatform.instance = WebWebViewPlatform();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spiritual Tracker',
      debugShowCheckedModeBanner: false,
      home: LoginPage(dataList: null,), // ✅ Make sure the class name matches
    );
  }
}
