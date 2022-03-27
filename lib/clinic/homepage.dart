import '../clinic/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
        title: Text("Clinic Booking"),
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
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Colors.purpleAccent,
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
            // ..._getEventsfromDay(selectedDay).map(
            //   (Event event) => ListTile(
            //     title: Text(
            //       event.title,
            //     ),
            //   ),
            // ),
            showList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Add Event"),
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
                      salectedEvents[selectedDay]?.add(
                        Event(title: _event.text),
                      );
                    } else {
                      salectedEvents[selectedDay] = [Event(title: _event.text)];
                    }
                    // print(_event);
                    createBookings();
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
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
    );
  }

  Future<void> createBookings() async {
    // Call the user's CollectionReference to add a new user
    return await bookings
        .add({
          'service': _event.text,
          'date_time': selectedDay.toString()

          // John Doe
        })
        .then((value) => print("User Bookings"))
        .catchError((error) => print("Failed to add user: $error"));
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
                    // onTap: () {
                    //   // Navigate to Edit Product

                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => EditProductPage(id: doc.id),
                    //       )).then((value) => setState(() {}));
                    // },

                    title: Text('${data['service']}'),
                    subtitle: Text('${data['date_time']}'),
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
                                onPressed: () {}, child: const Text('ยืนยัน')),
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
}
