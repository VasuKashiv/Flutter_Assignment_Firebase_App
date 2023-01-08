// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_database_app/formfield.dart';

class DataBaseServices {
  CollectionReference fieldsCollection =
      FirebaseFirestore.instance.collection('form_fields2');

  List<FormField2> fieldFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs.map((e) {
        return FormField2(name: e['name']);
      }).toList();
    } else {
      return List.empty();
    }
  }

  Stream<List<FormField2>> listFields() {
    return fieldsCollection.snapshots().map(fieldFromFirestore);
  }
}
