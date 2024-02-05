import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase/components/entry_field.dart';
import 'package:test_firebase/login/login_view.dart';
import 'package:test_firebase/register/registerViewModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  String? username;
  final RegisterViewModel registerViewModel = RegisterViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 60.0), // Add space between the top and the logo
            Center(
              child: Form(
                key: _formkey,
                child: Container(
                  width: 150.0, // Adjust the size as needed
                  height: 150.0,
                  child: Center(
                    child: Image.asset(
                      "assets/test.png", // Replace with your logo or image
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: EntryField(
                  controller: _usernameController,
                  hintText: "username",
                )),
            SizedBox(height: 20.0),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: EntryField(
                  validatorMessage: "empty",
                  controller: _emailController,
                  hintText: "Email",
                )),
            SizedBox(height: 20.0),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: EntryField(
                  controller: _passwordController,
                  hintText: "password",
                  obsecureText: true,
                )),
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: () async {
                  email = _emailController.text;
                  password = _passwordController.text;
                  username = _usernameController.text;
                  final registrationResult = registerViewModel.registerUser(
                      email!, password!, username!);
                  if (await registrationResult) {
                    Fluttertoast.showToast(
                        msg: "User created successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 15.0);
                    final fcmToken =
                        await FirebaseMessaging.instance.getToken();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  }
                  else {
                    Fluttertoast.showToast(
                        msg: "User already exists ! ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 15.0);
                  }


                },
                child: Text(
                  'Register',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? "),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            // Row with social media icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mail,
                  size: 40.0, // Adjust the icon size as needed
                  color: Colors.black, // Change color to match Gmail's color
                ),
                SizedBox(width: 20.0),
                Icon(
                  Icons.facebook,
                  size: 40.0, // Adjust the icon size as needed
                  color: Colors.black, // Change color to match Facebook's color
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }
}
