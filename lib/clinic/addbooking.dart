import 'package:flutter/material.dart';
import '../models/service_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';

class addBooking extends StatefulWidget {
  const addBooking({Key? key, this.id}) : super(key: key);
  final String? id;

  @override
  State<addBooking> createState() => _addBookingState();
}

List<Listservice> dropdownItems = Listservice.getListProductType();
late List<DropdownMenuItem<Listservice>> dropdownMenuItems;
late Listservice _selectedType;
final TextEditingController _name = TextEditingController();
final TextEditingController _price = TextEditingController();

@override
void initState() {
  void.initState();

  dropdownMenuItems = createDropdownMenu(dropdownItems);
  _selectedType = dropdownMenuItems[0].value!;
  //สร้าง function ตอนเริ่มต้น สำหรับดึงข้อมูล
  getdata();
}

Future<void> getdata() async {
  FirebaseFirestore.instance
      .collection('Products')
      .doc(widget.id.toString())
      .get()
      .then((DocumentSnapshot value) {
    Map<String, dynamic> data = value.data()! as Map<String, dynamic>;
    var index = dropdownItems
        .indexWhere((element) => element.value == data['product_type']);
    _name.text = data["product_name"];
    _price.text = data['price'].toString();
    setState(() {
      _selectedType = dropdownMenuItems[index].value!;
    });
  });
}

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

// final TextEditingController _username
class _addBookingState extends State<addBooking> {
  
  CollectionReference bookings =
      FirebaseFirestore.instance.collection('Bookings');
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
      width: 250,
      margin: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
      child: DropdownButton(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        value: _selectedType,
        items: dropdownMenuItems,
        onChanged: (value) {
          setState(() {
            _selectedType = value as Listservice;
          });
        },
      ),
    ),
    Container(
      width: 150,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        onPressed: createBookings,
        child: const Text('บันทึกข้อมูล'),
      ),
    )
    ],
    );
  }
   Future<void> createBookings() async {
    //  QuerySnapshot querySnapshot = await bookings.get();
    // final name = querySnapshot.docs.map((doc) => doc.get('name')).toList();
    return await bookings
        .add({
          'service': _event.text,
          'date_time': selectedDay.toString(),
          'booker': user.displayName, 'id': user.uid

          // 'date_time': DateFormat("yyyy-MM-dd").format(selectedDay)

          // John Doe
        })
        .then((value) => print("Bookings Complete"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
