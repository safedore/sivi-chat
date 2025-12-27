import 'package:flutter/material.dart';
import 'package:my_sivi_chat/src/screens/main_nav_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Sivi Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainNavScreen(title: 'My Sivi Chat'),
    );
  }
}
