// import 'dart:convert';
// import 'dart:async'; // Add this import
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
//
// import '../shared/consteant.dart';
//
// class MapScreen extends StatefulWidget {
//   MapScreen({Key? key, this.title}) : super(key: key);
//   final String? title;
//
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   List<dynamic> data = [];
//   List<LatLng> lL = []; // Initialize the list of LatLng
//
//   static final LatLng initialLocation = LatLng(1.2878, 103.8666);
//   static final double initialZoom = 11.0;
//
//   Marker? marker = Marker(
//     width: 100,
//     height: 100,
//     point: initialLocation, // Initial location
//     builder: (context) => Icon(Icons.location_pin, color: Colors.red), // Use your image here
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     // Initial fetch
//     fetchDataFromFirebase();
//     // Schedule periodic fetch every 2 seconds
//     Timer.periodic(Duration(seconds: 2), (_) => fetchDataFromFirebase());
//   }
//
//   Future<void> fetchDataFromFirebase() async {
//     final response = await http.get(Uri.parse('https://tracking-app-10503-default-rtdb.firebaseio.com/.json'));
//
//     if (response.statusCode == 200) {
//       final dynamic responseData = json.decode(response.body);
//
//       setState(() {
//         if (responseData != null && responseData is Map<String, dynamic>) {
//           // Check if responseData is not null and is of type Map<String, dynamic>
//           data = responseData.entries.map((entry) => entry.value).toList();
//
//           // Update the list of LatLng with data from the first MapScreen
//           lL = data
//               .map((item) => LatLng(
//             item['latitude'] ?? 0.0, // Provide default value if latitude is null
//             item['longitude'] ?? 0.0, // Provide default value if longitude is null
//           ))
//               .toList();
//         }
//       });
//     } else {
//       throw Exception('Failed to load data from Firebase');
//     }
//   }
//   //
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map'),
//       ),
//       body: FlutterMap(
//         options: MapOptions(
//           center: initialLocation,
//           zoom: initialZoom,
//           onTap: (tapPosition, latLng) {
//             _handleTap(tapPosition, latLng);
//           },
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'dev.fleaflet.flutter_map.example',
//           ),
//           MarkerLayer(
//             markers: [
//               if (marker != null) marker!,
//             ],
//           ),
//           PolylineLayer(
//             polylines: [
//               Polyline(
//                 points: lL,
//                 strokeWidth: 5,
//                 color: Colors.yellow,
//                 isDotted: true,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _handleTap(TapPosition tapPosition, LatLng latLng) {
//     // Handle tap event here
//     print("Tapped on: $latLng");
//   }
// }
