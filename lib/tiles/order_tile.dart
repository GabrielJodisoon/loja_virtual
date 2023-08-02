import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({Key? key, required this.orderId}) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .doc(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              int status = snapshot.data!["status"];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Codigo do pedido: ${snapshot.data!.id}",
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 6,),
                  Text(_buildProductsText(snapshot.data!)),
                  SizedBox(height: 4,),
                  Text("Status do pedido:",
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircles("1", "Preparacao", status, 1),
                      _line(),
                      _buildCircles("2", "Transporte", status, 2),
                      _line(),
                      _buildCircles("3", "Entrega", status, 3),

                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot){
    String text = "Descricao: \n";
    for(LinkedHashMap p in snapshot.get("products")){
      text += "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.get("totalPrice").toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCircles(String title, String subtitle, int status, int thisStatus){
    Color backColor;
    Widget child;

    if(status < thisStatus){
      backColor = Colors.grey[500]!;
      child = Text(title, style: TextStyle(color:Colors.white),);
    }else if(status == thisStatus){
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else{
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white,);
    }
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle),
      ],
    );

  }


  Widget _line(){
    return Container(margin: EdgeInsets.only(bottom: 15),
      height: 1,
      width: 40,
      color: Colors.grey[500],
    );
  }
}

