import 'package:flutter/material.dart';
import '../../services/jellyfin_service.dart';
import '../../utils/shared_preferences_helper.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            decoration: InputDecoration(
              labelText: 'Password (leave blank if none)',
            ),
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
                final password = passwordController.text;
                try {
                  final token = await jellyfinService!.login(userId, password);
                  await SharedPreferencesHelper.saveAuthToken(token);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login successful!')),
                  );
                  fetchUsers(); // Refresh the app
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: $e')),
                  );
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
                final username = usernameController.text;
                final password = passwordController.text;
                try {
                  final token = await jellyfinService!.login(username, password);
                  await SharedPreferencesHelper.saveAuthToken(token);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login successful!')),
                  );
                  fetchUsers(); // Refresh the app
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: $e')),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Settings',
                        style: TextStyle(fontFamily: 'Shrikhand', fontSize: 24),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Row(
                        children: [
                          ...users.map((user) {
                            final profilePicture =
                                user['pfp'] ?? 'assets/images/nopfp.png';
                            final userName = user['nam'] ?? 'Unknown User';
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => showPasswordDialog(
                                      user['uid']!,
                                      userName,
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: profilePicture.startsWith('http')
                                          ? NetworkImage(profilePicture)
                                          : AssetImage(profilePicture) as ImageProvider,
                                    ),
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
                            );
                          }).toList(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: showManualLoginDialog,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: AssetImage(
                                      'assets/images/nopfp.png',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Other',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('General Settings'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.rotate_left),
                        title: Text('Reset App'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.volunteer_activism),
                        title: Text('Donate'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text('About'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
