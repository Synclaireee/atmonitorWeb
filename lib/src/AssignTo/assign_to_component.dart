import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:atmonitor/src/route_paths.dart';
import 'package:atmonitor/src/routes.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

@Component(
  selector: 'my-app',
  templateUrl: 'assign_to_component.html',
  directives: [coreDirectives, routerDirectives],
  exports: [RoutePaths, Routes],
  pipes: [commonPipes],
)
class AssignToComponent implements OnInit{
  fs.Firestore db = fb.firestore();
  String get uid => fb.auth().currentUser?.uid;
  String get email => fb.auth().currentUser?.email;
  bool isAuthenticated() => fb.auth().currentUser != null;
  String get userEmail => fb.auth().currentUser?.email;
  String get displayName => fb.auth().currentUser?.displayName;

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
    getPhoto();
  }

  String photo;
  getPhoto() {
      db.collection("users").where("uid", "==", uid).get().then((snapshot){
      photo= snapshot.docs.first.data()['photo'].toString();
      print(photo);
    });
  }


}
