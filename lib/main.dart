import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/server_setup_screen.dart';
import 'services/jellyfin_service.dart';
import 'utils/shared_preferences_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunray for Jellyfin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFDD9037),brightness: Brightness.light,),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFDD9037),brightness: Brightness.dark,),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, // Automatically switches based on system settings
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkServerAndLogin();
  }

  Future<void> _checkServerAndLogin() async {
    final serverUrl = await SharedPreferencesHelper.getServerUrl();

    if (serverUrl == null) {
      // No server saved, navigate to Server Setup Screen
      _navigateTo(ServerSetupScreen());
      return;
    }

    final jellyfinService = JellyfinService(serverUrl);
    final serverIsReachable = await jellyfinService.pingServer();

    if (!serverIsReachable) {
      // Server is unreachable, navigate to Server Setup Screen
      _navigateTo(ServerSetupScreen());
      return;
    }

    final authToken = await SharedPreferencesHelper.getAuthToken();
    if (authToken == null) {
      // No auth token saved, navigate to Login Screen
      _navigateTo(LoginScreen());
      return;
    }

    final loginSuccessful = await jellyfinService.loginWithToken(authToken);
    if (loginSuccessful) {
      // Login successful, navigate to Home Screen
      _navigateTo(HomeScreen());
    } else {
      // Login failed, navigate to Login Screen
      _navigateTo(LoginScreen());
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
