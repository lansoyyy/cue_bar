import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addItem(name, desc, sku, categ, double price) async {
  final docUser = FirebaseFirestore.instance.collection('Items').doc();

  final json = {
    'name': name,
    'desc': desc,
    'sku': sku,
    'categ': categ,
    'price': price,
    'dateTime': DateTime.now(),
    'id': docUser.id,
  };

  await docUser.set(json);
}
