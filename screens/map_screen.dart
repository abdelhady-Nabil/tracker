// // import 'dart:async';
// // import 'dart:typed_data';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:location/location.dart';
// //
// // class MapScreen extends StatefulWidget {
// //   MapScreen({Key? key, this.title}) : super(key: key);
// //   final String? title;
// //
// //   @override
// //   _MapScreenState createState() => _MapScreenState();
// // }
// //
// // class _MapScreenState extends State<MapScreen> {
// //   StreamSubscription? _locationSubscription;
// //   Location _locationTracker = Location();
// //   Marker? marker;
// //   Circle? circle;
// //   GoogleMapController? _controller;
// //   Set<Polyline> pathPolyline = <Polyline>{};
// //   List<LatLng>lL= <LatLng>[];
// //
// //
// //
// //
// //
// //   static final CameraPosition initialLocation = CameraPosition(
// //     target: LatLng(30.069128221241392, 31.31227016074638),
// //     zoom: 19.4746,
// //   );
// //
// //   Future<Uint8List> getMarker() async {
// //     ByteData byteData = await DefaultAssetBundle.of(context).load("assets/delivery.png");
// //     return byteData.buffer.asUint8List();
// //   }
// //
// //   void updateMarkerAndCircleAndPath(LocationData newLocalData, Uint8List imageData) {
// //     LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
// //     setState(() {
// //       marker = Marker(
// //           markerId: MarkerId("home"),
// //           position: latlng,
// //           rotation: newLocalData.heading!,
// //           draggable: false,
// //           zIndex: 2,
// //           flat: true,
// //           anchor: Offset(0.5, 0.5),
// //           icon: BitmapDescriptor.fromBytes(imageData)
// //       );
// //       circle = Circle(
// //           circleId: CircleId("car"),
// //           radius: newLocalData.accuracy!,
// //           zIndex: 1,
// //           strokeColor: Colors.blue,
// //           center: latlng,
// //           fillColor: Colors.blue.withAlpha(70));
// //       lL.add(latlng);
// //       pathPolyline.add(
// //         Polyline(
// //             polylineId: PolylineId('1'),
// //             color: Colors.yellow,
// //             width: 5,
// //             points:lL,
// //             patterns: [
// //               PatternItem.dash(20),
// //               PatternItem.gap(10),
// //             ]
// //
// //         ),
// //       );
// //
// //     });
// //   }
// //
// //   void getCurrentLocation() async {
// //     try {
// //
// //       Uint8List imageData = await getMarker();
// //
// //       var location = await _locationTracker.getLocation();
// //
// //       updateMarkerAndCircleAndPath(location, imageData);
// //
// //       if (_locationSubscription != null) {
// //         _locationSubscription!.cancel();
// //       }
// //
// //
// //       _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
// //         if (_controller != null) {
// //           _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
// //               bearing: 90.8334901395799,
// //               target: LatLng(newLocalData.latitude!, newLocalData.longitude!),
// //               tilt: 0,
// //               zoom: 18.00)));
// //           updateMarkerAndCircleAndPath(newLocalData, imageData);
// //         }
// //       });
// //
// //     } on PlatformException catch (e) {
// //       if (e.code == 'PERMISSION_DENIED') {
// //         debugPrint("Permission Denied");
// //       }
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     if (_locationSubscription != null) {
// //       _locationSubscription!.cancel();
// //     }
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Directionality(
// //             textDirection: TextDirection.rtl,
// //             child: Center(child: Text('map'))),
// //       ),
// //       body: GoogleMap(
// //         mapType: MapType.hybrid,
// //         initialCameraPosition: initialLocation,
// //         markers: Set.of((marker != null) ? [marker!] : []),
// //         circles: Set.of((circle != null) ? [circle!] : []),
// //         polylines: pathPolyline,
// //         onMapCreated: (GoogleMapController controller) {
// //           _controller = controller;
// //         },
// //
// //       ),
// //       floatingActionButton: Container(
// //         padding: EdgeInsets.only(right: 35, ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           children: [
// //             FloatingActionButton(
// //
// //                 child: Icon(Icons.location_searching),
// //                 onPressed: () {
// //                   getCurrentLocation();
// //                 }),
// //             SizedBox(width: 5,),
// //             FloatingActionButton(
// //
// //                 child: Icon(Icons.close),
// //                 onPressed: () {
// //                   if (_locationSubscription != null) {
// //                     _locationSubscription!.cancel();
// //                   }
// //                 }),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_map/flutter_map.dart';
// // import 'package:latlong2/latlong.dart';
// //
// // class MapScreen extends StatefulWidget {
// //   const MapScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<MapScreen> createState() => _MapScreenState();
// // }
// //
// // class _MapScreenState extends State<MapScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Open street map'),
// //       ),
// //       body: content(),
// //     );
// //   }
// // }
// //
// // Widget content(){
// //   return FlutterMap(
// //     options: MapOptions(
// //       center: LatLng(1.2878,103.8666),
// //       zoom: 11,
// //       interactiveFlags: InteractiveFlag.doubleTapZoom
// //     ),
// //     children: [
// //       openStreetMapTileLayer,
// //     ],
// //   );
// // }
// // TileLayer get openStreetMapTileLayer => TileLayer(
// //   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
// //   userAgentPackageName: 'dev.fleaflet.flutter_map.example',
// // );
//
//
//
// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map/plugin_api.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';
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
//   StreamSubscription? _locationSubscription;
//   Location _locationTracker = Location();
//   CircleMarker? circle;
//   MapController? _controller;
//   List<LatLng> lL = [
//     LatLng(37.395389, -122.096246), // Initial coordinates
//     LatLng(37.361855, -122.081515), // second
//   ];
//
//   static final LatLng initialLocation = LatLng(1.2878,103.8666);
//   static final double initialZoom = 11.0;
//
//   Marker? marker = Marker(
//     width: 100,
//     height:100,
//     point: initialLocation, // Initial location
//     builder: (context) => Icon(Icons.location_pin, color: Colors.red), // Use your image here
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = MapController();
//   }
//
//   Future<Uint8List> getMarker() async {
//     ByteData byteData = await DefaultAssetBundle.of(context).load("assets/delivery.png");
//     return byteData.buffer.asUint8List();
//   }
//
//   void updateMarkerAndCircleAndPath(LocationData newLocalData, Uint8List imageData) {
//     LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
//     setState(() {
//       marker = Marker(
//         width: 50.0,
//         height: 50.0,
//         point: latlng,
//         builder: (context) => Icon(Icons.delivery_dining, color: Colors.blue), // Use your image here
//       );
//       circle = CircleMarker(
//         point: latlng,
//         color: Colors.blue.withOpacity(0.3),
//         radius: newLocalData.accuracy!,
//       );
//       lL.add(latlng); // Add new location to the list
//     });
//   }
//
//   void getCurrentLocation() async {
//     try {
//       Uint8List imageData = await getMarker();
//
//       var location = await _locationTracker.getLocation();
//
//       updateMarkerAndCircleAndPath(location, imageData);
//
//       if (_locationSubscription != null) {
//         _locationSubscription!.cancel();
//       }
//
//       _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
//         if (_controller != null) {
//           _controller!.move(LatLng(newLocalData.latitude!, newLocalData.longitude!), initialZoom);
//           updateMarkerAndCircleAndPath(newLocalData, imageData);
//         }
//       });
//     } on PlatformException catch (e) {
//       if (e.code == 'PERMISSION_DENIED') {
//         debugPrint("Permission Denied");
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     if (_locationSubscription != null) {
//       _locationSubscription!.cancel();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Directionality(
//           textDirection: TextDirection.rtl,
//           child: Center(child: Text('map')),
//         ),
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
//              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
//           ),
//           MarkerLayer(
//             markers: [
//               if (marker != null) marker!,
//             ],
//           ),
//           CircleLayer(
//             circles: [
//               if (circle != null) circle!,
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
//         mapController: _controller,
//       ),
//       floatingActionButton: Container(
//         padding: EdgeInsets.only(right: 35),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FloatingActionButton(
//               child: Icon(Icons.location_searching),
//               onPressed: getCurrentLocation,
//             ),
//             SizedBox(width: 5),
//             FloatingActionButton(
//               child: Icon(Icons.close),
//               onPressed: () {
//                 if (_locationSubscription != null) {
//                   _locationSubscription!.cancel();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _handleTap(TapPosition tapPosition, LatLng latLng) {
//     // Handle tap event here
//     print("Tapped on: $latLng");
//   }
// }
