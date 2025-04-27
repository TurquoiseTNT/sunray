import 'package:flutter/material.dart';
import '../services/jellyfin_service.dart';
import '../utils/shared_preferences_helper.dart';
import 'server_setup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  JellyfinService? jellyfinService;
  List<Map<String, String?>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeService();
  }

  Future<void> initializeService() async {
    final serverUrl = await SharedPreferencesHelper.getServerUrl();
    if (serverUrl == null || serverUrl.isEmpty) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('Server URL is not set. Please configure the server.');
      return;
    }

    setState(() {
      jellyfinService = JellyfinService(serverUrl);
    });

    fetchUsers();
  }

  Future<void> fetchUsers() async {
    if (jellyfinService == null) return;
    final fetchedUsers = await jellyfinService!.getAllUsers();
    setState(() {
      users = fetchedUsers;
      isLoading = false;
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showPasswordDialog(String userId, String userName) {
    final TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login as $userName'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password (leave blank if none)'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final password = passwordController.text.trim();
                if (jellyfinService != null) {
                  final token = await jellyfinService!.login(userName, password);
                  if (token != "invalid" && token != "noreply") {
                    await SharedPreferencesHelper.saveAuthToken(token);
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pushReplacementNamed('/home_screen'); // Navigate to the home screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login successful!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed. Please try again.')),
                    );
                  }
                }
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  void showManualLoginDialog() {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Manual Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final username = usernameController.text.trim();
                final password = passwordController.text.trim();

                if (username.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter both username and password.')),
                  );
                  return;
                }

                if (jellyfinService != null) {
                  final token = await jellyfinService!.login(username, password);
                  if (token != "invalid" && token != "noreply") {
                    await SharedPreferencesHelper.saveAuthToken(token);
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pushReplacementNamed('/home'); // Navigate to the home screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login successful!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed. Please try again.')),
                    );
                  }
                }
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  void showChangeServerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Server'),
          content: Text(
            'Are you sure you want to change the server? This will reset your app and delete all downloads.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                print('reset');
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ServerSetupScreen()),
              );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
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
                ? 'assets/images/worddark.png'
                : 'assets/images/wordlight.png',
            height: 40,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? Center(child: Text('No users found.'))
              : Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView( // Add this widget
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 16.0, // Horizontal spacing between items
                              runSpacing: 16.0, // Vertical spacing between rows
                              children: users.map((user) {
                                final profilePicture = user['pfp'] ?? 'assets/images/nopfp.png';
                                final userName = user['nam'] ?? 'Unknown User';

                                return GestureDetector(
                                  onTap: () => showPasswordDialog(user['uid']!, userName),
                                  child: SizedBox(
                                    width: 150, // Fixed width for each item
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 50, // Big icon
                                          backgroundColor: Colors.grey[200],
                                          backgroundImage: profilePicture.startsWith('http')
                                              ? NetworkImage(profilePicture)
                                              : AssetImage(profilePicture) as ImageProvider,
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          userName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16.0, // Horizontal spacing between buttons
                        runSpacing: 16.0, // Vertical spacing between rows
                        children: [
                          ElevatedButton(
                            onPressed: showManualLoginDialog,
                            child: Text('Manual Login'),
                          ),
                          ElevatedButton(
                            onPressed: showChangeServerDialog,
                            child: Text('Change Server'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}