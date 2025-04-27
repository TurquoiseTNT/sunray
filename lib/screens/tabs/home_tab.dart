import 'package:flutter/material.dart';
import '../../services/jellyfin_service.dart';
import '../../utils/shared_preferences_helper.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Home',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}