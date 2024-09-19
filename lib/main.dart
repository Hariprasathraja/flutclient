import 'package:flutter/material.dart';
import 'pages/home_page.dart';  // Import the HomeScreen from the pages folder

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),  // Use HomeScreen as the main screen
    );
  }
}
