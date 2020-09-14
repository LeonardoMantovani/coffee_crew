import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_crew/models/coffee.dart';

/// Manage all database processes of the app using Cloud Firestore
class DatabaseService {

  DatabaseService({ this.uid });

  final String uid;

  // get (or create if it doesn't exist) the collection named 'coffees'
  final CollectionReference coffeeCollection = Firestore.instance.collection('coffees');

  // create a Coffee models list from a QuerySnapshot
  List<Coffee> _coffeeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Coffee(
          name: doc.data['name'] ?? '',
          sugars: doc.data['sugars'] ?? '0',
          strength: doc.data['strength'] ?? 0,
      );
    }).toList();
  }

  // get coffees stream
  Stream<List<Coffee>> get coffeeStream {
    // the snapshots function returns to the stream an "instance of the database" every time it changes
    return coffeeCollection.snapshots().map(_coffeeListFromSnapshot);
  }

  Future updateUserData(String sugars, String name, int strength) async {
    return await coffeeCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

}