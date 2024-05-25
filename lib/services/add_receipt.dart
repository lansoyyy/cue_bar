import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addReceipt(name, total, change, List items) async {
  final docUser = FirebaseFirestore.instance.collection('Receipts').doc();

  final json = {
    'name': name,
    'total': total,
    'change': change,
    'items': items,
    'dateTime': DateTime.now(),
    'id': docUser.id,
  };

  await docUser.set(json);
}
