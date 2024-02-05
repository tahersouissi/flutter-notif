// Import your RegisterModel class here

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import '../models/register.dart';

class RegisterViewModel {
  Register _registerData = Register();

  // Getters for the properties in the RegisterModel
  String? get username => _registerData.username;
  String? get email => _registerData.email;
  String? get password => _registerData.password;

  // Setters for the properties in the RegisterModel
  set username(String? value) {
    _registerData.username = value;
  }

  set email(String? value) {
    _registerData.email = value;
  }

  set password(String? value) {
    _registerData.password = value;
  }
  Future<bool> registerUser(String email, String password, String username) async {
    try {
      // Create the user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the newly created user's UID
      String uid = userCredential.user!.uid;

      // Store the username in Firestore
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: username,
          id: userCredential.user!.uid,
          imageUrl: 'https://i.pravatar.cc/300?u=$email',
        ),
      );
      return true;
      // Registration successful
    } catch (e) {
      // Registration failed, handle the error
      print(e.toString());
      return false;
    }
  }
}