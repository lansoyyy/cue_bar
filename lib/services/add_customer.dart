import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addCustomer(name, email, number, address) async {
  final docUser = FirebaseFirestore.instance.collection('Customers').doc();

  final json = {
    'name': name,
    'email': email,
    'number': number,
    'address': address,
    'dateTime': DateTime.now(),
    'id': docUser.id,
    'items': [],
    'tableName': '',
    'tablePrice': 0,
    'table': '',
  };

  await docUser.set(json);
}
