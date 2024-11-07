import 'dart:async';
import 'package:flutter/material.dart';
import 'homepage.dart'; // Import homepage.dart

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Tween for scaling
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start the animation
    _controller.forward();

    // Navigate to the next screen after 1 second
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset('assets/spotify-download-logo-30.png'),
        ),
      ),
    );
  }
}
