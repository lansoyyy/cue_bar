import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/new/create_customer_screen.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/drawer_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Receipts',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Receipts')
              .where('day', isEqualTo: DateTime.now().day)
              .where('month', isEqualTo: DateTime.now().month)
              .where('year', isEqualTo: DateTime.now().year)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
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
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextWidget(
                      text: DateFormat.yMMMd().format(DateTime.now()),
                      fontSize: 32,
                      fontFamily: 'Bold',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                for (int i = 0; i < data.docs.length; i++)
                  ExpansionTile(
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
                      child: ListTile(
                        leading: SizedBox(
                          width: 300,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.receipt,
                                size: 40,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'P${data.docs[i]['total']}',
                                    fontSize: 18,
                                    fontFamily: 'Bold',
                                  ),
                                  TextWidget(
                                    text: DateFormat.yMMMd().add_jm().format(
                                        data.docs[i]['dateTime'].toDate()),
                                    fontSize: 14,
                                    fontFamily: 'Medium',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: TextWidget(
                          text: '#1-${i + 1}',
                          fontSize: 16,
                          fontFamily: 'Bold',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    children: [
                      for (int j = 0; j < data.docs[i]['items'].length; j++)
                        ListTile(
                          leading: TextWidget(
                            text: data.docs[i]['items'][j]['sku'].toString(),
                            fontFamily: 'Bold',
                            fontSize: 14,
                          ),
                          title: TextWidget(
                            text: data.docs[i]['items'][j]['name'],
                            fontSize: 18,
                            fontFamily: 'Bold',
                          ),
                          subtitle: TextWidget(
                            text: data.docs[i]['items'][j]['desc'],
                            fontSize: 12,
                          ),
                          trailing: TextWidget(
                            text:
                                'P${data.docs[i]['items'][j]['price'].toString()}.00',
                            fontFamily: 'Bold',
                            fontSize: 14,
                          ),
                        )
                    ],
                  ),
              ],
            );
          }),
    );
  }
}
