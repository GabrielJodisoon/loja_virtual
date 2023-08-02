import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/order_tile.dart';

class OrderTabs extends StatelessWidget {
  const OrderTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(UserModel.of(context).isLoggedIn()){
      String? uid = UserModel.of(context).firebaseUser!.uid;

      return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("users").doc!(uid).collection("orders").get(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return ListView(
                children: snapshot.data!.docs.map((doc) => OrderTile(orderId: doc.id)).toList().reversed.toList(),
              );
            }
          }
      );

    }else{
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_list,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 16,
            ),
            Text('Faca o login para acompanhar!',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              child: const Text(
                'Entrar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
