import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _startCounter1(int count1, StreamController controller1) {
    Future<void>.delayed(const Duration(seconds: 1), () {
      count1++;
      controller1.sink.add(count1);
      _startCounter1(count1, controller1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Config')
        .doc('config')
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: userData,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          dynamic rateData = snapshot.data;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                addTable();
              },
            ),
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: TextWidget(
                text: 'Cue Bar and Billiards',
                fontSize: 18,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ConfigPage()));
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Tables').snapshots(),
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

                  return ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      int count = 0;
                      final controller = StreamController<int>.broadcast();

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 5,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: StreamBuilder<int>(
                                stream: controller.stream,
                                initialData: count,
                                builder: (context, snapshot1) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/pool-table.png',
                                            height: 150,
                                          ),
                                          TextWidget(
                                            text: 'Table ${index + 1}',
                                            fontSize: 24,
                                            fontFamily: 'Bold',
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                  text:
                                                      '${(snapshot1.data! ~/ 60).toString().padLeft(2, '0')}:${(snapshot1.data! % 60).toString().padLeft(2, '0')}',
                                                  fontSize: 45,
                                                  fontFamily: 'Bold',
                                                ),
                                                TextWidget(
                                                  text: 'Time',
                                                  fontSize: 11,
                                                  fontFamily: 'Medium',
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            color: snapshot1.data == 0
                                                ? Colors.red
                                                : Colors.green,
                                            onPressed: () {
                                              if (snapshot1.data == 0) {
                                                _startCounter1(
                                                    count, controller);
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                            'Checkout Confirmation',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'QBold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: const Text(
                                                            'Are you sure you want to checkout?',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'QRegular'),
                                                          ),
                                                          actions: <Widget>[
                                                            MaterialButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true),
                                                              child: const Text(
                                                                'Close',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'QRegular',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            MaterialButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (context) => ProductScreen(
                                                                              rate: (rateData['rate'] / 3600).toInt(),
                                                                              time: snapshot1.data!,
                                                                            )));
                                                              },
                                                              child: const Text(
                                                                'Continue',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'QRegular',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ));
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    snapshot1.data == 0
                                                        ? Icons.play_arrow
                                                        : Icons
                                                            .monetization_on_outlined,
                                                    size: 48,
                                                    color: Colors.white,
                                                  ),
                                                  TextWidget(
                                                    text: snapshot1.data == 0
                                                        ? 'Start'
                                                        : 'Checkout',
                                                    fontSize: 11,
                                                    fontFamily: 'Medium',
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ),
                      );
                    },
                  );
                }),
          );
        });
  }

  String format(data) {
    return '${(data ~/ 3600).toString().padLeft(2, '0')}:${((data % 3600) ~/ 60).toString().padLeft(2, '0')}';
  }
}
