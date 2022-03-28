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

import '../services/auth_service.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  // ignore: non_constant_identifier_names
  CollectionReference bookings =
      FirebaseFirestore.instance.collection('Services');

  late Map<DateTime, List<Event>> salectedEvents;

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(focusedDay);
  // DateTime focusedDay = DateFormat.;

  final TextEditingController _event = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    salectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return salectedEvents[date] ?? [];
  }

  void dispose() {
    _event.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clinic Booking",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
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
                print(focusedDay);
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              eventLoader: _getEventsfromDay,

              //To style the Calendar
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 109, 74, 204),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 92, 255, 230),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ..._getEventsfromDay(selectedDay).map(
              (Event event) => ListTile(
                title: Text(
                  event.title,
                ),
              ),
            ),
            showList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Add Event"),
                  // titleTextStyle: TextStyle(color: Colors.white),
                  content: TextFormField(
                    controller: _event,
                  ),
                  actions: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text("Ok"),
                      onPressed: () {
                        if (_event.text.isEmpty) {
                        } else {
                          if (salectedEvents[selectedDay] != null) {
                            // salectedEvents[selectedDay]?.add(
                            //   Event(title: _event.text),
                            // );
                          } else {
                            salectedEvents[selectedDay] = [
                              Event(title: _event.text)
                            ];
                          }
                          createBookings();
                          getData();
                        }

                        Navigator.pop(context);
                        _event.clear();
                        setState(() {});
                        return;
                      },
                    ),
                  ],
                ),
              ),
          label: Text(
            "Add Event",
            style: GoogleFonts.itim(
                textStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 18)),
          ),
          icon: Icon(Icons.add)),
    );
  }

  // Future<void> createBookings() async {
  //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //   // Call the user's CollectionReference to add a new user
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   UserCredential userCredential = await auth.signInWithCredential(credential);
  //   print(userCredential.user);
  //   return await bookings
  //       .doc(userCredential.user!.uid)
  //       .set({
  //         'service': _event.text,
  //         'date_time': selectedDay.toString()
  //         // John Doe
  //       })
  //       .then((value) => print("User Bookings"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

  Future<void> createBookings() async {
    return await bookings
        .add({
          'service': _event.text,
          'date_time': selectedDay.toString()

          // John Doe
        })
        .then((value) => print("Bookings Complete"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await bookings.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (int i = 0; i < querySnapshot.size; i++) {
      // var a = allData[i];
      // print(a.documentID);
      // salectedEvents[selectedDay] = [Event(title: _event.text)];

      print(allData[i]);
      // print('${{a}.['service']}');
    }

    // print(allData);
  }

  Widget showList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Services').snapshots(),
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
                    title: Text('${data['service']}'),
                    subtitle: Text('${data['date_time']}'),
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
