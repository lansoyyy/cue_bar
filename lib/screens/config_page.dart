import 'package:cue_bar/screens/config_pages/time_rate.dart';
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
          ],
        ),
      ),
    );
  }
}
