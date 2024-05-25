import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/new/create_customer_screen.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/drawer_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:cue_bar/widgets/textfield_widget.dart';
import 'package:cue_bar/widgets/toast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaymentPage extends StatefulWidget {
  double total;
  double payment;

  PaymentPage({super.key, required this.total, required this.payment});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextWidget(
              text: 'Cue Bar and Billiards',
              fontSize: 18,
              fontFamily: 'Bold',
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'P${widget.total}',
                      fontSize: 48,
                      fontFamily: 'Bold',
                      color: Colors.green,
                    ),
                    TextWidget(
                      text: 'Total Paid',
                      fontSize: 14,
                      fontFamily: 'Medium',
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 25,
                ),
                const SizedBox(
                    height: 100,
                    child: VerticalDivider(
                      color: Colors.black,
                    )),
                const SizedBox(
                  width: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'P${widget.payment - widget.total}',
                      fontSize: 48,
                      fontFamily: 'Bold',
                      color: Colors.green,
                    ),
                    TextWidget(
                      text: 'Change',
                      fontSize: 14,
                      fontFamily: 'Medium',
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            ButtonWidget(
              color: Colors.green,
              label: 'PAID',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
