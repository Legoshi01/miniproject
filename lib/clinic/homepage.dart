// import 'dart:html';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../clinic/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/service_list.dart';
import '../models/service_list.dart';
import '../services/auth_service.dart';
import 'login.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

List<Listservice> dropdownItems = Listservice.getListservice();
late List<DropdownMenuItem<Listservice>> dropdownMenuItems;
late Listservice _selectedType;

class _homePageState extends State<homePage> {
  // ignore: non_constant_identifier_names
  CollectionReference bookings =
      FirebaseFirestore.instance.collection('Bookings');

  late Map<DateTime, List<Event>> salectedEvents;

  CalendarFormat format = CalendarFormat.month;

  final dateFormat = DateFormat('yyyy-MM-dd ');

  // final dateFormat = DateFormat('yyyy-MM-dd');
  // final dateFormat =
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  // DateTime focusedDay = DateTime(focuseDay.year, focuseDay.month, focuseDay.day, focuseDay.hour, focuseDay.minute);
  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(focusedDay);
  // DateTime focusedDay = DateFormat.;

  TextEditingController _event = TextEditingController();

  @override
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

    salectedEvents = {};
    super.initState();
    dropdownMenuItems = createDropdownMenu(dropdownItems);
    _selectedType = dropdownMenuItems[0].value!;
    realgetdata();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return salectedEvents[date] ?? [];
  }

  void dispose() {
    _event.dispose();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clinic Booking",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
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
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: Container(
        child: ListView(
          children: [
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(1990),
              lastDay: DateTime(2050),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekVisible: true,

              //Day Changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
                print(dateFormat.format(focusedDay));
                // print(DateFormat("yyyy-MM-dd ").format(focusedDay));
                // print(focusedDay.toString());
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              eventLoader: _getEventsfromDay,

              //To style the Calendar
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 79, 211, 196),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 8, 94, 125),
                  shape: BoxShape.circle,
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 8, 94, 125),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ..._getEventsfromDay(selectedDay).map(
              (Event _selectedType) => ListTile(
                title: Text(
                  _selectedType.title,
                ),
              ),
            ),
            // showList(),
          ],
        ),
      ),
      drawer: Drawer(
        // backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 79, 211, 196),
              ),
              child: Text(
                user.displayName.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Text(user.displayName.toString(),
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 24,
            //     )),
            ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 79, 211, 196),
                ),
                title: Text('Logout'),
                onTap: () {
                  googleSignOut().then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  });
                }),
            // ListTile(
            //   leading: Icon(Icons.library_books_rounded),
            //   title: Text('ItemCalories'),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const ItemCalories(),
            //         )).then((value) => setState(() {}));
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.login_outlined),
            //   title: Text('log Out'),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const LoginPage(),
            //         )).then((value) => setState(() {}));
            //   },
            // ),
            // const Divider(),
            // // Expanded(
            // //   child: Align(
            // //     alignment: Alignment.bottomLeft,
            // //     child: ListTile(
            // //       title: Text('Item 3'),
            // //       onTap: () {},
            // //     ),
            // //   ),
            // // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Add Event"),
                  content: DropdownButton(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    value: _selectedType,
                    items: dropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value as Listservice;
                        print(_selectedType.name);
                        setState(() {});
                      });
                    },
                  ),
                  actions: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text("Ok"),
                      onPressed: () {
                        if (_selectedType.name.toString().isEmpty) {
                          // print(
                          // 'มาแล้วววววว ไม่เข้า comminggggggggggggggggggg');
                        } else {
                          if (salectedEvents[selectedDay] != null) {
                            salectedEvents[selectedDay]?.add(
                              Event(title: _selectedType.name.toString()),
                            );
                          } else {
                            salectedEvents[selectedDay] = [
                              Event(title: _selectedType.name.toString())
                            ];
                          }
                          createBookings();
                          // print('มาแล้วววววว comminggggggggggggggggggg');
                          // realgetdata();
                        }

                        Navigator.pop(context);
                        // _event.clear();
                        setState(() {});
                        return;
                      },
                    ),
                  ],
                ),
              ),
          label: Text(
            "Booking",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          icon: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  Future<void> createBookings() async {
    // _event = _selectedType.value.toString() as TextEditingController;
    //  QuerySnapshot querySnapshot = await bookings.get();
    // final name = querySnapshot.docs.map((doc) => doc.get('name')).toList();
    return await bookings
        .add({
          'service': _selectedType.name.toString(),
          'date_time': selectedDay.toString(),
          'booker': user.displayName, 'id': user.uid

          // 'date_time': DateFormat("yyyy-MM-dd").format(selectedDay)

          // John Doe
        })
        .then((value) => print("Bookings Complete"))
        // .then((value) => print(_selectedType.name.toString()))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> showdata() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await bookings.get();

    // Get data from docs and convert map to List
    final datee =
        querySnapshot.docs.map((doc) => doc.get('date_time')).toList();
    final serv = querySnapshot.docs.map((doc) => doc.get('service')).toList();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (int i = 0; i < querySnapshot.size; i++) {
      Card(
        child: ListTile(
          title: Text(serv[i]),
          subtitle: Text(datee[i]),
        ),
      );
      print(allData[i]);
    }

    // print(allData);
  }

  Future<void> realgetdata() async {
    QuerySnapshot querySnapshot = await bookings.get();

    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final datee =
        querySnapshot.docs.map((doc) => doc.get('date_time')).toList();
    final serv = querySnapshot.docs.map((doc) => doc.get('service')).toList();
    final Uid = querySnapshot.docs.map((doc) => doc.get('id')).toList();
    // var datetime = DateTime.parse(date);

    for (int i = 0; i < querySnapshot.size; i++) {
      DateTime conDate = DateTime.parse(datee[i]);
      if (Uid[i] == user.uid) {
        if (salectedEvents[conDate] != null) {
          salectedEvents[conDate]?.add(
            Event(title: serv[i]),
          );
        } else {
          salectedEvents[conDate] = [Event(title: serv[i])];
        }

        print(conDate);
        print(serv[i].toString());
      } else {}
    }
    setState(() {});
  }

  Widget showList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Bookings').snapshots(),
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
                    title: Text('${data['booker']}'),
                    subtitle: Text('${data['date_time']}'),

                    // subtitle: Text(data.),
                  ),
                );
                // ignore: dead_code
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
}
