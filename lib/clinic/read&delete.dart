import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class read_deletePage extends StatefulWidget {
  const read_deletePage({Key? key}) : super(key: key);

  @override
  State<read_deletePage> createState() => _read_deletePageState();
}

// final user = FirebaseAuth.instance.currentUser!;

class _read_deletePageState extends State<read_deletePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Cancle Booking', style: TextStyle(color: Colors.white)),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            showList(),
          ],
        ),
      ),
    );
  }

  Widget showList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Bookings')
          .where('id', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        List<Widget> myList;

        if (snapshot.hasData) {
          // Convert snapshot.data to jsonString
          var booking = snapshot.data;

          // Define Widgets to myList
          myList = [
            Column(
              children: booking!.docs.map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

                return Card(
                  child: ListTile(
                    onTap: () {},
                    title: Text('${data['service']}'),
                    subtitle: Text('${data['date_time']}'),
                    trailing: IconButton(
                      onPressed: () {
                        // Create Alert Dialog
                        var alertDialog = AlertDialog(
                          title: const Text('Delete Booking?'),
                          content: Text(
                              'คุณต้องการยกเลิกการจองวันที่ ${data['date_time']} \nใช่หรือไม่'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ยกเลิก')),
                            TextButton(
                                onPressed: () {
                                  deleteProduct(doc.id);
                                  setState(() {});
                                },
                                child: const Text('ยืนยัน')),
                          ],
                        );
                        // Show Alert Dialog
                        showDialog(
                            context: context,
                            builder: (context) => alertDialog);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ];
        } else if (snapshot.hasError) {
          myList = [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('ข้อผิดพลาด: ${snapshot.error}'),
            ),
          ];
        } else {
          myList = [
            const SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('อยู่ระหว่างประมวลผล'),
            )
          ];
        }

        return Center(
          child: Column(
            children: myList,
          ),
        );
      },
    );
  }

  Future<void> deleteProduct(String? id) {
    //  if(user.uid!=id){
    //    exit()
    //  }

    return FirebaseFirestore.instance
        .collection('Bookings')
        .doc(id)
        .delete()
        .then((value) => Navigator.pop(context))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
