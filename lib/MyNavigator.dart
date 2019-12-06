import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;




//PAGES



class MyNavigator {
  static void goToHome(BuildContext context) {
    Navigator.pushNamed(context, "/home");
  }

  static void goToIntro(BuildContext context) {
    Navigator.pushNamed(context, "/intro");
  }

  static void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      // exit(0);
    }
  }
}
