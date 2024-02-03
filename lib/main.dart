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
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? position1;
  Position? position2;

  Future<void> _getCurrentPosition(int positionNumber) async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        if (positionNumber == 1) {
          position1 = position;
        } else if (positionNumber == 2) {
          position2 = position;
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<double> _calculateDistance() async {
    if (position1 != null && position2 != null) {
      return await Geolocator.distanceBetween(
        position1!.latitude,
        position1!.longitude,
        position2!.latitude,
        position2!.longitude,
      );
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (position1 != null)
              Text(
                'Location 1: ${position1!.latitude}, ${position1!.longitude}',
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _getCurrentPosition(1),
              child: const Text('Get Location 1'),
            ),
            const SizedBox(height: 20),
            if (position2 != null)
              Text(
                'Location 2: ${position2!.latitude}, ${position2!.longitude}',
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _getCurrentPosition(2),
              child: const Text('Get Location 2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final distance = await _calculateDistance();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Distance: $distance meters'),
                  ),
                );
              },
              child: const Text('Calculate Distance'),
            ),
          ],
        ),
      ),
    );
  }
}
