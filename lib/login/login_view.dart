import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/entry_field.dart';
import '../home/homeView.dart';
import '../register/registerView.dart';
import '../utils/chat/rooms.dart';
import '../utils/firebase_api.dart';
import 'login_view_model.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel loginViewModel = LoginViewModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? email;
  String? password;
  String? username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 60.0), // Add space between the top and the logo
            Center(
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

            SizedBox(height: 20.0),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: EntryField(
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

                  final isLoggedin = loginViewModel.login(email, password);

                  if (await isLoggedin) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // Name, email address, and profile photo URL
                      await _getCurrentUserName();

                      // Check if user's email is verified
                      final emailVerified = user.emailVerified;

                      // The user's ID, unique to the Firebase project. Do NOT use this value to
                      // authenticate with your backend server, if you have one. Use
                      // User.getIdToken() instead.
                      Fluttertoast.showToast(
                        msg: "Welcome $username",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 15.0);
                      print(username);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoomsPage() )
                    );
                    }
                  } else
                    (Fluttertoast.showToast(
                        msg: "Invalid User Credentials",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 15.0));
                },
                child: Text(
                  'Login',
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
                      MaterialPageRoute(builder: (context) => RegisterView()),
                    );
                  },
                  child: Text(
                    "Sign up",
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

  Future<void> _getCurrentUserName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((snapshot) {
      setState(()  {
        username = (snapshot.data() as Map<String, dynamic>)['firstName']
            .toString(); // change this
        print("myname $username");
      });
    });
    prefs.setString("username", username!);
  }
}
