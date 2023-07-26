import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              TextFormField(
                  decoration: InputDecoration(hintText: "Nome Completo"),
                  validator: (text) {
                    if (text!.isEmpty)
                      return "Preencher este campo";
                  }),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                  decoration: InputDecoration(hintText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text!.isEmpty || !text.contains("@"))
                      return "E-mail invalido";
                  }),
              SizedBox(height: 16,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Senha",
                ),
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text!.isEmpty || text.length < 6) return "Senha invalida";
                },
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
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
          )),
    );;
  }
}
