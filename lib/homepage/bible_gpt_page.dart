import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BibleGptPage extends StatelessWidget {
  final Uri bibleGptUrl = Uri.parse('https://biblegpt-la.com');

  BibleGptPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // On Web, open link in a new tab
      _launchWebUrl();
      return Scaffold(
        appBar: AppBar(title: const Text('Bible Q&A with BibleGPT')),
        body: const Center(child: Text("Opening in a new tab...")),
      );
    }

    if (Platform.isAndroid || Platform.isIOS) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(bibleGptUrl);
      return Scaffold(
        appBar: AppBar(title: const Text('Bible Q&A with BibleGPT')),
        body: WebViewWidget(controller: controller),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bible Q&A with BibleGPT')),
      body: const Center(
        child: Text(
          'This platform is not supported.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _launchWebUrl() async {
    if (await canLaunchUrl(bibleGptUrl)) {
      await launchUrl(bibleGptUrl);
    } else {
      debugPrint('Could not launch $bibleGptUrl');
    }
  }
}
