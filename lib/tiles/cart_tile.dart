import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';


class CartTile extends StatelessWidget {
  const CartTile({Key? key, required this.cartProduct}) : super(key: key);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    CartModel.of(context).updatePrice();//atualizando valores e itens
    Widget _buildContent() {
      return Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: 120,
            child: Image.network(cartProduct.productData!.images![0]),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  cartProduct.productData!.title!,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  "Tamanho: ${cartProduct.size}",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  "R\$ ${cartProduct.productData!.price!.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: cartProduct.quantity! > 1 ? () {
                          CartModel.of(context).decProduct(cartProduct);
                        } : null,
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        onPressed: () {
                          CartModel.of(context).incProduct(cartProduct);
                        },
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                      ),
                      TextButton(
                          onPressed: () {
                            CartModel.of(context).removeCartItem(cartProduct);
                          },
                          child: Text("Remover"),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[500])),
                    ])
              ],
            ),
          ))
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: cartProduct.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("products")
                    .doc(cartProduct.category)
                    .collection("items")
                    .doc(cartProduct.pid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot.data!);
                    return _buildContent();
                  } else {
                    return Container(
                      height: 70,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                })
            : _buildContent());
  }
}
