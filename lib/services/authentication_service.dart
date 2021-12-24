import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_democracy/models/sharedPrefs.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AuthenticationService();

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await SharedPrefs().setUserId(user.user.uid);
      return "Signed In";
    } on FirebaseAuthException catch(err) {
      return err.message;
    }
  }

  Future<String> signUp({String email, String password, bool isAdmin}) async {
    try {
      await _firebaseFirestore.collection("users").doc(email).set(
        {
          "email": email,
          "isAdmin": isAdmin
        }
      );
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      SharedPrefs().setUserId(user.user.uid);
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User currentUser() {
    return  _firebaseAuth.currentUser;
  }
}