import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tiles.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key, required this.pageController,}) : super(key: key);

  //controlar as paginas pelo drawer
  final PageController pageController;


  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 255, 255, 255),
            Colors.white,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        );

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 20),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 200,
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 0,
                      child: Text(
                        "Jod's\nClothing",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem Vindo!',
                            style: TextStyle(
                              color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          GestureDetector(
                            child: Text(
                              'Entre ou cadastre-se',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=> LoginScreen())
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(icon: Icons.home, text: 'Inicio', page: 0, controller: pageController,),
              DrawerTile(icon: Icons.list, text: 'Produtos', page: 1, controller: pageController),
              DrawerTile(icon: Icons.location_on, text: 'Lojas', page: 2, controller: pageController),
              DrawerTile(icon: Icons.shopping_bag, text: 'Meus Pedidos', page: 3, controller: pageController),


            ],
          ),

        ],
      ),
    );
  }
}
