import 'package:flutter/material.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
      "Home Page",
      style: TextStyle(fontSize: 35.0),
    )));
  }
}

class AboutScreens extends StatelessWidget {
  const AboutScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
      "About Page",
      style: TextStyle(fontSize: 35.0),
    )));
  }
}

class ServicesScreens extends StatelessWidget {
  const ServicesScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
      "Services Page",
      style: TextStyle(fontSize: 35.0),
    )));
  }
}
