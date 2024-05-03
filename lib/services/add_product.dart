import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addProduct(img, name, price) async {
  final docUser = FirebaseFirestore.instance.collection('Products').doc();

  final json = {
    'img': img,
    'name': name,
    'price': price,
    'dateTime': DateTime.now(),
    'id': docUser.id,
  };

  await docUser.set(json);
}
