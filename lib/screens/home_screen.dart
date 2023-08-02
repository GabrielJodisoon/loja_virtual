import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/order_tabs.dart';
import 'package:loja_virtual/tabs/place_tab.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Produtos'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          floatingActionButton: CartButton(),
          body: ProductsTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          body: PlaceTab(),
          drawer: CustomDrawer(pageController: _pageController,),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrderTabs(),
          drawer: CustomDrawer(pageController: _pageController,),
        )
      ],
    );
  }
}
