import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(V34());
}

class V34 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volley34',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
//        backgroundColor: Color(0xFF021B3A),
        backgroundColor: Color(0xFF051426),
        extendBody: true,
        body: Container(),
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(iconPath: "assets/dashboard.svg"),
            FluidNavBarIcon(iconPath: "assets/competition-filled.svg"),
            FluidNavBarIcon(iconPath: "assets/map-filled.svg"),
          ],
          style: FluidNavBarStyle(barBackgroundColor: Color(0xFF21315F), iconSelectedForegroundColor: Colors.white, iconUnselectedForegroundColor: Color(0xFF7E88A2)),
          onChange: null,
        ),
      ),
    );
  }
}
