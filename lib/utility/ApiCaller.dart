import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:async';
import 'package:http/http.dart' as http;

class ApiCaller {
  String language = 'en';
  String speed = 'kh';
  String apikey = '';

  ApiCaller(){
    debugPrint('Caller llamado');
  }

  Future getForecast() async {
    await loadApiKey();
    await loadSettings();

    return http.get('https://getProjectList');

  }

  Future<void> loadApiKey() async {
    await DotEnv().load('.env');
    this.apikey = DotEnv().env['DARKSKY_API_KEY'];
  }

  Future<void> loadSettings() async {

  }
  

}