import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<String> signInWithCredential(String accessToken, String idToken);
  Future<String> saveUserDetailsInFirestore(String userId);
}

class Auth implements BaseAuth {
  Future<String> saveUserDetailsInFirestore(String userId) async {
    Firestore.instance
        .collection('users')
        .document(userId)
        .setData({'role': 'client'});
    return userId;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }

  Future<String> signInWithCredential(
      String accessToken, String idToken) async {
    FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.getCredential(
            accessToken: accessToken, idToken: idToken));
    return user.uid;
  }
}
