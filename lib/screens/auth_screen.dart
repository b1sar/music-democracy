import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:music_democracy/models/sharedPrefs.dart';
import 'package:music_democracy/services/authentication_service.dart';
import 'package:music_democracy/util/utility.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static var isFinalAdmin;
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool tryingToLogin,
    bool tryingAsAdmin, //trying to login or signup as admin or not
  ) async {
    UserCredential authResult;
    //   print(tryingToLogin);
    try {
      setState( (){ _isLoading = true; } );
      if (tryingToLogin) { //tries to login
        login(email, password);
      } else { //tries to signup
        signup(email, password, username, tryingAsAdmin);
      }
      if (mounted)
        setState(() {
          _isLoading = false;
        }
      );
    } on PlatformException catch (error) {
      var message = 'An error ocurred, please check your credentials!';
      if (error.message != null) {
        message = error.message;
      }
      print('Error');
      print(message);
      showSnackBarError(context, message);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      var message = 'An error ocurred, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      print('Error');
      if (this.mounted)
        showSnackBarError(context, message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.deepPurple,
            Colors.blueGrey,
            Colors.pink.shade300,
          ],
        ),
      ),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'WELCOME',
                      style: TextStyle(
                        color: Colors.pink.shade100,
                        fontSize: 35,
                        fontFamily: 'Doctor',
                      ),
                    ),
                    AuthForm(_submitAuthForm, _isLoading),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(String email, String password) async {
    // UserCredential authResult = await _auth.signInWithEmailAndPassword(
    //       email: email,
    //       password: password,
    //     );
    Provider.of<AuthenticationService>(context, listen: false).signIn(email: email, password: password);
    User currentUser = Provider.of<AuthenticationService>(context, listen: false).currentUser();
        
    SharedPrefs().setUserId(currentUser.uid);
    var tempUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    SharedPrefs().toggleAdminStatus(tempUser['is_admin']);
    print("Is admin ----->> ${tempUser['is_admin']}");
  }

  void signup(String email, String password, String username, bool tryingAsAdmin) async {
    // UserCredential authResult = await _auth.createUserWithEmailAndPassword(
    //       email: email,
    //       password: password,
    //     );
    Provider.of<AuthenticationService>(context, listen: false).signUp(email: email, password: password, isAdmin: tryingAsAdmin);
    User currentUser = Provider.of<AuthenticationService>(context, listen: false).currentUser();
    
    SharedPrefs().toggleAdminStatus(tryingAsAdmin);
    SharedPrefs().setUserId(currentUser.uid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .set(
      {
        'username': username,
        'email': email,
        'is_admin': tryingAsAdmin ? true : false,
        'lobbyCodes': {}
      },
    );
  }
}
