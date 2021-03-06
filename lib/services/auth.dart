import 'package:coffee_crew/models/user.dart';
import 'package:coffee_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Manage all authentication processes of the app using FirebaseAuth
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create a user object based on a Firebase user
  User _userFromFirebaseUser(FirebaseUser user){
    return (user != null) ? User(user.uid) : null;
  }

  /// User stream for auth-changes
  Stream<User> get userStream {
    // (the map function creates a Stream of Users with every FirebaseUser of
    // the _auth.onAuthStateChanged stream)
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // ANONYMOUS SIGN IN
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // EMAIL/PASSWORD SIGN IN
  Future signInEmailPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // EMAIL/PASSWORD SIGN UP
  Future signUpEmailPassword(String email, String password) async {
    try {
      // sign up the new user
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = _userFromFirebaseUser(result.user);

      //  create a new document in the database for the user using his uid
      await DatabaseService(uid: user.uid).updateUserData(
          sugars: '0',
          name: 'New Crew Member',
          strength: 100,
      );

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // SIGN OUT
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }

}