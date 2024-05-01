import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addTable() async {
  final docUser = FirebaseFirestore.instance
      .collection('Tables')
      .doc(DateTime.now().toString());

  final json = {
    'dateTime': DateTime.now(),
    'id': docUser.id,
  };

  await docUser.set(json);
}
