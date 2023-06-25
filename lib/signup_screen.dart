import 'package:flutter/material.dart';
import 'package:safe_neighborhood/home_screen.dart';
import 'package:safe_neighborhood/login_screen.dart';
import 'package:safe_neighborhood/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:safe_neighborhood/main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
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
          body: ScopedModelDescendant<UserModel> (
            builder: (context, child, model) {
              if (model.isLoading) {
                return const Center(child: CircularProgressIndicator(),);
              }

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
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
                      controller: _emailController,
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
                      controller: _passwordController,
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
                    TextFormField(
                      controller: _addressController,
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
                          if (_formKey.currentState?.validate() == true) {

                            Map<String, dynamic> userData = {
                              "name": _nameController.text,
                              "email": _emailController.text,
                              "address": _addressController.text
                            };

                            model.signUp(
                                userData: userData,
                                password: _passwordController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          )
      ),
    );
  }

  void _onSuccess() async {
    _scaffoldKey.currentState?.showSnackBar(
      const SnackBar(content: Text("Usuário criado com sucesso!"),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 2),)
    );
    await Future.delayed(const Duration(seconds: 2));
    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _onFail() {
    _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(content: Text("Não foi possível criar usuário!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),)
    );
  }
}

