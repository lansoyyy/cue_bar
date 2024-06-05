import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addReceipt(name, total, change, List items, mode, refno) async {
  final docUser = FirebaseFirestore.instance.collection('Receipts').doc();

  final json = {
    'name': name,
    'total': total,
    'change': change,
    'items': items,
    'dateTime': DateTime.now(),
    'id': docUser.id,
    'day': DateTime.now().day,
    'month': DateTime.now().month,
    'year': DateTime.now().year,
    'mode': mode,
    'refno': refno,
  };

  await docUser.set(json);
}
