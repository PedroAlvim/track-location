import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final token = await FirebaseMessaging.instance.getToken();
  debugPrint("Token: $token");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track Location',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Track Location'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _currentPosition;
  DateTime? _now;
  StreamSubscription<Position>? _stream;

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      debugPrint("Event: $event");

      _showNotificationActionEvent();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Rastrear localização do dispositivo',
              style: TextStyle(fontSize: 20),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton.icon(
                  onPressed: () {
                    _startTrackLocation();
                    debugPrint("ON PRESS");
                  },
                  icon: const Icon(Icons.gps_fixed),
                  label: const Text("ON"),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    debugPrint("OFF PRESS");
                    _cancelTrackLocation();
                  },
                  icon: const Icon(Icons.gps_off),
                  label: const Text("OFF"),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
            ),
            Text(
              'LAT: ${_currentPosition?.latitude ?? "Rastreio desligado"}',
              textAlign: TextAlign.center,
            ),
            Text(
              'LNG: ${_currentPosition?.longitude ?? "Rastreio desligado"}',
              textAlign: TextAlign.center,
            ),
            Text(
              'Date: ${_now ?? "Rastreio desligado"}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location services are disabled. Please enable the services',
          ),
        ),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are denied',
            ),
          ),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _cancelTrackLocation() async {
    _stream?.cancel();
    try {
      FlutterForegroundTask.stopService();
    } catch (_) {}
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    setState(() => _currentPosition = null);
    setState(() => _now = null);
  }

  void _showNotificationActionEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'EU CHEGUEI AQUI',
        ),
      ),
    );
  }

  Future<void> _startTrackLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    late LocationSettings locationSettings;

    _stream?.cancel();

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 3),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "the app will continue to receive your location",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    var geoLocator =
        Geolocator.getPositionStream(locationSettings: locationSettings);

    _stream = geoLocator.listen((Position? position) {
      setState(() => _currentPosition = position);
      setState(() => _now = DateTime.now());

      debugPrint("Lat: ${position!.latitude}");
      debugPrint("Long: ${position.longitude}");
      debugPrint("data: ${DateTime.now()}");
    });
  }
}
