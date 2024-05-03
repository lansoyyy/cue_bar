import 'package:cue_bar/screens/home_screen.dart';
import 'package:cue_bar/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Image.asset(
              'assets/images/123.jpg',
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          Center(
            child: ButtonWidget(
              textColor: Colors.black,
              color: Colors.white,
              label: 'Get Started',
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
