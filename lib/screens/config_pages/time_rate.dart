import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:cue_bar/widgets/textfield_widget.dart';
import 'package:cue_bar/widgets/toast_widget.dart';
import 'package:flutter/material.dart';

class TimeRate extends StatefulWidget {
  const TimeRate({super.key});

  @override
  State<TimeRate> createState() => _TimeRateState();
}

class _TimeRateState extends State<TimeRate> {
  final rate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Config')
        .doc('config')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: userData,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            dynamic data = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Current Rate: ${data['rate']}/hour',
                    fontSize: 18,
                    color: Colors.grey,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    inputType: TextInputType.number,
                    controller: rate,
                    label: 'New Rate (per hour)',
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ButtonWidget(
                    color: Colors.black,
                    label: 'Update',
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('Config')
                          .doc('config')
                          .update({'rate': int.parse(rate.text)});
                      showToast('Rate updated!');
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
