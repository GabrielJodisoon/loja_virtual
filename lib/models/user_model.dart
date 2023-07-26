import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class UserModel extends Model{

  //passando o Firebase para o obj _auth para facilitar a chamada
  FirebaseAuth _auth = FirebaseAuth.instance;

  //usuario logado com o ID e info basicas
  User? firebaseUser;

  //vai obrigar os dados importantes do user
  Map<String, dynamic> userData = Map();

  bool isLoading = false;


  //voidCallback é uma função que iremos passar e chamar de dentro da nossa função signUp

  void signUp(
      Map<String, dynamic> userData, String pass, VoidCallback onSucess, VoidCallback onFail){
    isLoading = true;
    notifyListeners();

  }

  void signIn() async {
    isLoading = true;

    notifyListeners();


   await Future.delayed(Duration(seconds: 3));

   isLoading = false;
   notifyListeners();
  }

  void recoverPass(){

  }
}