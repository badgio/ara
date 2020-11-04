import 'package:ara/views/menu.dart';
import 'package:flutter/material.dart';
import 'package:ara/services/authentication.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();
  Authentication auth = new Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign-In Page'),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Enter your e-mail address',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    controller: pass,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password', hintText: 'Enter your password'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                OutlinedButton(
                    child: Text('Sign-in'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        auth.signIn(email.text, pass.text).then((result) {
                          if (result != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Menu()));
                          } else {
                            print("Invalid email or password");
                          }
                        });
                      } else {
                        print("Inválido");
                      }
                    }),
                OutlinedButton(
                    child: Text('Create new account'),
                    onPressed: () {
                      print('Go to sign up');
                    }),
              ],
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            )));
  }
}
