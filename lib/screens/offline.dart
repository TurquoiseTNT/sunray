import 'package:flutter/material.dart';
import '../main.dart';

void main() {
  runApp(Offline());
}

class Offline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunray App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/offline',
      routes: {
        '/main': (context) => MyApp(), // Use MainScreen instead of MyApp
        '/offline': (context) => OfflineViewing(), // Add the '/offline' route
      },
    );
  }
}

class OfflineViewing extends StatefulWidget {
  @override
  _OfflineViewingState createState() => _OfflineViewingState();
}

class _OfflineViewingState extends State<OfflineViewing> {
  int _selectedIndex = 0; // Track the selected tab index

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            isDarkMode
                ? 'assets/images/worddark.png'
                : 'assets/images/wordlight.png',
            height: 40,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main content of the screen
          Center(
            child: Text(
              'Offline Viewing Content',
              style: TextStyle(fontSize: 18),
            ),
          ),
          // Persistent SnackBar at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.redAccent, // Background color for the SnackBar
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.cloud_off, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "You're offline",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pushReplacementNamed('../main');
                    },
                    child: Text(
                      'Reconnect',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Main Screen!'),
      ),
    );
  }
}