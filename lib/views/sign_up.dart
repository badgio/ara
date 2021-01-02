import 'package:ara/countries.dart';
import 'package:ara/redux/authentication/auth_actions.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/views/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ara/validators/auth_validators.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Sign Up",
      ),
      body: Column(
        children: [
          Expanded(
            child: _SignUpForm(),
          )
        ],
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  String _gender;
  DateTime _birthDate;
  String _country;

  @override
  void initState() {
    super.initState();
    _gender = null;
    _birthDate = null;
    _country = null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 20,
          bottom: 20,
        ),
        children: [
          _buildEmail(),
          _buildPassword(),
          _buildName(),
          _buildBirthDate(),
          _buildCountry(),
          _buildCity(),
          _buildGender(),
          _buildSignup(context),
        ],
      ),
    );
  }

  // Used to apply consistent padding across all form fields
  Widget _buildPaddedField(Widget child) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 20,
      ),
      child: child,
    );
  }

  Widget _buildEmail() {
    return _buildPaddedField(
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'E-mail',
          hintText: 'e.g. fernando@badgio.pt',
          helperText: 'Required',
          helperStyle: TextStyle(fontWeight: FontWeight.bold),
          icon: Icon(Icons.email),
          border: const OutlineInputBorder(),
        ),
        validator: AuthValidators.validateEmail,
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
      ),
    );
  }

  Widget _buildPassword() {
    return _buildPaddedField(
      TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password',
          hintText: 'Enter a strong password',
          helperText: 'Required',
          helperStyle: TextStyle(fontWeight: FontWeight.bold),
          icon: Icon(Icons.lock),
          border: const OutlineInputBorder(),
        ),
        validator: AuthValidators.validatePassword,
        controller: _passwordController,
      ),
    );
  }

  Widget _buildName() {
    return _buildPaddedField(
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Full name',
          hintText: 'e.g. Fernando Fernandes',
          helperText: 'Optional',
          icon: Icon(Icons.person),
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.name,
        controller: _nameController,
      ),
    );
  }

  Widget _buildBirthDate() {
    return _buildPaddedField(
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Birth date',
          helperText: 'Optional',
          icon: Icon(Icons.cake),
          border: const OutlineInputBorder(),
        ),
        readOnly: true,
        enableInteractiveSelection: false,
        onTap: () {
          FocusScope.of(context).unfocus();
          _selectBirthDate(context);
        },
        controller: _birthDateController,
      ),
    );
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1910, 1),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _birthDate = date;
        _birthDateController.text =
            _birthDate.toIso8601String().split('T').first;
      });
    }
  }

  Widget _buildCountry() {
    return _buildPaddedField(
      DropdownButtonFormField(
        items: Countries.countriesList.map((String c) {
          return DropdownMenuItem(
            value: c,
            child: Text(c),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _country = newValue;
          });
        },
        value: _country,
        decoration: InputDecoration(
          labelText: 'Country',
          helperText: 'Optional',
          border: const OutlineInputBorder(),
          icon: Icon(Icons.location_on),
        ),
      ),
    );
  }

  Widget _buildCity() {
    return _buildPaddedField(
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'City',
          hintText: 'e.g. Braga',
          helperText: 'Optional',
          icon: Icon(Icons.location_city),
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.name,
        controller: _cityController,
      ),
    );
  }

  Widget _buildGender() {
    List<String> genders = [
      "Male",
      "Female",
      "Other",
    ];
    return _buildPaddedField(
      DropdownButtonFormField(
        items: genders.map((String c) {
          return DropdownMenuItem(
            value: c,
            child: Text(c),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _gender = newValue;
          });
        },
        value: _gender,
        decoration: InputDecoration(
          labelText: 'Gender',
          helperText: 'Optional',
          border: const OutlineInputBorder(),
          icon: Icon(Icons.wc),
        ),
      ),
    );
  }

  Widget _buildSignup(BuildContext context) {
    final signUpCallback = () {
      if (_formKey.currentState.validate()) {
        // Hide keyboard when validating
        FocusScope.of(context).unfocus();

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Creating your account..."),
          behavior: SnackBarBehavior.floating,
        ));
        String email = _emailController.text;
        String password = _passwordController.text;
        String name = _nameController.text;
        String city = _cityController.text;
        String birthDate = _birthDate == null
            ? null
            : _birthDate.toIso8601String().split('T').first;
        print("Email $email");
        print("Password $password");
        print("Full name $name");
        print("Birth date $birthDate");
        print("Country $_country");
        print("City $city");
        print("Gender $_gender");

        SignUpAction signUpAction = SignUpAction(
          email: email,
          password: password,
          name: name,
          birthDate: birthDate,
          country: _country,
          city: city,
          gender: _gender,
        );

        StoreProvider.of<AppState>(context).dispatch(signUpAction);

        signUpAction.completer.future.catchError((error) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(error),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ));
        });
      }
    };

    return RaisedButton(
      child: Text(
        'Create new account',
        style: TextStyle(color: Theme.of(context).backgroundColor),
      ),
      color: Theme.of(context).primaryColor,
      onPressed: signUpCallback,
    );
  }
}
