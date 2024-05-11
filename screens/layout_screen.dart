import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:tracker/screens/test.dart';
import 'package:tracker/screens/testttt.dart';

import 'add_device_screen.dart';
import 'blure.dart';
import 'get_data.dart';
import 'home_screen.dart';
import 'map_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  List<TabItem> tabItems = [
    TabItem(icon: Icons.home, title: 'Home'),
    TabItem(icon: Icons.spatial_tracking_outlined, title: 'location'),
    TabItem(icon: Icons.device_unknown_outlined, title: 'add device'),
  ];

  List<Widget>screens=[
    HomeScreen(),
    MapScreen(),
    // FaceBlurPage(),
    AddDeviceScreen()
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:screens[currentIndex], // Your main content goes here
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(10,10,10,10),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              child: BottomBarFloating(
                items: tabItems,
                backgroundColor: Colors.white, // Customize your background color
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: Offset(0, -3))
                ], // Add a custom box shadow
                borderRadius: BorderRadius.circular(20), // Make it circular
                color: Colors.grey, // Customize default icon color
                colorSelected: Colors.blue, // Customize selected icon color
                indexSelected: currentIndex, // Specify the initially selected index
                onTap: (index) {
                  // Handle tap event
                  setState(() {
                    currentIndex = index;
                   screens[index];
                  });
                  print('Tab $currentIndex tapped');
                },
                iconSize: 30, // Change icon size
                titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Change title style
                paddingVertical: 12, // Adjust vertical padding
                top: 16, // Adjust top spacing
                bottom: 16, // Adjust bottom spacing
                pad: 0, // Adjust spacing between icon and title
                duration: Duration(milliseconds: 600), // Change animation duration
                curve: Curves.easeInOut, // Change animation curve
              ),
            ),
            if (currentIndex != null && currentIndex >= 0 && currentIndex < tabItems.length)
              Positioned(
                top: 0,
                left: MediaQuery.of(context).size.width / tabItems.length * currentIndex,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5),
                        color: Colors.blue, // Color of the line
                      ),
                      height: 5,
                      width: MediaQuery.of(context).size.width / tabItems.length/2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
