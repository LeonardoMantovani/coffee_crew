import 'package:coffee_crew/models/coffee.dart';
import 'package:coffee_crew/screens/home/coffee_list.dart';
import 'package:coffee_crew/screens/home/settings_form.dart';
import 'package:coffee_crew/services/auth.dart';
import 'package:coffee_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The Home Screen
class Home extends StatelessWidget {

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    
    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          color: Colors.brown[100],
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }
    
    return StreamProvider<List<Coffee>>.value(
      value: DatabaseService().coffeeStream,
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          title: Text('Cofee Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.exit_to_app, color: Colors.white,),
              label: Text('Sign Out', style: TextStyle(color: Colors.white),),
              onPressed: () async {
                _authService.signOut();
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.settings, color: Colors.brown[50],),
              label: Text('Settings', style: TextStyle(color: Colors.brown[50]),),
              onPressed: () => _showSettingsPanel(),
            ),
          ],
        ),
        body: CoffeeList(),
      ),
    );
  }
}