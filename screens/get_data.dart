import 'dart:convert';
import 'dart:async'; // Add this import
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<dynamic> data = [];

  List<LatLng> locations = [];
  StreamSubscription? _locationSubscription;
  Location _locationTracker = Location();
  CircleMarker? circle;
  MapController? _controller;

  static final LatLng initialLocation = LatLng(30.043005,31.237377);
  static final double initialZoom = 11.0;

  Marker? marker = Marker(
    width: 100,
    height:100,
    point: initialLocation, // Initial location
    builder: (context) => Icon(Icons.location_pin, color: Colors.red), // Use your image here
  );



  @override
  void initState() {
    super.initState();
    _controller = MapController();
    // Initial fetch
    fetchDataFromFirebase();
    // Schedule periodic fetch every 2 seconds
    Timer.periodic(Duration(seconds: 2), (_) => fetchDataFromFirebase());
  }

  Future<void> fetchDataFromFirebase() async {
    // Add initial location to the locations list
    locations.clear(); // Clear previous data
    locations.add(initialLocation);

    final response = await http.get(Uri.parse('https://tracking-app-10503-default-rtdb.firebaseio.com/.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      setState(() {
        data = responseData.entries.map((entry) => entry.value).toList();

        // Add values to locations
        for (int i = 0; i < data.length; i++) {
          final Map<String, dynamic> itemData = data[i];

          // Iterate over the entries and extract the 'data' values
          for (var entry in itemData.entries) {
            final dynamic value = entry.value['data']; // Get the value associated with the key
            if (value != null) { // Ensure value is not null
              // Split the string into latitude and longitude components
              List<String> coordinates = value.toString().split(',');
              double latitude = double.parse(coordinates[0].trim());
              double longitude = double.parse(coordinates[1].trim());

              // Create LatLng object and add to locations
              locations.add(LatLng(latitude, longitude));

              // Print the location to the terminal
              print("Location: $latitude, $longitude");
            }
          }
        }

        // Update marker with the last location
        if (locations.isNotEmpty) {
          final lastLocation = locations.last;
          marker = Marker(
            width: 100,
            height: 100,
            point: lastLocation,
            builder: (_) => Image.asset('assets/delivery.png'), // Replace 'assets/marker_icon.png' with your image path
          );
        }
      });
    } else {
      throw Exception('Failed to load data from Firebase');
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(child: Text('map')),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: initialLocation,
          zoom: initialZoom,
          onTap: (tapPosition, latLng) {
            _handleTap(tapPosition, latLng);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          MarkerLayer(
            markers: [
              if (marker != null) marker!,
            ],
          ),
          CircleLayer(
            circles: [
              if (circle != null) circle!,
            ],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: locations,
                strokeWidth: 5,
                color: Colors.yellow,
                isDotted: true,
              ),
            ],
          ),
        ],
        mapController: _controller,
      ),
    );
  }
  void _handleTap(TapPosition tapPosition, LatLng latLng) {
    // Handle tap event here
    print("Tapped on: $latLng");
  }

}
