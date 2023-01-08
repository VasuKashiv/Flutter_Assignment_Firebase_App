// ignore_for_file: prefer_final_fields, prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously, prefer_typing_uninitialized_variables, camel_case_types, non_constant_identifier_names, unused_element, await_only_futures, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_database_app/constants/ui_constants.dart';
import 'package:employee_database_app/screens/display_info.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FormPage_x extends StatefulWidget {
  const FormPage_x({super.key});

  @override
  State<FormPage_x> createState() => _FormPage_xState();
}

class _FormPage_xState extends State<FormPage_x> {
  var selectedstatus, selectedgender, enteredNum;
  XFile? file;

  GlobalKey<FormState> key = GlobalKey();
  String urlImage = '';

  List<TextEditingController> editfieldController = [];
  var selectedEditIndex, selectindx;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFF9FBFC),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Flutter Form '),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 2000,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 50),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('form_fields2')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Error ');
                  } else {
                    List<String?> x = [];
                    for (var i = 0; i < snapshot.data!.docs.length; i++) {
                      x.add(snapshot.data!.docs[i].id);
                    }

                    editfieldController = [
                      for (int i = 0; i < snapshot.data!.docs.length; i++)
                        (TextEditingController())
                    ];

                    List<Widget> data() {
                      List<Widget> list = [];

                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];

                        list.add(Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: editfieldController[i],
                            onFieldSubmitted: ((value) {
                              editfieldController[i].text = value;
                              print(editfieldController[i].text);

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc('val')
                                  .update({
                                snap.id: editfieldController[i].text,
                              });
                            }),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: kBorderDecoration,
                              hintText: 'Enter your ${snap.id}',
                              labelText: snap.id,
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your${snap.id}';
                              }
                              return null;
                            },
                          ),
                        )); //add any Widget in place of Text("Index $i")
                      }
                      return list; // all widget added now retrun the list here
                    }

                    return Form(
                      key: key,
                      child: Column(children: [
                        Column(
                          children: data(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('form_fields2')
                                  .doc('HfOQn9bzJBEAO18uKZIY')
                                  .collection('gender')
                                  .snapshots(),
                              builder: ((context, snapshot) {
                                if (!snapshot.hasData) {
                                  selectedstatus = null;
                                  return Text('No data');
                                } else {
                                  List<DropdownMenuItem> menuItem = [];
                                  for (var i = 0;
                                      i < snapshot.data!.docs.length;
                                      i++) {
                                    DocumentSnapshot snap =
                                        snapshot.data!.docs[i];
                                    menuItem.add(DropdownMenuItem(
                                        value: snap.id, child: Text(snap.id)));
                                  }
                                  return Row(
                                    children: [
                                      Text(
                                        'Select your gender',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      DropdownButton(
                                        iconSize: 50,
                                        items: menuItem,
                                        onChanged: ((newvalue) {
                                          setState(() {
                                            selectedgender = newvalue;
                                          });
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc('val')
                                              .update({
                                            'gender': selectedgender,
                                          });
                                        }),
                                        value: selectedgender,
                                      ),
                                    ],
                                  );
                                }
                              })),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              ImagePicker imagePicker = ImagePicker();
                              file = await imagePicker.pickImage(
                                  source: ImageSource.camera);
                              print('${file?.path}');

                              if (file == null) return;

                              /*Step 2: Upload to Firebase storage*/
                              //Install firebase_storage
                              //Import the library
                              String uniqueFName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              //Get a reference to storage root
                              Reference referenceRoot =
                                  FirebaseStorage.instance.ref();
                              Reference referenceDirImages =
                                  referenceRoot.child('images');

                              //Create a reference for the image to be stored
                              Reference referenceImageToUpload =
                                  referenceDirImages.child(uniqueFName);

                              //Handle errors/success
                              try {
                                //Store the file
                                await referenceImageToUpload
                                    .putFile(File(file!.path));
                                //Success: get the download URL
                                urlImage = await referenceImageToUpload
                                    .getDownloadURL();
                              } catch (error) {
                                //Some error occurred
                                print(error);
                              }
                              if (urlImage.isNotEmpty) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc('val')
                                    .update({
                                  'urlImage': urlImage,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Image Uploaded Sucessfully')));

                                return;
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Upload Your Image',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: (() {
                              if (key.currentState!.validate()) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DisplayScreen()));
                              }
                            }),
                            child: Text('Submit'))
                      ]),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
