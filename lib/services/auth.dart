import 'package:coffee_crew/models/user.dart';
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

  //region ANONYMOUS SIGN IN

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

  //endregion

  //region EMAIL/PASSWORD SIGN IN

  //endregion

  //region EMAIL/PASSWORD REGISTRATION

  //endregion

  //region SIGN OUT

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }

  //endregion

}