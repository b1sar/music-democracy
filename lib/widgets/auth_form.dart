
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    bool tryingToLogin,
    bool tryingToLoginAsAdmin,
  ) submitFn;
  final bool isLoading;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _userFormKey = GlobalKey<FormState>();
  var _tryingToLogin = true;
  var _tryingToLoginAsAdmin = false;
  var _adminCode = '';
  final _passController = TextEditingController();
  final _emailController = TextEditingController();
  final _adminCodeController = TextEditingController();
  var _userEmail = '';
  var _userPass = '';
  var _userName = '';

  void _trySubmit() async {
    var isValid = false;
    //  if (!_tryingToLogin)
    isValid = _userFormKey.currentState.validate();

    FocusScope.of(context).unfocus();

    // if (!_tryingToLoginAsAdmin) {
    //   final adminCodes =
    //       await FirebaseFirestore.instance.collection('adminCodes').get();
    //   adminCodes.docs.forEach((doc) {
    //     if (doc['code'] == _adminCodeController.text) {
    //       _isActuallyAdmin = true;
    //     }
    //   });
    // }

    // if (_isActuallyAdmin == false && _tryingToLoginAsAdmin == true) {
    //   showSnackBarError(context, "Your Admin Code is invalid!");
    //   return;
    //}

    if (isValid) {
      _userFormKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPass.trim(),
        _userName.trim(),
        _tryingToLogin,
        _tryingToLoginAsAdmin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade100, Colors.pink.shade100],
            ),
          ),
          margin: const EdgeInsets.all(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _userFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildEmailFormField(),
                      if (!_tryingToLogin)
                        buildUsernameFormField(),
                      if (_tryingToLoginAsAdmin)
                        buildAdminCodeField(),
                      buildPasswordFormField(),
                      if (!_tryingToLogin)
                        buildConfirmPasswordField(),
                      Container(
                        width: 120,
                        height: 40,
                        margin: EdgeInsets.only(top: 30, bottom: 1),
                        child: widget.isLoading
                            ? CircularProgressIndicator.adaptive()
                            : ElevatedButton(
                                onPressed: _trySubmit,
                                child: Text(_tryingToLogin ? 'LOGIN' : 'SIGN UP'),
                                style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  primary: Color.fromRGBO(59, 3, 97, 0.9),
                                  side: BorderSide(width: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: widget.isLoading
                            ? Text('Loading...')
                            : TextButton(
                                onPressed: () {
                                  setState(() {
                                    _tryingToLogin = !_tryingToLogin;
                                  });
                                  _userFormKey.currentState.reset();
                                  _passController.clear();
                                  FocusScope.of(context).unfocus();
                                },
                                style: TextButton.styleFrom(
                                  primary: Color.fromRGBO(59, 3, 97, 0.9),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  _tryingToLogin
                                      ? 'Click to sign up first'
                                      : 'I already have an account',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_tryingToLogin)
          Container(
            height: 40,
            width: 185,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _tryingToLoginAsAdmin = !_tryingToLoginAsAdmin;
                });
              },
              child: Text(_tryingToLoginAsAdmin ? 'SIGN IN AS USER' : 'SIGN IN AS ADMIN'),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                primary: Colors.white70,
                onPrimary: Colors.black87,
                side: BorderSide(width: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          )
        else
          Container(
            height: 40,
            width: 185,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _tryingToLoginAsAdmin = !_tryingToLoginAsAdmin;
                });
              },
              child: Text(_tryingToLoginAsAdmin ? 'SIGN UP AS USER' : 'SIGN UP AS ADMIN'),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                primary: Colors.white70,
                onPrimary: Colors.black87,
                side: BorderSide(width: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget buildEmailFormField() => TextFormField(
        key: ValueKey('email'),
        controller: _emailController,
        autocorrect: false,
        style: TextStyle(fontFamily: 'Lexend'),
        decoration: InputDecoration(
            labelText: 'Email', 
            labelStyle: TextStyle(fontFamily: 'Raleway')),
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          _userEmail = value;
        },
        validator: (value) {
          if (value.isEmpty ||
              !value.contains('.com') ||
              !value.contains('@')) {
            return 'Please enter a valid email address';
          }
          return null;
        }
      );

  Widget buildUsernameFormField() => TextFormField(
        autocorrect: false,
        style: TextStyle(fontFamily: 'Lexend'),
        key: ValueKey('username'),
        decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(fontFamily: 'Raleway')
        ),
        onSaved: (value) {
          _userName = value;
        },
        validator: (value) {
          if (value.length < 4 || value.isEmpty)
            return "Username should be at least 4 characters long";
          return null;
        }
      );

  Widget buildPasswordFormField() => TextFormField(
        key: ValueKey('password'),
        obscureText: true,
        autocorrect: false,
        controller: _passController,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        onSaved: (value) {
          _userPass = value;
        },
        validator: (value) {
          if (value.isEmpty || value.length <= 7) {
            return "Password should be at least 8 characters long";
          }
          return null;
        }
      );

  Widget buildAdminCodeField() => TextFormField(
        autocorrect: false,
        style: TextStyle(fontFamily: 'Lexend'),
        decoration: InputDecoration(
          labelText: 'Admin Code',
          labelStyle: TextStyle(fontFamily: 'Raleway'),
        ),
        controller: _adminCodeController,
        onSaved: (value) {
          _adminCode = value;
        },
      );

  Widget buildConfirmPasswordField() => TextFormField(
        autocorrect: false,
        key: ValueKey('confirm'),
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
        ),
        validator: (value) {
          if (value != _passController.text) {
            return "Passwords do not match";
          }
          return null;
        },
      );
  
}
