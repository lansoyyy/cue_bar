import 'package:cue_bar/widgets/drawer_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Reports',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
    );
  }
}
