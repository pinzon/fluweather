import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/WeaderWidget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences preferences;
  Widget widgetToDisplay = Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[Center(child: CircularProgressIndicator())],
  );
  String loadingText = 'Loading...';
  String city = 'FWeather';
  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getLocation());
  }

  Future<void> _loadWeather() async {
    setState(() {
      widgetToDisplay = Weader();
    });
  }

  Future<void> _getLocation() async {
    setState(() {
      loadingText = 'Getting location...';
    });

    preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('latitude') &&
        preferences.containsKey('longitude')) {
      await _getSavedLocation();
      await _loadWeather();
    } else {
      await _getCurrentLocation();
    }
  }

  Future<void> _saveLocation() async {
    await preferences.setDouble('latitude', this.latitude);
    await preferences.setDouble('longitude', this.longitude);
  }

  Future<void> _getSavedLocation() async {
    try {
      this.latitude = preferences.getDouble('latitude');
      this.longitude = preferences.getDouble('longitude');
      debugPrintThrottled(
          'Saved locations is ${this.latitude} : ${this.longitude}');
    } catch (e) {
      //if saved data is not double
      await _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      this.latitude = position.latitude;
      this.longitude = position.longitude;
      await _saveLocation();
      await _loadWeather();
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
          content: const Text(
              'There is no previous location stored. \n This APP needs your GPS location.'),
          actions: <Widget>[
            FlatButton(
              child: Text('CLOSE APP'),
              onPressed: () {
                SystemNavigator.pop();
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
                _getCurrentLocation();
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
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("$city"),
        actions: <Widget>[Icon(Icons.settings)],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Text(''), //bacground
          widgetToDisplay
        ],
      ),
    );
  }
}
