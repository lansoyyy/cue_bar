import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/new/create_customer_screen.dart';
import 'package:cue_bar/screens/new/table_page.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/screens/sales_pages/sales_page.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/drawer_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:cue_bar/widgets/toast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';

  int count = 0;

  double total = 0;

  List items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
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
            const SizedBox(
              width: 20,
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              child: Center(
                child: TextWidget(
                  text: count.toString(),
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Bold',
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TableScreen()));
            },
            icon: const Icon(
              Icons.table_restaurant_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CreateCustomerScreen()));
            },
            icon: const Icon(
              Icons.group_add_outlined,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                newtotal = total;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SalesPage(
                          items: items,
                        )));
              },
              child: Container(
                width: double.infinity,
                height: 125,
                color: Colors.teal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'CHARGE',
                      fontSize: 18,
                      fontFamily: 'Medium',
                      color: Colors.white,
                    ),
                    TextWidget(
                      text: 'P$total',
                      fontSize: 32,
                      fontFamily: 'Bold',
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontFamily: 'Regular', fontSize: 14),
                  onChanged: (value) {
                    setState(() {
                      nameSearched = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintText: 'Search Item',
                      hintStyle: TextStyle(fontFamily: 'Bold'),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      )),
                  controller: searchController,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Items').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    for (int i = 0; i < data.docs.length; i++)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              items.add(data.docs[i].data());
                              count++;
                              total += data.docs[i]['price'];
                            });
                          },
                          leading: SizedBox(
                            width: 300,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.folder_open_outlined,
                                  size: 50,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: data.docs[i]['name'],
                                      fontSize: 18,
                                      fontFamily: 'Bold',
                                    ),
                                    TextWidget(
                                      text: data.docs[i]['desc'],
                                      fontSize: 14,
                                      fontFamily: 'Medium',
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: TextWidget(
                            text: 'P${data.docs[i]['price']}',
                            fontSize: 18,
                            fontFamily: 'Bold',
                          ),
                        ),
                      ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
