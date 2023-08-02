import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';

import '../models/cart_model.dart';
import '../models/user_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, this.product}) : super(key: key);

  final ProductData? product;

  @override
  State<ProductScreen> createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  _ProductScreenState(ProductData? product);

  String? size;
  int current = 0;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product!.title!),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: CarouselSlider(
              items: widget.product!.images!.map((img) {
                return Image.network(
                  img,
                  fit: BoxFit.cover,
                );
              }).toList(),
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 1,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    setState(() {
                      current = index; // mostra a posicao atual img
                    });
                  }),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.product!.title!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${widget.product!.price!.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5,
                    ),
                    children: widget.product!.sizes!.map((n) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = n;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: n == size ? primaryColor : Colors.grey,
                                width: 2),
                            borderRadius: BorderRadius.all(
                              (Radius.circular(4)),
                            ),
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(n),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: size != null
                        ? () {
                            if (UserModel.of(context).isLoggedIn()) {
                              CartProduct cartProduct =
                                  CartProduct(); //construtor vazio
                              cartProduct.size = size;
                              cartProduct.quantity = 1;
                              cartProduct.pid = widget.product!.id;
                              cartProduct.category = widget.product!.category;
                              cartProduct.productData = widget.product!;

                              CartModel.of(context).addCartItem(cartProduct);
                              //adiocionar ao carrinho

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          }
                        : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao carrinho"
                          : "Entre para comprar",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                // Text('Descricao', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, ),),
                // Text(widget.data!.description!, style: TextStyle(fontSize: 14),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
