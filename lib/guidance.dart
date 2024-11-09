import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';

class GuidancePage extends StatefulWidget {
  final String req;

  const GuidancePage({super.key, required this.req});

  @override
  State<GuidancePage> createState() => _GuidancePageState();
}

class _GuidancePageState extends State<GuidancePage> {
  String? apiResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGuidanceData();
  }

  /// Method to fetch data from the OpenAI API
  Future<void> fetchGuidanceData() async {
    const String url = 'https://api.openai.com/v1/chat/completions';
    final String? apiKey = dotenv.env['API_KEY'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      "model": "gpt-4o-mini",
      "messages": [
        {
          "role": "system",
          "content": "You are a healthcare guidance expert. The user will provide a list of Z-scores for various health indicators. Your role is to analyze these Z-scores, assess the user's current health status, and offer personalized, concise lifestyle recommendations to help bring their vitals back within the optimal range."
        },
        {
          "role": "user",
          "content": widget.req
        }
      ]
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          apiResponse = responseData['choices'][0]['message']['content'];
          isLoading = false;
        });
      } else {
        setState(() {
          apiResponse = "Error: Unable to fetch data.";
          isLoading = false;
        });
        print(response.body);
      }
    } catch (e) {
      setState(() {
        apiResponse = "Error: Something went wrong.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guidance'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: isLoading ? _buildSplashScreen() : _buildContent(),
      ),
    );
  }

  /// Method to build the dynamic splash screen
  Widget _buildSplashScreen() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 20),
        Text(
          'Consulting our \nseasoned professionals...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// Method to build the content after fetching data
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: apiResponse != null
          ? Expanded(
              child: Markdown(
                data: apiResponse!,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: const TextStyle(fontSize: 16),
                  h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  h2: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  h3: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  code: const TextStyle(
                    backgroundColor: Color(0xFFE0E0E0),
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            )
          : const Text("No data available."),
    );
  }

}
