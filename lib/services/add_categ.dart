import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addCateg(name) async {
  final docUser = FirebaseFirestore.instance.collection('Categories').doc();

  final json = {
    'name': name,
    'dateTime': DateTime.now(),
    'id': docUser.id,
  };

  await docUser.set(json);
}
