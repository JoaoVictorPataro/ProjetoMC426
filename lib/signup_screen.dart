import 'package:flutter/material.dart';
import 'package:safe_neighborhood/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          "Criar conta",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              "Logar",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen())
              );
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Nome Completo",
              ),
              validator: (text) {
                if (text == "") return "Nome inválido";
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "E-mail",
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (text) {
                if (text == "" || text?.contains("@") == false) {
                  return "E-mail inválido";
                }
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Endereço",
              ),
              validator: (text) {
                if (text == "") return "Endereço inválido";
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Senha",
              ),
              obscureText: true,
              validator: (text) {
                if (text == "") return "Senha inválida";
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 44.0,
              child: ElevatedButton(
                child: const Text(
                  "Criar conta",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {}
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
