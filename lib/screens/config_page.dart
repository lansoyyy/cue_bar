import 'package:cue_bar/screens/config_pages/time_rate.dart';
import 'package:cue_bar/screens/login_screen.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Configurations',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Card(
              elevation: 3,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TimeRate()));
                },
                leading: TextWidget(
                  text: 'Time rate (per hour)',
                  fontSize: 18,
                  fontFamily: 'Bold',
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right_rounded,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              elevation: 3,
              child: ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text(
                              'Logout Confirmation',
                              style: TextStyle(
                                  fontFamily: 'QBold',
                                  fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              'Are you sure you want to Logout?',
                              style: TextStyle(fontFamily: 'QRegular'),
                            ),
                            actions: <Widget>[
                              MaterialButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                      fontFamily: 'QRegular',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                },
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                      fontFamily: 'QRegular',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ));
                },
                leading: TextWidget(
                  text: 'Logout',
                  fontSize: 18,
                  fontFamily: 'Bold',
                ),
                trailing: const Icon(
                  Icons.logout,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
