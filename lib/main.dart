import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/cart_model.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(// quando mudar o user, alterar o carrinho
        builder: (context, child, model) {
          return ScopedModel<CartModel>( //acessar carrinho
            model: CartModel(model), //enviar user atual
            child: MaterialApp(
              home: HomeScreen(),
              debugShowCheckedModeBanner: false,
              title: "Jod's Clothing",
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 0, 166, 255),
                useMaterial3: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
