import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/login_model.dart';

class LoginViewModel extends ChangeNotifier {
  LoginModel loginModel = LoginModel(email: '', password: '');

  void updateEmail(String email) {
    loginModel.email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    loginModel.password = password;
    notifyListeners();
  }

  Future<bool> login(email,password) async {
    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If sign-in is successful, the above function won't throw an exception.
      // You can also check the user's UID to verify that the login was successful.
      if (authResult.user != null) {
        print("login success");
        return true; // Login successful
      } else {
        print("user doesnt exist");
        return false; // Login failed
      }
    } catch (e) {
      print("Login error: $e");
      return false; // Login failed
    }
  }
}
