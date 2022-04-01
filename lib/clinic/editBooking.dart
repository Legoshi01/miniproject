import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/service_list.dart';
import 'homepage.dart';

class editbooking extends StatefulWidget {
  const editbooking({Key? key}) : super(key: key);

  @override
  State<editbooking> createState() => _editbookingState();
}

void initState() {
  // TODO: implement initState

  List<DropdownMenuItem<Listservice>> createDropdownMenu(
      List<Listservice> dropdownItems) {
    List<DropdownMenuItem<Listservice>> items = [];

    for (var item in dropdownItems) {
      items.add(DropdownMenuItem(
        child: Text(item.name!),
        value: item,
      ));
    }

    return items;
  }

  dropdownMenuItems = createDropdownMenu(dropdownItems);

  _selectedType = dropdownMenuItems[0].value!;
}

List<Listservice> dropdownItems = Listservice.getListservice();
late List<DropdownMenuItem<Listservice>> dropdownMenuItems;
Listservice? _selectedType;

final user = FirebaseAuth.instance.currentUser!;

class _editbookingState extends State<editbooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editpage'),
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
                    onTap: () {
                      editBooking(doc.id);
                    },
                    title: Text('${data['service']}'),
                    subtitle: Text('${data['date_time']}'),
                    trailing: IconButton(
                      onPressed: () {
                        // Create Alert Dialog
                        var alertDialog = AlertDialog(
                          title: const Text('Delete Booking?'),
                          content: DropdownButtonFormField(
                            // borderRadius: const BorderRadius.all(Radius.circular(16)),
                            value: _selectedType,
                            items: dropdownMenuItems,
                            onChanged: (value) {
                              _selectedType = value as Listservice;
                              print(_selectedType?.name);
                              setState(() {});
                            },
                          ),
                          // actions: [
                          //   TextButton(
                          //     child: Text("Cancel"),
                          //     onPressed: () => Navigator.pop(context),
                          //   ),
                          //   TextButton(
                          //     child: Text("Ok"),
                          //     onPressed: () {
                          //       if (_selectedType.name.toString().isEmpty) {
                          //         // print(
                          //         // 'มาแล้วววววว ไม่เข้า comminggggggggggggggggggg');
                          //       } else {
                          //         // createBookings();
                          //         // print('มาแล้วววววว comminggggggggggggggggggg');
                          //         // realgetdata();
                          //       }

                          //       Navigator.pop(context);
                          //       // _event.clear();
                          //       setState(() {});
                          //       return;
                          //     },
                          //   ),
                          // ],
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
            // const Icon(
            //   Icons.error_outline,
            //   color: Colors.red,
            //   size: 60,
            // ),
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

  Future<void> editBooking(
    String? id,
  ) {
    //  if(user.uid!=id){
    //    exit()
    //  }

    return FirebaseFirestore.instance
        .collection('Bookings')
        .doc(id)
        .update({'service': _selectedType?.name})
        .then((value) => Navigator.pop(context))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
