import 'package:coffee_crew/services/auth.dart';
import 'package:coffee_crew/shared/custom_input_decoration.dart';
import 'package:coffee_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {

  final Function toggleView;

  SignUp( this.toggleView );

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String repeatPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    // show the loading widget if the loading flag is set to true, otherwise show the scaffold
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0,
        title: Text('Sign Up to Coffee Crew', style: TextStyle(color: Colors.brown[50]),),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, color: Colors.brown[50],),
            label: Text('Sign In', style: TextStyle(color: Colors.brown[50]),),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),

                //region EMAIL FIELD
                TextFormField(
                  decoration: customInputDecoration('email'),
                  validator: (value) => value.isEmpty ? 'Please, enter an email address' : null,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                //endregion

                //region PASSWORD FIELD
                TextFormField(
                  decoration: customInputDecoration('password'),
                  validator: (value) => (value.length < 6) ? 'Please, enter a password with 6+ characters' : null,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                //endregion

                //region REPEAT PASSWORD FIELD
                TextFormField(
                  decoration: customInputDecoration('repeat password'),
                  validator: (value) => (value != password) ? "Passwords don't match" : null,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      repeatPassword = value;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                //endregion

                //region SIGN UP BUTTON
                RaisedButton(
                  color: Colors.brown[900],
                  child: Text('Sign Up', style: TextStyle(color: Colors.brown[50]),),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // set the loading flag to true (to show the loading widget)
                      setState(() => loading = true);
                      dynamic result = await _authService.signUpEmailPassword(email, password);
                      if (result == null){
                        setState(() {
                          loading = false;
                          error = 'Please use a valid email address';
                        });
                      }
                      // if the result is not null the wrapper widget will automatically show the home widget
                    }
                  },
                ),
                SizedBox(height: 12.0,),
                Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0),)
                //endregion
              ],
            )
        ),
      ),
    );
  }
}
