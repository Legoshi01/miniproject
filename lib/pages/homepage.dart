import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../clinic/login.dart';
import '../services/auth_service.dart';
import 'add_product.dart';
import 'edit_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    // final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          IconButton(
            onPressed: () {
              googleSignOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              });
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('${user.email}'),
            Text('${user.displayName}'),
            showList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Move to Add Product Page
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductPage(),
              )).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget showList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Products').snapshots(),
      builder: (context, snapshot) {
        List<Widget> myList;

        if (snapshot.hasData) {
          // Convert snapshot.data to jsonString
          var products = snapshot.data;

          // Define Widgets to myList
          myList = [
            Column(
              children: products!.docs.map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    onTap: () {
                      // Navigate to Edit Product

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductPage(id: doc.id),
                          )).then((value) => setState(() {}));
                    },
                    title: Text('${data['product_name']}'),
                    subtitle: Text('${data['price']}'),
                    trailing: IconButton(
                      onPressed: () {
                        // Create Alert Dialog
                        var alertDialog = AlertDialog(
                          title: const Text('Delete Product Confirmation'),
                          content: Text(
                              'คุณต้องการลบสินค้า ${data['product_name']} ใช่หรือไม่'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ยกเลิก')),
                            TextButton(
                                onPressed: () {
                                  deleteProduct(doc.id);
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
                        Icons.delete_forever,
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
    return FirebaseFirestore.instance
        .collection('Products')
        .doc(id)
        .delete()
        .then((value) => Navigator.pop(context))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
