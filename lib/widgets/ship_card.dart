import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class ShipCard extends StatelessWidget {
  const ShipCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      //tile que pode clicar e ela irá expandir
      child: ExpansionTile(
        iconColor: Theme.of(context).primaryColor,
        leading: Icon(Icons.card_giftcard),
        title: Text(
          'Calcular Frete',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        trailing: Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                border: OutlineInputBorder(),
                hintText: 'Digite seu CEP',
              ),
              //inicia com um cupom já colocado, senão coloca vazio
              initialValue: '',
              //ao submeter o cupom, busca no firestore o doc correspondente
              onFieldSubmitted: (text) {

              },
            ),
          ),
        ],
      ),
    );
    ;
  }
}
