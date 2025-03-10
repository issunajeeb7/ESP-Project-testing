import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart'; // Import uni_links package

class InputScreen extends StatefulWidget {
  final String? name;
  final String? phone;

  const InputScreen({super.key, this.name, this.phone});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name ?? '';
    _phoneController.text = widget.phone ?? '';
    _handleInitialUri();
    _sub = uriLinkStream.listen((Uri? uri) {
      _handleDeepLink(uri);
    });
  }

  Future<void> _handleInitialUri() async {
    try {
      final Uri? uri = await getInitialUri(); // Get initial deep link
      if (uri != null) {
        _handleDeepLink(uri);
      }
    } catch (e) {
      print('Error parsing initial URI: $e');
    }
  }

  void _handleDeepLink(Uri? uri) {
    if (uri != null) {
      setState(() {
        _nameController.text = uri.queryParameters["name"] ?? "";
        _phoneController.text = uri.queryParameters["phone"] ?? "";
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Input Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}
