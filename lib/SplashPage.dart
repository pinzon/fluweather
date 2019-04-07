import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:flutter/services.dart';


import 'dart:async';

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var loadingText = 'Loading...';
  final double latitude = 0;
  final double longitude = 0;

  void getLocation() async {
    setState(() {
      loadingText = 'Getting location...';
    });

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint(position.latitude.toString());
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () => {getLocation()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.blueGrey),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50.0,
                  child: Icon(
                    Icons.cloud,
                    color: Colors.grey,
                    size: 50.0,
                  )),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Text(
                "FluWeather",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
              Padding(
                padding: EdgeInsets.only(top: 150.0),
              ),
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Text(
                "$loadingText",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              ),
            ],
          )
        ],
      ),
    );
  }
}
