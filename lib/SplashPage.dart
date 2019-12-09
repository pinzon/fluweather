import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'HomePage.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new Home(),
        title: new Text(
          'FWeather',
          style: new TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white, fontStyle: FontStyle.italic),
        ),
        image: Image.asset('assets/logo.png'),
        backgroundColor: Colors.blueGrey,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.white
        );

    
  }
}
