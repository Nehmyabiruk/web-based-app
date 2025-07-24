import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BibleQAHomePage extends StatefulWidget {
  const BibleQAHomePage({super.key});

  @override
  State<BibleQAHomePage> createState() => _BibleQAHomePageState();
}

class _BibleQAHomePageState extends State<BibleQAHomePage> {
  final TextEditingController _questionController = TextEditingController();
  String _answer = '';
  bool _isLoading = false;

  Future<void> getAnswer(String verseQuery) async {
    setState(() {
      _isLoading = true;
      _answer = '';
    });

    try {
      final verse = Uri.encodeComponent(verseQuery.trim());
      final url = Uri.parse('https://bible-api.com/\$verse');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _answer = data['text'] ?? 'Verse not found.';
        });
      } else {
        setState(() {
          _answer = 'Verse not found.';
        });
      }
    } catch (e) {
      setState(() {
        _answer = 'An error occurred: \$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bible Q&A')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Ask a Bible Verse (e.g. John 3:16)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                hintText: 'Enter a verse (e.g. Matthew 5:9)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : () => getAnswer(_questionController.text),
              child: const Text('Get Verse'),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_answer.isNotEmpty && !_isLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(_answer, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
