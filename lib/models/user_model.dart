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
  
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
      _loadCurrentUser();
  }

  //voidCallback é uma função que iremos passar e chamar de dentro da nossa função signUp
  void signUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSucess,
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

  void signIn(
      {required String email,
      required String pass,
      required VoidCallback onSucess,
      required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners(); //alteracao realizada e precisa att a tela

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user.user;

      await _loadCurrentUser();

      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.uid)
        .set(userData);
  }

  Future<void> _loadCurrentUser() async {
   firebaseUser ??= _auth.currentUser;
   if(firebaseUser != null){
     DocumentSnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
         .instance
         .collection('users')
         .doc(firebaseUser!.uid)
         .get();
     userData = docUser.data.call()!;
   }
   notifyListeners();
  }
}
