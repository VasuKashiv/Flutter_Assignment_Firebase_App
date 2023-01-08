// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unused_field, prefer_final_fields, unused_local_variable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_database_app/screens/form_page_2.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  CollectionReference _referenceUsers =
      FirebaseFirestore.instance.collection('users');
  late Stream<QuerySnapshot> _streamdata;
  @override
  void initState() {
    _streamdata = _referenceUsers.snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFF9FBFC),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Employee Data '),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamdata,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.active) {
            QuerySnapshot? querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> listQueryDocumentSnapshot =
                querySnapshot!.docs;

            return ListView.builder(
              itemCount: listQueryDocumentSnapshot.length,
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot document =
                    listQueryDocumentSnapshot[index];

                return Container(
                  height: 320,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.all(20),
                    elevation: 3,
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: AutoSizeText(
                                        'Full Name',
                                        minFontSize: 18,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Expanded(
                                          child: AutoSizeText(
                                        document['full name'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 18,
                                        maxLines: 1,
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => FormPage_x()));
        },
        tooltip: 'Submit New Form',
        child: const Icon(Icons.add),
      ),
    );
  }
}
