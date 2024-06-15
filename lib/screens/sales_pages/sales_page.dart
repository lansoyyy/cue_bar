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
  List items;

  SalesPage({super.key, required this.items});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final cash = TextEditingController(text: newtotal.toInt().toString());

  double mytotal = 0;

  int table = 0;

  int hour = 0;

  String _selectedOption1 = '';
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
                text: 'Total Amount of Items',
                fontSize: 18,
                fontFamily: 'Medium',
                color: Colors.black,
              ),
              TextWidget(
                text: 'P${mytotal == 0 ? newtotal : mytotal}',
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
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Customer',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Customers')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }

                        final data = snapshot.requireData;

                        return Container(
                          width: 500,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButton<String>(
                              underline: const SizedBox(),
                              value: _selectedOption1 == ''
                                  ? data.docs.first['name']
                                  : _selectedOption1,
                              hint: const Text('Select category'),
                              items: <String>[
                                for (int i = 0; i < data.docs.length; i++)
                                  data.docs[i]['name']
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedOption1 = newValue!;
                                });
                              },
                            ),
                          ),
                        );
                      }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Select Customer Table',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Tables')
                          .where('started', isEqualTo: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }

                        final data = snapshot.requireData;

                        if (mytotal == 0) {
                          DateTime currentDateTime = DateTime.now();

                          Duration difference = currentDateTime.difference(
                              data.docs.first['timestarted'].toDate());

                          int hoursDifference = difference.inHours;
                          mytotal = (220 * hoursDifference).toDouble() +
                              newtotal.toDouble();
                        }

                        return data.docs.isNotEmpty
                            ? SizedBox(
                                width: 500,
                                height: 150,
                                child: ListView.builder(
                                  itemCount: data.docs.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        DateTime currentDateTime =
                                            DateTime.now();

                                        Duration difference =
                                            currentDateTime.difference(data
                                                .docs[index]['timestarted']
                                                .toDate());

                                        int hoursDifference =
                                            difference.inHours;
                                        setState(() {
                                          table = index;

                                          mytotal = (220 * hoursDifference)
                                                  .toDouble() +
                                              newtotal.toDouble();
                                        });
                                      },
                                      child: Card(
                                        elevation: 3,
                                        child: Container(
                                          color: table == index
                                              ? Colors.amber
                                              : Colors.grey,
                                          width: 150,
                                          height: 150,
                                          child: Center(
                                            child: TextWidget(
                                              text: 'Table ${index + 1}',
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontFamily: 'Bold',
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Center(
                                  child: TextWidget(
                                    text: 'No active table.',
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                      }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 50,
              ),
              ButtonWidget(
                color: Colors.green,
                label: 'CASH',
                onPressed: () {
                  if (mytotal <= double.parse(cash.text)) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentPage(
                              mode: 'Cash',
                              time: (220 * hour).toDouble(),
                              items: widget.items,
                              user: _selectedOption1,
                              payment: double.parse(cash.text),
                              total: mytotal,
                            )));
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
                  if (mytotal < double.parse(cash.text)) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentPage(
                              mode: 'GCash',
                              time: (220 * hour).toDouble(),
                              items: widget.items,
                              user: _selectedOption1,
                              payment: double.parse(cash.text),
                              total: mytotal,
                            )));
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
                  if (mytotal < double.parse(cash.text)) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentPage(
                              mode: 'Card',
                              time: (220 * hour).toDouble(),
                              items: widget.items,
                              user: _selectedOption1,
                              payment: double.parse(cash.text),
                              total: mytotal,
                            )));
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
