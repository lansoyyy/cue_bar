import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/receipt_page.dart';
import 'package:cue_bar/services/add_product.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:cue_bar/widgets/textfield_widget.dart';
import 'package:cue_bar/widgets/toast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class ProductScreen extends StatefulWidget {
  int time;
  int rate;

  ProductScreen({
    super.key,
    required this.rate,
    required this.time,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final name = TextEditingController();
  final price = TextEditingController();
  final searchController = TextEditingController();
  String nameSearched = '';

  List items = [];

  @override
  Widget build(BuildContext context) {
    int total = widget.time * widget.rate;
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green,
            child: const Icon(
              Icons.monetization_on_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReceiptScreen(
                        items: items,
                        timerate: widget.time * 5,
                        total: total,
                      )));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              addProductDialog();
            },
          ),
        ],
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Products',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
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
                      hintText: 'Search Product',
                      hintStyle: TextStyle(fontFamily: 'Regular'),
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
                  .collection('Products')
                  .where('name',
                      isGreaterThanOrEqualTo:
                          toBeginningOfSentenceCase(nameSearched))
                  .where('name',
                      isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
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
                return Expanded(
                  child: GridView.builder(
                    itemCount: data.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            int qty = 1;
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return SizedBox(
                                    height: 350,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 300,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  data.docs[index]['img'],
                                                ),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextWidget(
                                          text: data.docs[index]['name'],
                                          fontSize: 18,
                                          fontFamily: 'Medium',
                                        ),
                                        TextWidget(
                                          text:
                                              'P${int.parse(data.docs[index]['price']) * qty}.00',
                                          fontSize: 24,
                                          fontFamily: 'Bold',
                                          color: Colors.green,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if (qty > 1) {
                                                  setState(() {
                                                    qty--;
                                                  });
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.remove,
                                              ),
                                            ),
                                            TextWidget(
                                              text: qty.toString(),
                                              fontSize: 32,
                                              fontFamily: 'Bold',
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  qty++;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        ButtonWidget(
                                          color: Colors.black,
                                          label: 'Add to Expenses',
                                          onPressed: () {
                                            int toAdd = int.parse(
                                                    data.docs[index]['price']) *
                                                qty;
                                            setState(
                                              () {
                                                items.add({
                                                  'name': data.docs[index]
                                                      ['name'],
                                                  'price': int.parse(data
                                                      .docs[index]['price']),
                                                  'qty': qty,
                                                  'total': toAdd,
                                                });
                                                total += toAdd;
                                              },
                                            );

                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              },
                            );
                          },
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            data.docs[index]['img'],
                                          ),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextWidget(
                                    text: data.docs[index]['name'],
                                    fontSize: 15,
                                    fontFamily: 'Medium',
                                  ),
                                  TextWidget(
                                    text: 'P${data.docs[index]['price']}.00',
                                    fontSize: 18,
                                    fontFamily: 'Bold',
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Products/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Products/$fileName')
            .getDownloadURL();

        Navigator.of(context).pop();

        showToast('Image uploaded!');
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  addProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                      onTap: () {
                        uploadPicture('gallery')
                            .whenComplete(() => setState(() {}));
                      },
                      child: imageURL == ''
                          ? Container(
                              width: double.infinity,
                              height: 110,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.upload,
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 110,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      imageURL,
                                    ),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            )),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    controller: name,
                    label: 'Product Name',
                  ),
                  TextFieldWidget(
                    inputType: TextInputType.number,
                    controller: price,
                    label: 'Product Price',
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Close',
                style: TextStyle(
                    fontFamily: 'QRegular', fontWeight: FontWeight.bold),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                addProduct(imageURL, name.text, price.text);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Add',
                style: TextStyle(
                    fontFamily: 'QRegular', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
