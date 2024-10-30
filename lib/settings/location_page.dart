import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  LocationPageState createState() => LocationPageState();
}

class LocationPageState extends State<LocationPage> {
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  bool _isLocationOn = false; // Track the state of the location toggle

  @override
  void initState() {
    super.initState();
    // No need to enable location here; it'll be controlled by the toggle
  }

  void _enableLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (kDebugMode) {
        print('Location services are disabled.');
      }
      return; // Location services are not enabled
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        if (kDebugMode) {
          print('Location permission denied.');
        }
        return; // Permissions are not granted
      }
    }

    // Create a LocationSettings object with desired accuracy and distance filter
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    // Start listening for location updates
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
      if (kDebugMode) {
        print('Current Position: ${position.latitude}, ${position.longitude}');
      }
    });
  }

  void _disableLocation() {
    _positionStreamSubscription?.cancel();
    if (kDebugMode) {
      print('Location updates disabled.');
    }
  }

  @override
  void dispose() {
    _disableLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Location Toggle
          SwitchListTile(
            title: Text(
              _isLocationOn ? 'Location On' : 'Location Off',
              style: const TextStyle(fontSize: 16),
            ),
            value: _isLocationOn, // Location toggle state
            onChanged: (value) {
              setState(() {
                _isLocationOn = value; // Update the state
                if (_isLocationOn) {
                  _enableLocation(); // Enable location services
                } else {
                  _disableLocation(); // Disable location services
                }
              });
            },
            secondary: Icon(
              _isLocationOn ? Icons.location_on : Icons.location_off,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white // White icon for dark mode
                  : Colors.black, // Black icon for light mode
            ),
            activeColor: Colors.red.shade700,
            activeTrackColor: Colors.redAccent,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.black12,
          ),
          const SizedBox(height: 20),
          // Display the current location
          _currentPosition != null
              ? Text(
                  'Current Position: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}')
              : const Text('Listening for location updates...'),
        ],
      ),
    );
  }
}
