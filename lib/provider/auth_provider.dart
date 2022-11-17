
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AuthProvider{
  Future<bool> registerUser(String email, String password, String username) async {
    try{
      final auth = FirebaseAuth.instance;
      final User? user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
      ).user;
      if (user != null) {
        FirebaseDatabase.instance.ref().child("auth").child(user.uid).update({
          "email" : user.email,
          "username" : username,
          "isConnected" : false
        });
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    } catch (e){
      Fluttertoast.showToast(msg: "Something went wrong");
      return false;
    }
  }


  Future<bool> signInUser(String email, String password) async {
    try{
      final auth = FirebaseAuth.instance;
      final User? user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;

      if (user != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e){
      Fluttertoast.showToast(msg: e.toString());
      return false;
    } catch (e){
      Fluttertoast.showToast(msg: "Something went wrong");
      return false;
    }
  }
}