import 'package:ara/redux/authentication/auth_actions.dart';
import 'package:ara/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:ara/validators/auth_validators.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-In Page'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(40),
              child: _SignInForm(),
            )
          ],
        ),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signInCallback = () {
      if (_formKey.currentState.validate()) {
        // Hide keyboard when validating
        FocusScope.of(context).requestFocus(FocusNode());

        final SignInAction signInAction = SignInAction(
            email: _emailController.text, password: _passwordController.text);

        StoreProvider.of<AppState>(context).dispatch(signInAction);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Signing you in..."),
          behavior: SnackBarBehavior.floating,
        ));

        signInAction.completer.future.catchError((error) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Could not sign in with those credentials"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ));
        });
      }
    };

    final signInButton = RaisedButton(
      child: Text('Sign-in',
          style: TextStyle(color: Theme.of(context).backgroundColor)),
      color: Theme.of(context).primaryColor,
      onPressed: signInCallback,
    );

    final email = TextFormField(
      autofocus: true,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        hintText: 'Enter your e-mail address',
      ),
      validator: AuthValidators.validateEmail,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
    );

    final pass = TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
          labelText: 'Password', hintText: 'Enter your password'),
      validator: AuthValidators.validatePassword,
      controller: _passwordController,
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [email, pass, signInButton],
      ),
    );
  }
}
