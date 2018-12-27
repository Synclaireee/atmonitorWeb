import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:atmonitor/src/route_paths.dart';
import 'package:atmonitor/src/routes.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'detail_dashboard_component.html',
  styleUrls: [
    '../util/util.css',
    '../util/bootstrap.min.css',
    '../util/animate.css'
  ],
  directives: [
    coreDirectives, routerDirectives, MaterialIconComponent, formDirectives],
  exports: [RoutePaths, Routes],
  pipes: [commonPipes],
)
class DetailDashboardComponent implements OnInit, OnActivate {
  fs.Firestore db = fb.firestore();


  String get uid =>
      fb
          .auth()
          .currentUser
          ?.uid;

  String jobId;
  String techName;
  String vTechName;
  bool getJobComplete = false;
  bool getUserComplete = false;
  Map<String, dynamic> currUser = new Map<String, dynamic>();
  Map<String, dynamic> currJob = new Map<String, dynamic>();

  @override
  void ngOnInit() {
    getCurrUser();
  }

  bool isAuthenticated() =>
      fb
          .auth()
          .currentUser != null;

  getJob() {
    db.collection("jobs").where("ticketNum", "==", jobId).get().then((
        snapshot) {
      currJob = snapshot.docs.first.data();
    }).whenComplete(() {
      getTechName();
    });
  }

  @override
  void onActivate(RouterState previous, RouterState current) {
    //ambil ID dari parameter
    jobId = current.parameters['id'];
    getJob();
  }

  //getUser
  getCurrUser() {
    db.collection("users").where("uid", "==", uid).get().then((snapshot) {
      currUser = snapshot.docs.first.data();
    }).whenComplete(() {
      getUserComplete = true;
      //get list of technician
    });
  }

  //get currJob['assignedTo'] name currJob['vAssignedTo']
  getTechName() {
    if (currJob['assignedTo'] != null) {
      db.collection("users").where("uid", "==", currJob['assignedTo'])
          .get()
          .then((snapshot) {
        techName = snapshot.docs.first.data()['name'];
      });
    }
    if (currJob['vAssignedTo'] != null) {
      db.collection("users").where("uid", "==", currJob['vAssignedTo'])
          .get()
          .then((snapshot) {
        vTechName = snapshot.docs.first.data()['name'];
      });
    }
  }
}