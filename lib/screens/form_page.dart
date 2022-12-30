// ignore_for_file: prefer_final_fields, prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_database_app/constants/ui_constants.dart';
import 'package:employee_database_app/screens/display_info.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  var selectedstatus, selectedgender, enteredNum;
  XFile? file;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDOB = TextEditingController();
  TextEditingController _controllerDOJ = TextEditingController();
  TextEditingController _controllerWorkhours = TextEditingController();
  TextEditingController _controllerFeedback = TextEditingController();
  TextEditingController _controllerJobpos = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();
  String urlImage = '';

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('users');

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
                    .collection('form_fields')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Error ');
                  } else {
                    QuerySnapshot? querySnapshot = snapshot.data;
                    List<QueryDocumentSnapshot> listQueryDocumentSnapshot =
                        querySnapshot!.docs;
                    Map<int, QueryDocumentSnapshot> doc =
                        listQueryDocumentSnapshot.asMap();

                    return Form(
                      key: key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _controllerName,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: kBorderDecoration,
                              hintText: 'Enter your full name',
                              labelText: doc.values.elementAt(3).id,
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }

                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.maxFinite,
                              child: TextFormField(
                                controller: _controllerDOB,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.calendar_today),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: kBorderDecoration,
                                    hintText: 'Select DOB',
                                    labelText: doc.values.elementAt(0).id),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    setState(() {
                                      _controllerDOB.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the DOB';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('form_fields')
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
                                          value: snap.id,
                                          child: Text(snap.id)));
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
                            child: SizedBox(
                              width: double.maxFinite,
                              child: IntlPhoneField(
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: doc.values.elementAt(7).id,
                                  border: kBorderDecoration,
                                ),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {
                                  enteredNum = phone.completeNumber;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: _controllerJobpos,
                              decoration: InputDecoration(
                                hintText: 'Job Position',
                                filled: true,
                                fillColor: Colors.white,
                                labelText: doc.values.elementAt(6).id,
                                border: kBorderDecoration,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your job position';
                                }

                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: SizedBox(
                              width: double.maxFinite,
                              child: TextFormField(
                                controller: _controllerDOJ,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.calendar_today),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: kBorderDecoration,
                                    hintText: 'Select Date of Joining',
                                    labelText: doc.values.elementAt(1).id),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    setState(() {
                                      _controllerDOJ.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your job position';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('form_fields')
                                    .doc('HfOQn9bzJBEAO18uKZIY')
                                    .collection('employment_status')
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
                                          value: snap.id,
                                          child: Text(snap.id)));
                                    }
                                    return Row(
                                      children: [
                                        Text(
                                          'Select your employment status',
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
                                              selectedstatus = newvalue;
                                            });
                                          }),
                                          value: selectedstatus,
                                        ),
                                      ],
                                    );
                                  }
                                })),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: _controllerWorkhours,
                              decoration: InputDecoration(
                                hintText: 'Enter Work Hours',
                                labelText: doc.values.elementAt(8).id,
                                filled: true,
                                fillColor: Colors.white,
                                border: kBorderDecoration,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Working hours';
                                }

                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              maxLines: 5,
                              controller: _controllerFeedback,
                              decoration: InputDecoration(
                                hintText:
                                    'Please provide your valuable feedback',
                                filled: true,
                                fillColor: Colors.white,
                                border: kBorderDecoration,
                              ),
                            ),
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
                                    referenceRoot.child(uniqueFName);

                                //Create a reference for the image to be stored
                                Reference referenceImageToUpload =
                                    referenceDirImages.child('name');

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
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Center(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (urlImage.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Please upload an image')));

                                      return;
                                    }

                                    if (key.currentState!.validate()) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DisplayScreen()));

                                      String personName = _controllerName.text;
                                      String personDOB = _controllerDOB.text;
                                      String personGender = selectedgender;
                                      String personNum = enteredNum;
                                      String personJobpos =
                                          _controllerJobpos.text;
                                      String personDOJ = _controllerDOJ.text;
                                      String personStatus = selectedstatus;
                                      String personWokhours =
                                          _controllerWorkhours.text;
                                      String feedback =
                                          _controllerFeedback.text;

                                      // Create a Map of data
                                      Map<String, String> dataToSend = {
                                        'name': personName,
                                        'dob': personDOB,
                                        'gender': personGender,
                                        'phoneNum': personNum,
                                        'jobpos': personJobpos,
                                        'doj': personDOJ,
                                        'emply_stat': personStatus,
                                        'work_hours': personWokhours,
                                        'feedback': feedback,
                                        'image': urlImage,
                                      };

                                      // Add a new item
                                      _reference.add(dataToSend);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Submit Form',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
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
