import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  UserModel user; //user atual

  List<CartProduct> products = [];

  String? couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.id;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .delete();
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! - 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! + 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());
    notifyListeners();
  }

  void setCoupon(String? couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity! * c.productData!.price!.toDouble();
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void updatePrice() {
    notifyListeners();
  }

  Future<String?> finishOrder() async {
    if (products.isEmpty) return null;

    isLoading = true;
    notifyListeners();
    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    //adicionando o pedido na coleção orders e obtendo uma referêcia para este pedido para salvar ele no usuário depois
    DocumentReference refOrder =
    await FirebaseFirestore.instance.collection('orders').add({
      'clientId': user.firebaseUser!.uid,
      //trasforma uma lista de CartProducts em uma lista de mapas
      'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
      'shipProce': shipPrice,
      'productsPrice': productsPrice,
      'discount': discount,
      'totalPrice': productsPrice - discount + shipPrice,
      'status': 1 //status do pedido (1) -> preparando, (2) -> enviando, ... etc
    });

    //salvando referência do pedido no usuário
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('orders')
        .doc(refOrder.id)
        .set({'orderId': refOrder.id});

    //pegando todos os itens do carrinho
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .get();
    //pegando uma referência para cada um dos produtos do carrinho e deletando
    for(DocumentSnapshot doc in query.docs){
      doc.reference.delete();
    }

    products.clear(); //limpando lista local

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }


  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();

    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }
}
