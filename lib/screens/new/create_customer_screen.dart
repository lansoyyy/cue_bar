import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/drawer_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:cue_bar/widgets/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateCustomerScreen extends StatefulWidget {
  const CreateCustomerScreen({super.key});

  @override
  State<CreateCustomerScreen> createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Create Customer',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: Column(
          children: [
            TextFieldWidget(
              width: double.infinity,
              controller: name,
              label: 'Customer Name',
            ),
            TextFieldWidget(
              width: double.infinity,
              controller: email,
              label: 'Customer Email',
            ),
            TextFieldWidget(
              width: double.infinity,
              controller: phone,
              inputType: TextInputType.number,
              label: 'Customer Contact Number',
            ),
            TextFieldWidget(
              width: double.infinity,
              controller: address,
              inputType: TextInputType.streetAddress,
              label: 'Customer Address',
            ),
            const SizedBox(
              height: 25,
            ),
            ButtonWidget(
              color: Colors.black,
              label: 'CREATE',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
