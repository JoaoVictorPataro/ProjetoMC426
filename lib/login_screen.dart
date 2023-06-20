import 'package:flutter/material.dart';
import 'package:safe_neighborhood/map.dart';
import 'package:safe_neighborhood/models/user_model.dart';
import 'package:safe_neighborhood/register_event_screen.dart';
import 'package:safe_neighborhood/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:safe_neighborhood/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              'Entrar',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Criar conta',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const SignUpScreen()));
                },
              )
            ],
          ),
          body: ScopedModelDescendant<UserModel> (
            builder: (context, child, model) {
              if (model.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          if (_emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Digite um email para recuperar"),
                                  backgroundColor: Colors.amber,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          }
                          else {
                            model.recoverPassword(_emailController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Pronto! Verifique seu email para instruções"),
                                  backgroundColor: Colors.blueAccent,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          }
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
                          "Esqueci minha senha",
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 44.0,
                      child: ElevatedButton(
                        child: const Text(
                          "Entrar",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            model.signIn(
                                email: _emailController.text,
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

  void _onSuccess() {
    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (_) => const RegisterEventScreen()));
  }

  void _onFail() {
    _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(content: Text("Email e/ou senha incorretos!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),)
    );
  }
}

