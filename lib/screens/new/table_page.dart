import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  void _startCounter1(int count1, StreamController controller1) {
    Future<void>.delayed(const Duration(seconds: 1), () {
      count1++;
      controller1.sink.add(count1);
      _startCounter1(count1, controller1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          addTable();
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Tables',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Tables').snapshots(),
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

            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                  'Delete Confirmation',
                                  style: TextStyle(
                                      fontFamily: 'QBold',
                                      fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  'Are you sure you want to delete this table?',
                                  style: TextStyle(fontFamily: 'QRegular'),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(
                                          fontFamily: 'QRegular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await FirebaseFirestore.instance
                                          .collection('Tables')
                                          .doc(data.docs[index].id)
                                          .delete();
                                    },
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                          fontFamily: 'QRegular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ));
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                data.docs[index]['started']
                                    ? Text(
                                        'Hours: ${DateTime.now().difference(data.docs[index]['timestarted'].toDate()).inHours.toString()}, Minutes: ${DateTime.now().difference(data.docs[index]['timestarted'].toDate()).inMinutes.toString()}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Bold',
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 20,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: data.docs[index]['started']
                                      ? Colors.red
                                      : Colors.green,
                                  onPressed: () async {
                                    if (data.docs[index]['started']) {
                                      await FirebaseFirestore.instance
                                          .collection('Tables')
                                          .doc(data.docs[index].id)
                                          .update({
                                        'started': false,
                                        'timestarted': '',
                                      });
                                    } else {
                                     showCustomers(data.docs[index].id);
                                     
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          !data.docs[index]['started']
                                              ? Icons.play_arrow
                                              : Icons.stop,
                                          size: 48,
                                          color: Colors.white,
                                        ),
                                        TextWidget(
                                          text: !data.docs[index]['started']
                                              ? 'Start'
                                              : 'Stop',
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
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  String format(data) {
    return '${(data ~/ 3600).toString().padLeft(2, '0')}:${((data % 3600) ~/ 60).toString().padLeft(2, '0')}';
  }

  showCustomers(String id) {
    return showDialog(context: context, builder: (context) {
      return Dialog(
        child: SizedBox(
          height: 400,
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Customers').snapshots(),
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
                return ListView.builder(itemCount: data.docs.length,                  
                  itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () async {

                             await FirebaseFirestore.instance
                                          .collection('Tables')
                                          .doc(id)
                                          .update({
                                        'started': true,
                                        'timestarted': DateTime.now(),
                                      });

                                       await FirebaseFirestore.instance
                                          .collection('Customers')
                                          .doc(data.docs[index].id)
                                          .update({
                                   
    'table': id,
                                      });
                            
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.account_circle_rounded,
                              size: 50,),
                              const SizedBox(width: 20,),
                              TextWidget(text: data.docs[index]['name'], fontSize: 24,
                              fontFamily: 'Bold',),
                            ],
                          ),
                        ),
                      );
                    },);
              }
            ),
          ),
        ),
      );
    },);
  }
}
