import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BackEndConfig {


  static CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  static CollectionReference adminsCollection = FirebaseFirestore.instance.collection('admins');
  static CollectionReference gamesCollection = FirebaseFirestore.instance.collection('games');
  static CollectionReference eventsCollection = FirebaseFirestore.instance.collection('events');
  static CollectionReference applyGamesCollection = FirebaseFirestore.instance.collection('applyGames');
  static CollectionReference superAdminCollection = FirebaseFirestore.instance.collection('superAdmin');
  static CollectionReference bannerCollection = FirebaseFirestore.instance.collection('banners');
  static CollectionReference departmentCollection = FirebaseFirestore.instance.collection('departments');


}
