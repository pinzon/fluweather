import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyNavigator.dart';

// import 'package:flutter/services.dart';

import 'dart:async';

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SharedPreferences preferences;
  String loadingText = 'Loading...';
  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    super.initState();
    getLocation();
    MyNavigator.goToHome(this.context);
  }

  void getLocation() async {
    setState(() {
      loadingText = 'Getting location...';
    });

    preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('latitude') && preferences.containsKey('longitude')) {
      await getSavedLocation();
    } else {
      await getCurrentLocation();
    }

    await saveLocation();
  }

  Future<void> saveLocation() async {
    await preferences.setDouble('latitude', this.latitude);
    await preferences.setDouble('longitude', this.longitude);
  }

  Future<void> getSavedLocation() async {
    try {
      this.latitude = preferences.getDouble('latitude');
      this.longitude = preferences.getDouble('longitude');
      debugPrintThrottled(
          'Saved locations is ${this.latitude} : ${this.longitude}');
    } catch (e) {
      //if saved data is not double
      await getCurrentLocation();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      this.latitude = position.latitude;
      this.longitude = position.longitude;
    } catch (e) {
      await _ackAlert(this.context);
    }
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Required!'),
          content:
              const Text('This app needs your location to get your forecast'),
          actions: <Widget>[
            FlatButton(
              child: Text('CLOSE APP'),
              onPressed: () {
                MyNavigator.closeApp();
                debugPrint('Pressed Cancel');
              },
            ),
            RaisedButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                getLocation();
                debugPrint('TRY AGAIN');
              },
            )
          ],
        );
      },
    );
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
