import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:tracker/shared/consteant.dart';

class MapScreen2 extends StatefulWidget {
  MapScreen2({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MapScreen2State createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  StreamSubscription? _locationSubscription;
  Location _locationTracker = Location();
  CircleMarker? circle;
  MapController? _controller;
  List<LatLng> lL = [];

  static final LatLng initialLocation = LatLng(1.2878,103.8666);
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
    _subscribeToUserLocation();
  }

  void _subscribeToUserLocation() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid) // Replace uid with the actual user ID
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        final List<dynamic>? locationData = snapshot.data()?['location'];
        if (locationData != null && locationData.isNotEmpty) {
          final List<LatLng> newLocation = locationData
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList();
          setState(() {
            lL = newLocation;
            final lastLocation = lL.last;
            marker = Marker(
              width: 100,
              height: 100,
              point: lastLocation,
              builder: (context) => Image.asset('assets/delivery.png'), // Replace 'assets/your_image.png' with your image asset path
            );
          });
        }
      }
    });
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
                points: lL,
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
