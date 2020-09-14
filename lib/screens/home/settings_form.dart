import 'package:coffee_crew/models/user.dart';
import 'package:coffee_crew/services/database.dart';
import 'package:coffee_crew/shared/custom_input_decoration.dart';
import 'package:coffee_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          UserData userData = snapshot.data;

          // return an appropriate color graduation based on the current strength
          // (or the one in the database if the current is null)
          int _getSliderColor(){
            if (_currentStrength != null && _currentStrength > 100){
              return _currentStrength;
            } else if (userData.strength > 100){
              return userData.strength;
            } else {
              return 200;
            }
          }

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                //region TITLE
                Text(
                  'Update Your Coffee Settings',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[900],
                  ),
                ),
                SizedBox(height: 20.0,),
                //endregion

                //region NAME FIELD
                TextFormField(
                  initialValue: userData.name,
                  decoration: customInputDecoration(''),
                  validator: (value) => value.isEmpty ? 'Please enter a name' : null,
                  onChanged: (value) {
                    setState(() => _currentName = value);
                  },
                ),
                SizedBox(height: 20.0,),
                //endregion

                //region SUGAR DROPDOWN FIELD
                DropdownButtonFormField(
                  decoration: customInputDecoration(''),
                  value: _currentSugars ?? userData.sugars,
                  validator: (value) => (value == null) ? 'Select a value' : null,
                  items: sugars.map((sugar) => DropdownMenuItem(
                    value: sugar,
                    child: Text('$sugar sugars'),
                  )).toList(),
                  onChanged: (value) {
                    setState(() => _currentSugars = value);
                  },
                ),
                SizedBox(height: 20.0,),
                //endregion

                //region STRENGTH SLIDER FIELD

                Slider(
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (value) {
                    setState(() => _currentStrength = value.toInt());
                  },
                  value: (_currentStrength ?? userData.strength).toDouble(),
                  activeColor: Colors.brown[_getSliderColor()],
                  inactiveColor: Colors.brown[200],
                ),

                //endregion

                //region SAVE BUTTON
                RaisedButton(
                    color: Colors.brown[900],
                    child: Text('Save', style: TextStyle(color: Colors.brown[50], fontSize: 18.0),),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                          name: _currentName ?? userData.name,
                          sugars: _currentSugars ?? userData.sugars,
                          strength: _currentStrength ?? userData.strength,
                        );
                        Navigator.pop(context);
                      }
                    }
                ),
                //endregion
              ],
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}
