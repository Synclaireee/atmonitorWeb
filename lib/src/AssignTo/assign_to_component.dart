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
  styleUrls: [
    '../util/util.css',
    '../util/bootstrap.min.css',
  ],
  directives: [coreDirectives, routerDirectives],
  exports: [RoutePaths, Routes],
  pipes: [commonPipes],
)
class AssignToComponent implements OnInit,OnActivate{
  fs.Firestore db = fb.firestore();
  bool isAuthenticated() => fb.auth().currentUser != null;
  String get uid => fb.auth().currentUser?.uid;
  String get email => fb.auth().currentUser?.email;
  String get userEmail => fb.auth().currentUser?.email;
  String get displayName => fb.auth().currentUser?.displayName;
  String jobId;
  bool getJobComplete = false;
  bool getUserComplete = false;
  Map<String,dynamic> currUser;
  Map<String,dynamic> currJob;
  List<Map<String,dynamic>> listTechnician;
  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
    getCurrUser();
  }

  getJob() {
      db.collection("jobs").where("ticketNum", "==", jobId).get().then((snapshot){
      currJob = snapshot.docs.first.data();
    });
  }

  //TODO if(currUser.pktvendorid == pktvendorid && substring.role == teknisi)
  getListTechnician(){

  }

  @override
  void onActivate(RouterState previous, RouterState current) {
    // TODO: implement onActivate
    jobId = current.parameters['id'];
    getJob();
  }

  //getUser
  getCurrUser() {
    db.collection("users").where("uid","==",uid).get().then((snapshot){
      currUser = snapshot.docs.first.data();
    });
  }
}