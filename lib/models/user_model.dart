import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class UserModel extends Model {
  //passando o Firebase para o obj _auth para facilitar a chamada
  FirebaseAuth _auth = FirebaseAuth.instance;

  //usuario logado com o ID e info basicas
  User? firebaseUser;

  //vai obrigar os dados importantes do user
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  //voidCallback é uma função que iremos passar e chamar de dentro da nossa função signUp

  void signUp({required Map<String, dynamic> userData, required String pass, required VoidCallback onSucess,
    required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: pass)
        .then((user) async {
      firebaseUser = user.user;
      await _saveUserData(userData);

      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn() async {
    isLoading = true;

    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  bool isLoggedIn(){
    return firebaseUser != null;

  }

  void recoverPass() {

  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).set(userData);
  }
}
