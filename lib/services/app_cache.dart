//this is my alternative to shared preferences, I use it to store data that I need to access from anywhere in the app
//plus the event_bus allows windows to listen to events from other windows

import 'dart:math';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const ASCII_START = 33;
const ASCII_END = 126;

class AppData {
  static final AppData _appData = AppData._internal();

  bool isDarkMode = false;
  EventBus? eventBus;

  SharedPreferences? prefs;
  factory AppData() {
    return _appData;
  }
  AppData._internal();

  String getRandomString(int i) {
    final random = Random();
    final codeUnits = List.generate(
        i, (index) => random.nextInt(ASCII_END - ASCII_START) + ASCII_START);
    return String.fromCharCodes(codeUnits);
  }

  init() async {
    eventBus = EventBus();
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setIntPreference(String key, int value) async {
    return await prefs!.setInt(key, value);
  }

  Future<bool> setStringPreference(String key, String value) async {
    return await prefs!.setString(key, value);
  }

  Future<bool> setStringListPreference(String key, List<String> value) async {
    return await prefs!.setStringList(key, value);
  }

  Future<bool> setDoublePreference(String key, double value) async {
    return await prefs!.setDouble(key, value);
  }

  Future<bool> setBoolPreference(String key, bool value) async {
    return await prefs!.setBool(key, value);
  }

  int? getIntPreference(String key) {
    return prefs!.getInt(key);
  }

  String? getStringPreference(String key) {
    return prefs!.getString(key);
  }

  List<String>? getStringListPreference(String key) {
    return prefs!.getStringList(key);
  }

  double? getDoublePreference(String key) {
    return prefs!.getDouble(key);
  }

  bool? getBoolPreference(String key) {
    return prefs!.getBool(key);
  }

  Future<bool> clearPreference() async {
    return await prefs!.clear();
  }
}

class SocketMessageEvent {
  dynamic data;

  SocketMessageEvent(this.data);
}
