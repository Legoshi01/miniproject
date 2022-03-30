import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 102, 207, 211),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 222, 226),
                Color.fromARGB(255, 5, 216, 216)
              ],
              stops: [0.5, 1.0],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // CustomInputFieldFb1(
              //   hintText: "Name",
              //   inputController: _name,
              //   labelText: "Name",
              // ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: false,
                controller: _name,
                validator: (vaLue) {
                  if (vaLue!.isEmpty) {
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
                controller: _age,
                validator: (vaLue) {
                  if (vaLue!.isEmpty) {
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
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _email,
                validator: (vaLue) {
                  if (vaLue!.isEmpty) {
                    return "Please enter your Email";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      color: Colors.teal[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                obscuringCharacter: '*',
                controller: _password,
                validator: (vaLue) {
                  if (vaLue!.isEmpty) {
                    return "please enter your Password";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.teal[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    )),
              ),
              // CustomInputFieldFb1(
              //   hintText: "Age",
              //   inputController: _age,
              //   labelText: "Age",
              // ),
              // SizedBox(height: 36),
              // CustomInputFieldFb1(
              //   hintText: "Email",
              //   inputController: _email,
              //   labelText: "Email",
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // CustomInputFieldFb1(
              //   hintText: "Password",
              //   inputController: _password,
              //   labelText: "Password",
              //   password: true,
              // ),
              SizedBox(height: 20),
              GradientButtonFb1(
                  text: "Register",
                  onPressed: () {
                    registerUser(
                            _name.text, _age.text, _email.text, _password.text)
                        .then((value) => {
                              if (value != null)
                                {print('add complete'), Navigator.pop(context)}
                              else
                                {print('error')}
                            });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

// class CustomInputFieldFb1 extends StatelessWidget {
//   final TextEditingController inputController;
//   final String hintText;
//   final Color primaryColor;
//   final String labelText;
//   final bool? password;

//   const CustomInputFieldFb1(
//       {Key? key,
//       required this.inputController,
//       required this.hintText,
//       required this.labelText,
//       this.primaryColor = Colors.cyan,
//       this.password})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(boxShadow: [
//         BoxShadow(
//             offset: const Offset(12, 26),
//             blurRadius: 50,
//             spreadRadius: 0,
//             color: Colors.grey.withOpacity(.1)),
//       ]),
//       child: TextField(
//         controller: inputController,
//         obscureText: password == true ? true : false,
//         onChanged: (value) {
//           //Do something wi
//         },
//         keyboardType: TextInputType.emailAddress,
//         style: const TextStyle(fontSize: 16, color: Colors.black),
//         decoration: InputDecoration(
//           labelText: labelText,
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           filled: true,
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
//           fillColor: Colors.transparent,
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
//           border: UnderlineInputBorder(
//             borderSide:
//                 BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: primaryColor, width: 2.0),
//           ),
//           errorBorder: const UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.red, width: 2.0),
//           ),
//           enabledBorder: UnderlineInputBorder(
//             borderSide:
//                 BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
//           ),
//         ),
//       ),
//     );
//   }
// }

class GradientButtonFb1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const GradientButtonFb1(
      {required this.text, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 79, 211, 196);
    const secondaryColor = Color.fromARGB(255, 79, 211, 196);
    const accentColor = Color.fromARGB(255, 255, 255, 255);

    const double borderRadius = 15;

    return DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient:
                const LinearGradient(colors: [primaryColor, secondaryColor])),
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              alignment: Alignment.center,
              padding: MaterialStateProperty.all(const EdgeInsets.only(
                  right: 75, left: 75, top: 15, bottom: 15)),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius)),
              )),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(color: accentColor, fontSize: 16),
          ),
        ));
  }
}
