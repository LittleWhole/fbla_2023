import 'package:fbla_2023/services/auth.dart';
import 'package:fbla_2023/shared/constants.dart';
import 'package:fbla_2023/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  const Register({this.toggleView, super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0.0,
              title: const Text('Register for FBLA'),
              actions: <Widget>[
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  icon: const Icon(Icons.person),
                  label: const Text('Sign In'),
                  onPressed: () => widget.toggleView!(),
                ),
              ],
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? 'Enter an email' : null,
                        onChanged: (value) => {
                          setState(() {
                            email = value;
                          })
                        },
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        validator: (value) => value!.length < 6
                            ? 'Your password must be 6 or more characters'
                            : null,
                        onChanged: (value) => {
                          setState(() {
                            password = value;
                          })
                        },
                        obscuringCharacter: '*',
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                        ),
                        child: const Text('Register'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .registerWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please supply a valid email';
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                )),
          );
  }
}
