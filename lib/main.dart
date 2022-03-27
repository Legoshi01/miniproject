import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '';

import 'clinic/login.dart';
import 'clinic/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Products',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Calendar',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   CalendarController _controller;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _controller = CalendarController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Calendar'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TableCalendar(
//               initialCalendarFormat: CalendarFormat.week,
//               calendarStyle: CalendarStyle(
//                   todayColor: Colors.orange,
//                   selectedColor: Theme.of(context).primaryColor,
//                   todayStyle: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18.0,
//                       color: Colors.white)),
//               headerStyle: HeaderStyle(
//                 centerHeaderTitle: true,
//                 formatButtonDecoration: BoxDecoration(
//                   color: Colors.orange,
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 formatButtonTextStyle: TextStyle(color: Colors.white),
//                 formatButtonShowsNext: false,
//               ),
//               startingDayOfWeek: StartingDayOfWeek.monday,
//               onDaySelected: (date, events) {
//                 print(date.toIso8601String());
//               },
//               builders: CalendarBuilders(
//                 selectedDayBuilder: (context, date, events) => Container(
//                     margin: const EdgeInsets.all(4.0),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(10.0)),
//                     child: Text(
//                       date.day.toString(),
//                       style: TextStyle(color: Colors.white),
//                     )),
//                 todayDayBuilder: (context, date, events) => Container(
//                     margin: const EdgeInsets.all(4.0),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: Colors.orange,
//                         borderRadius: BorderRadius.circular(10.0)),
//                     child: Text(
//                       date.day.toString(),
//                       style: TextStyle(color: Colors.white),
//                     )),
//               ),
//               calendarController: _controller,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
