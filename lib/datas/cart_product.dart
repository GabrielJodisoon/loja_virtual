import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct{

  String? cid;

  String? category;
  String? pid;

  int? quantity;
  String? size;

  ProductData? productData;

  //contrutor vazio
  CartProduct();
  //Contrutor
  //Esse doc sera todos os produtos que estao no carrinho
  //vai receber e treanformar cada produtor em um CartProduct
  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.id;
    category = document.get('category');
    pid = document.get('pid');
    quantity = document.get('quantity');
    size = document.get('size');
  }

  //adicionando no banco
  Map<String, dynamic> toMap(){
    return{
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      'product': productData!.toResumeMap() //guarda o resumo dos pedidos
    };
  }

}