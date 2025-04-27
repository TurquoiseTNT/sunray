import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/apputils.dart';

class JellyfinService {
  final String serverUrl;

  JellyfinService(this.serverUrl);

  Future<bool> pingServer() async {
    try {
      final response = await http.get(Uri.parse('$serverUrl/System/Ping'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<String> login(String username, String password) async {
    try {
      final deviceName = await AppUtils.getDeviceName();
      final appVersion = await AppUtils.getAppVersion();
      final response = await http.post(
        Uri.parse('$serverUrl/Users/AuthenticateByName'),
        headers: {
          'Content-Type': 'application/json',
          'X-Emby-Authorization':
              'Emby Client="Sunray", Device="$deviceName", DeviceId="$deviceName", Version="$appVersion"',
        },
        body: jsonEncode({'Username': username, 'Pw': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['AccessToken'];
      } else {
        return "invalid";
      }
    } catch (e) {
      return "noreply";
    }
  }

  Future<bool> loginWithToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$serverUrl/Users/Me'),
        headers: {'X-Emby-Token': token},
      );

      if (response.statusCode == 200) {
        print('Token validation successful.');
        return true;
      } else {
        print('Token validation failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }

  Future<List<Map<String, String?>>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$serverUrl/Users/Public'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        return Future.wait(users.map((user) async {
          final profilePictureUrl = '$serverUrl/UserImage?userId=${user['Id']}';
          final isValidImage = await isImageValid(profilePictureUrl);
          return {
            'uid': user['Id'].toString(),
            'nam': user['Name'].toString(),
            'pfp': isValidImage ? profilePictureUrl : null,
          };
        }).toList());
      } else {
        print('Failed to fetch users: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<int> getUserCount() async {
    try {
      final response = await http.get(
        Uri.parse('$serverUrl/Users/Public'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        return users.length; // Return the total number of users
      } else {
        print('Failed to fetch user count: ${response.body}');
        return 0;
      }
    } catch (e) {
      print('Error fetching user count: $e');
      return 0;
    }
  }

  Future<bool> isImageValid(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200; // Return true if the image exists
    } catch (e) {
      print('Error checking image: $e');
      return false; // Return false if there's an error
    }
  }
}