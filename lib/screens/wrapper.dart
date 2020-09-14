import 'package:coffee_crew/models/user.dart';
import 'package:coffee_crew/screens/authenticate/authenticate.dart';
import 'package:coffee_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A Widget which shows Home or Authentication screen if the user is logged in or not
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // get the User data from the userStream using the Provider widget
    final user = Provider.of<User>(context);

    // return home or authenticate widget
    return (user == null) ? Authenticate() : Home();
  }
}
