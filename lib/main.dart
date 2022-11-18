import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
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

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _getLivePosition,
                  icon: const Icon(Icons.gps_fixed),
                  label: const Text("ON"),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.gps_off),
                  label: const Text("OFF"),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
            ),
            Text(
              'LAT: ${_currentPosition?.latitude ?? ""}',
              textAlign: TextAlign.center,
            ),
            Text(
              'LNG: ${_currentPosition?.longitude ?? ""}',
              textAlign: TextAlign.center,
            ),
            Text(
              'Date: $_now',
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
              'Location services are disabled. Please enable the services'),
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
            content: Text('Location permissions are denied'),
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
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _getLivePosition() async {
    const LocationSettings locationSettings = LocationSettings();
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      setState(() => _currentPosition = position);
      setState(() => _now = DateTime.now());
    });
  }
}
