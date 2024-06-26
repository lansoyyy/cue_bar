import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/new/create_customer_screen.dart';
import 'package:cue_bar/screens/new/items_pages/add_item_page.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/drawer_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final searchController = TextEditingController();
  String nameSearched = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddItemPage()));
          },
        ),
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          title: TextWidget(
            text: 'All Items',
            fontSize: 18,
            fontFamily: 'Bold',
            color: Colors.white,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Items').snapshots(),
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
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
                        child: ListTile(
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
                                      text: data.docs[index]['name'],
                                      fontSize: 18,
                                      fontFamily: 'Bold',
                                    ),
                                    TextWidget(
                                      text: data.docs[index]['desc'],
                                      fontSize: 14,
                                      fontFamily: 'Medium',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: SizedBox(
                            width: 175,
                            child: Row(
                              children: [
                                TextWidget(
                                  text: 'P${data.docs[index]['price']}',
                                  fontSize: 18,
                                  fontFamily: 'Bold',
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => AddItemPage(
                                                  inEdit: true,
                                                  data: data.docs[index],
                                                )));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                    size: 35,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text(
                                                'Delete Confirmation',
                                                style: TextStyle(
                                                    fontFamily: 'QBold',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                'Are you sure you want to delete this item?',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular'),
                                              ),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text(
                                                    'Close',
                                                    style: TextStyle(
                                                        fontFamily: 'QRegular',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Items')
                                                        .doc(
                                                            data.docs[index].id)
                                                        .delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Continue',
                                                    style: TextStyle(
                                                        fontFamily: 'QRegular',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_outlined,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
