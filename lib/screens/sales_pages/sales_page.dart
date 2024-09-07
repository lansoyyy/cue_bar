import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/new/create_customer_screen.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/screens/sales_pages/payment_page.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/drawer_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:cue_bar/widgets/textfield_widget.dart';
import 'package:cue_bar/widgets/toast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

double newtotal = 0;

class SalesPage extends StatefulWidget {
  dynamic user;
  List items;
  int total;
  int time;
  String tableId;
  String customerId;

  SalesPage(
      {super.key,
      required this.items,
      required this.customerId,
      required this.tableId,
      required this.user,
      required this.total,
      required this.time});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final cash = TextEditingController(text: newtotal.toInt().toString());

  int table = 0;

  int hour = 0;

  final String _selectedOption1 = '';
  final String _selectedOption2 = '';
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: 'Total Amount to Pay',
                fontSize: 18,
                fontFamily: 'Medium',
                color: Colors.black,
              ),
              TextWidget(
                text: '${widget.total + widget.time}',
                fontSize: 48,
                fontFamily: 'Bold',
                color: Colors.green,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                width: 500,
                inputType: TextInputType.number,
                controller: cash,
                label: 'Cash Received',
              ),
              TextFieldWidget(
                width: 500,
                isRequred: false,
                isEnabled: false,
                controller: TextEditingController(
                    text: 'Customer: ${widget.user['name']}'),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 50,
              ),
              ButtonWidget(
                color: Colors.green,
                label: 'CASH',
                onPressed: () {
                  if (double.parse((widget.total + widget.time).toString()) <=
                      double.parse(cash.text)) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentPage(
                            customerId: widget.customerId,
                            tableId: widget.tableId,
                            mode: 'Cash',
                            time: widget.time.toDouble(),
                            items: widget.items,
                            user: _selectedOption1,
                            payment: double.parse(cash.text),
                            total: double.parse(
                                (widget.total + widget.time).toString()))));
                  } else {
                    showToast('Insufficient cash received!');
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonWidget(
                color: Colors.blue,
                label: 'GCASH',
                onPressed: () {
                  if (double.parse((widget.total + widget.time).toString()) <=
                      double.parse(cash.text)) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentPage(
                            customerId: widget.customerId,
                            tableId: widget.tableId,
                            mode: 'GCash',
                            time: widget.time.toDouble(),
                            items: widget.items,
                            user: _selectedOption1,
                            payment: double.parse(cash.text),
                            total: double.parse(
                                (widget.total + widget.time).toString()))));
                  } else {
                    showToast('Insufficient cash received!');
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonWidget(
                color: Colors.amber,
                label: 'Debit/Credit',
                onPressed: () {
                  if (double.parse((widget.total + widget.time).toString()) <=
                      double.parse(cash.text)) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentPage(
                            customerId: widget.customerId,
                            tableId: widget.tableId,
                            mode: 'Card',
                            time: widget.time.toDouble(),
                            items: widget.items,
                            user: _selectedOption1,
                            payment: double.parse(cash.text),
                            total: double.parse(
                                (widget.total + widget.time).toString()))));
                  } else {
                    showToast('Insufficient cash received!');
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
