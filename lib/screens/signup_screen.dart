import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Nome Completo"),
                    validator: (text) {
                      if (text!.isEmpty) return "Preencher este campo";
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text!.isEmpty || !text.contains("@"))
                        return "E-mail invalido";
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    hintText: "Senha",
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text!.isEmpty || text.length < 6)
                      return "Senha invalida";
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: "Endereço",
                  ),
                  validator: (text) {
                    if (text!.isEmpty) return "Endereço invalido";
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> userData = {
                        "name": _nameController.text,
                        "email": _emailController.text,
                        "address": _addressController.text
                      };
                      model.signUp(
                          userData: userData,
                          pass: _passController.text,
                          onSucess: _onSucess,
                          onFail: _onFail);
                    }
                  },
                  child: Text(
                    "Criar Conta",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSucess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(

        content: Text(('Usuario criado com sucesso!'),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 21),
      ));
      Future.delayed(const Duration(seconds: 2)).then((_) =>
        Navigator.of(context).pop()
      );
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(

          content: Text(('Falha ao criar usuario!'),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ));
  }
}
