
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/Providers/PlaylistProvider.dart';

import 'package:spotify_clone/splashScreen.dart';


void main()async {
  
  runApp(ChangeNotifierProvider(
      create: (context) => PlaylistProvider(),
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(), // Set SplashScreen as the initial screen
    );
  }
}
