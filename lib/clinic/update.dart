import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'homepage.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({Key? key}) : super(key: key);

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  CollectionReference info = FirebaseFirestore.instance.collection('Users');
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController Sname = TextEditingController();
  final TextEditingController age = TextEditingController();

  // TextEditingController Sname = Null as TextEditingController;
  // TextEditingController age = Null as TextEditingController;
  // final TextEditingController _height = TextEditingController();

  CollectionReference bookings = FirebaseFirestore.instance.collection('Users');
  //   QuerySnapshot querySnapshot = await bookings.get();
  // final datee = querySnapshot.docs.map((doc) => doc.get('date_time')).toList();
  // final serv = querySnapshot.docs.map((doc) => doc.get('service')).toList();
  @override
  final current = FirebaseAuth.instance.currentUser!;

  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title:
            const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const homePage(),
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 79, 211, 196),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // TextFormField(
              //   controller: name,
              //   decoration: const InputDecoration(
              //     icon: const Icon(Icons.person_pin_circle_rounded),
              //     hintText: 'Enter your name',
              //     labelText: 'Name',
              //   ),
              // ),
              // TextFormField(
              //   controller: age,
              //   decoration: const InputDecoration(
              //     icon: const Icon(Icons.face),
              //     hintText: 'Enter your Age',
              //     labelText: 'Age',
              //   ),
              // ),
              TextFormField(
                obscureText: false,
                controller: Sname,
                validator: (vaLue) {
                  if (vaLue!.isEmpty || vaLue == null) {
                    return "Please enter your name";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Name',
                    prefixIcon: Icon(
                      Icons.person_pin_circle_rounded,
                      color: Colors.teal[400],
                      size: 37,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                obscureText: false,
                controller: age,
                validator: (vaLue) {
                  if (vaLue!.isEmpty || vaLue == null) {
                    return "Please enter your age";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Age',
                    prefixIcon: Icon(
                      Icons.face,
                      color: Colors.teal[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    )),
              ),
              // TextFormField(
              //   controller: _height,
              //   decoration: const InputDecoration(
              //     icon: const Icon(Icons.height),
              //     hintText: 'Enter your Height',
              //     labelText: 'Height',
              //   ),
              // ),
              Container(
                  padding: const EdgeInsets.only(
                      left: 100, right: 100, top: 10, bottom: 8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 79, 211, 196),
                    )),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(user.uid)
                          .update({
                            'name': Sname.text,
                            'age': age.text,
                            // 'height': _height.text,
                          })
                          .then((value) => print("Updated"))
                          .catchError(
                              (error) => print("Failed to add user: $error"));

                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Edit Profile'),
                          content: const Text('Edited'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      const SizedBox(
                        width: 8,
                      );
                      setState(() {});
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getdata() async {
    QuerySnapshot querySnapshot = await bookings.get();

    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    final age = querySnapshot.docs.map((doc) => doc.get('age')).toList();
    final _name = querySnapshot.docs.map((doc) => doc.get('name')).toList();
    final _Uid = querySnapshot.docs.map((doc) => doc.get('id')).toList();
    // var datetime = DateTime.parse(date);

    for (int i = 0; i < querySnapshot.size; i++) {
      if (_Uid[i] == current.uid) {
        Sname = _name as TextEditingController;
        print(Sname);
      }
    }
  }
}
