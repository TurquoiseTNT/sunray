import 'package:flutter/material.dart';
import '../services/jellyfin_service.dart';
import '../utils/shared_preferences_helper.dart';
import '../screens/login_screen.dart';

class ServerSetupScreen extends StatefulWidget {
  @override
  _ServerSetupScreenState createState() => _ServerSetupScreenState();
}

class _ServerSetupScreenState extends State<ServerSetupScreen> {
  final TextEditingController _serverAddressController = TextEditingController();
  String? _errorMessage;

  void _submitServerAddress() async {
    final serverAddress = _serverAddressController.text.trim();

    if (serverAddress.isEmpty) {
      setState(() {
        _errorMessage = 'Server address cannot be empty';
      });
      return;
    } else if (!RegExp(r'^(http|https):').hasMatch(serverAddress)) {
      setState(() {
        _errorMessage = 'Please specify http:// or https://';
      });
      return;
    }
    final jellyfinService = JellyfinService(serverAddress);
    final isReachable = await jellyfinService.pingServer();
    if (!isReachable) {
      setState(() {
        _errorMessage = 'Server not found';
      });
      return;
    }
    setState(() {
      _errorMessage = null;
    });
    await SharedPreferencesHelper.saveServerUrl(serverAddress);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            isDarkMode
                ? 'assets/images/worddark.png' // Image for dark mode
                : 'assets/images/wordlight.png', // Image for light mode
            height: 40, // Adjust the height as needed
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Add bottom padding
                child: Text(
                  'Welcome to Sunray',
                  style: TextStyle(fontFamily: 'Shrikhand', fontSize: 24),
                ),
              ),
            ),
            Text(
              'Server Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _serverAddressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your server address',
              ),
            ),
            SizedBox(height: 8),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitServerAddress,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}