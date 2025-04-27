import 'dart:math';
import 'shared_preferences_helper.dart';
import 'package:flutter/material.dart';

class AppUtils {
  static Future<String> getDeviceName() async {
    final savedDeviceName = await SharedPreferencesHelper.getDeviceName(); // Await the result
    if (savedDeviceName != null) {
      return savedDeviceName;
    }
    String deviceName = await generateDeviceName();
    await SharedPreferencesHelper.saveDeviceName(deviceName); // Ensure save is awaited
    return deviceName;
  }

  static Future<String> generateDeviceName() async {
    List<String> list1 = ["Cinematic","Silent","Golden","Pixelated","Vivid","Analog","Digital","Retro","Neon","Stereo","Dynamic","Magnetic","Virtual","Prismatic","Epic"];
    List<String> list2 = ["Reel","Frame","Track","Screen","Clip","Scene","Tape","Mix","Script","Channel","Studio","Projector","Playlist","Edit","Broadcast"];
    final random = Random();
    String word1 = list1[random.nextInt(list1.length)];
    String word2 = list2[random.nextInt(list2.length)];
    return '$word1 $word2';
  }

  static String getAppVersion() {
    return "0.1 Lizzard";
  }

  static String getAppString() {
    return "Sunray™️ App for Desktop and Mobile; TurquoiseTNT Multimedia; Version ${getAppVersion()}";
  }
}