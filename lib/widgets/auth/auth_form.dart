import '../user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext,
  ) submitFn;

  final bool isLoading;
  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  final _passwordController = TextEditingController();

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    // To close the soft keyboard :-
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      // once the inputs are saved,we can pass those values to send http requests.
      print(_userEmail);
      print(_userName);
      print(_userPassword);
      // trim() trims of the excess white spaces in the beginning and the end
      widget.submitFn(_userEmail.trim(), _userPassword, _userName.trim(),
          _isLogin, context);
    }
  }

  void _switchMode() {
    if (_isLogin == false) {}
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(),
                  TextFormField(
                    key: ValueKey('Email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('Username'),
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Password enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('Password'),
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    // onEditingComplete: () {
                    //   _userPassword = value;
                    // },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('Confirm Password'),
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords don\'t match';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                  SizedBox(height: 12),
                  Container(
                    height: 100,
                    child: widget.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                child: Text(_isLogin ? 'Login' : 'Sign Up'),
                                onPressed: _trySubmit,
                              ),
                              // widget.isLoading
                              //     ? CircularProgressIndicator()
                              //     :
                              FlatButton(
                                child: Text(_isLogin
                                    ? 'Create Account'
                                    : 'I already have an acccount'),
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                textColor: Theme.of(context).accentColor,
                              )
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
