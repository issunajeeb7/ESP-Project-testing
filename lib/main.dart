import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'input_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? name;
  String? phone;

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _handleInitialUri();
    _sub = uriLinkStream.listen((Uri? uri) {
      _handleUri(uri);
    });
  }

  Future<void> _handleInitialUri() async {
    final uri = await getInitialUri();
    print("uri: $uri");
    _handleUri(uri);
  }

  void _handleUri(Uri? uri) {
    if (uri != null) {
      setState(() {
        name = uri.queryParameters["name"];
        phone = uri.queryParameters["phone"];
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: InputScreen(name: name, phone: phone),
    );
  }
}
