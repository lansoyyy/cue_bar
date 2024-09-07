import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/customers_screen.dart';
import 'package:cue_bar/screens/new/create_customer_screen.dart';
import 'package:cue_bar/screens/new/table_page.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/screens/sales_pages/sales_page.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/button_widget.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTime();
  }

  final searchController = TextEditingController();
  String nameSearched = '';

  int count = 0;

  double total = 0;

  List items = [];

  bool hasLoaded = false;

  int newRate = 0;

  getTime() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Config') // Replace with your collection name
        .doc('config') // Replace with your document ID
        .get();

    setState(() {
      newRate = documentSnapshot['rate'];
      hasLoaded = true;
    });
  }

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
              setState(() {
                total = 0;
                count = 0;
                items.clear();
              });
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
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
                  builder: (context) => const CustomersScreen()));
            },
            icon: const Icon(
              Icons.group_add_outlined,
            ),
          ),
        ],
      ),
      body: hasLoaded
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCustomersDialog();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => SalesPage(
                          //           items: items,
                          //         )));
                        },
                        child: Container(
                          width: 400,
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
                      GestureDetector(
                        onTap: () {
                          showCustomers();
                        },
                        child: Container(
                          width: 400,
                          height: 125,
                          color: Colors.teal,
                          child: Center(
                            child: TextWidget(
                              text: 'Checkout',
                              fontSize: 32,
                              fontFamily: 'Medium',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                            color: Colors.black,
                            fontFamily: 'Regular',
                            fontSize: 14),
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
                    stream: FirebaseFirestore.instance
                        .collection('Items')
                        .snapshots(),
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
                              padding:
                                  const EdgeInsets.fromLTRB(50, 10, 50, 20),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  String _selectedOption1 = '';

  String selectedId = '';

  int newTotal = 0;

  showCustomersDialog() {
    List newItems = [];
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              width: 500,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: 'Select Customer',
                          fontSize: 24,
                          fontFamily: 'Bold',
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: DropdownButton<String>(
                                underline: const SizedBox(),
                                value: _selectedOption1 == ''
                                    ? data.docs.first['name']
                                    : _selectedOption1,
                                hint: const Text('Select customer'),
                                items: [
                                  for (int i = 0; i < data.docs.length; i++)
                                    DropdownMenuItem<String>(
                                      onTap: () {
                                        setState(
                                          () {
                                            newItems = data.docs[i]['items'];
                                            selectedId = data.docs[i].id;

                                            newtotal = 0;

                                            for (int j = 0;
                                                j <
                                                    data.docs[i]['items']
                                                        .length;
                                                j++) {
                                              newtotal += data.docs[i]['items']
                                                  [j]['price'];
                                            }
                                          },
                                        );
                                      },
                                      value: data.docs[i]['name'],
                                      child: Text(data.docs[i]['name']),
                                    )
                                ],
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedOption1 = newValue!;
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: newItems.isEmpty ? 200 : 0,
                    ),
                    SizedBox(
                      height: newItems.isEmpty ? 0 : 200,
                      child: Column(
                        children: [
                          for (int i = 0; i < newItems.length; i++)
                            SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: newItems[i]['name'],
                                    fontSize: 18,
                                    fontFamily: 'Bold',
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: newItems[i]['price'].toString(),
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontFamily: 'Bold',
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection('Customers')
                                              .doc(selectedId)
                                              .update({
                                            'items': FieldValue.arrayRemove(
                                                [newItems[i]])
                                          });

                                          setState(
                                            () {
                                              newtotal = 0;

                                              newItems.removeAt(i);
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: 'Items Total',
                          fontSize: 16,
                          fontFamily: 'Medium',
                          color: Colors.grey,
                        ),
                        TextWidget(
                          text: newtotal.toString(),
                          fontSize: 32,
                          color: Colors.green,
                          fontFamily: 'Bold',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ButtonWidget(
                        width: 300,
                        color: Colors.green,
                        fontSize: 16,
                        label: 'Charge Item',
                        onPressed: () async {
                          for (int i = 0; i < items.length; i++) {
                            await FirebaseFirestore.instance
                                .collection('Customers')
                                .doc(selectedId)
                                .update({
                              'items': FieldValue.arrayUnion([items[i]])
                            });
                          }

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  showCustomers() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 400,
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Customers')
                      .snapshots(),
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
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () async {
                              int mytotal = 0;

                              if (data.docs[index]['table'] == '') {
                                for (int q = 0;
                                    q < data.docs[index]['items'].length;
                                    q++) {
                                  setState(() {
                                    mytotal += int.parse(data.docs[index]
                                            ['items'][q]['price']
                                        .toInt()
                                        .toString());
                                  });
                                }

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SalesPage(
                                          tableId: '',
                                          customerId: data.docs[index].id,
                                          time: 0,
                                          user: data.docs[index],
                                          total: mytotal,
                                          items: data.docs[index]['items'],
                                        )));
                              } else {
                                // Assume 'data.docs[index]['table']' contains the correct 'id' value to query Firestore.
                                FirebaseFirestore.instance
                                    .collection('Tables')
                                    .where('id',
                                        isEqualTo: data.docs[index]['table'])
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {
                                  if (querySnapshot.docs.isNotEmpty) {
                                    // Retrieve the Timestamp from the first document
                                    Timestamp firestoreTimestamp =
                                        querySnapshot.docs.first['timestarted'];

                                    // Convert Firestore Timestamp to DateTime
                                    DateTime startDateTime =
                                        firestoreTimestamp.toDate();

                                    // Get the current DateTime
                                    DateTime endDateTime = DateTime.now();

                                    // Calculate the difference between the two DateTime objects
                                    Duration difference =
                                        endDateTime.difference(startDateTime);

                                    // Convert the difference to hours and minutes

                                    int minutesDifference = difference
                                            .inMinutes %
                                        60; // Get the remaining minutes after hours

                                    // Print the difference in hours and minutes

                                    for (int q = 0;
                                        q < data.docs[index]['items'].length;
                                        q++) {
                                      setState(() {
                                        mytotal += int.parse(data.docs[index]
                                                ['items'][q]['price']
                                            .toInt()
                                            .toString());
                                      });
                                    }

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => SalesPage(
                                                  tableId: data.docs[index]
                                                      ['table'],
                                                  customerId:
                                                      data.docs[index].id,
                                                  time: ((minutesDifference /
                                                              60) *
                                                          newRate)
                                                      .toInt(),
                                                  user: data.docs[index],
                                                  total: mytotal,
                                                  items: data.docs[index]
                                                      ['items'],
                                                )));
                                  } else {
                                    print('No documents found.');
                                  }
                                }).catchError((error) {
                                  print('Error fetching documents: $error');
                                });
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_circle_rounded,
                                  size: 50,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                TextWidget(
                                  text: data.docs[index]['name'],
                                  fontSize: 24,
                                  fontFamily: 'Bold',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}
