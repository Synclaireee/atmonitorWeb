import 'dart:async';

import 'package:angular_router/angular_router.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:firebase_dart_ui/firebase_dart_ui.dart';

import '../routes.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'finishedDashboard',
  styleUrls: [
    '../util/util.css',
    '../util/bootstrap.min.css',
    '../util/animate.css'
  ],
  templateUrl: 'finished_dashboard_component.html',
  directives: [
    coreDirectives,
    FirebaseAuthUIComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    routerDirectives
  ],
  pipes: [commonPipes],
  exports: [RoutePaths, Routes],
)
class FinishedDashboardComponent implements OnInit, OnDestroy {
  Router _route;
  List<DocumentSnapshot> jobList;
  Firestore db = fb.firestore();
  bool admin;
  bool futureComplete = false;
  Timer _auto;

  FinishedDashboardComponent(this._route);

  @override
  void ngOnInit() {
    getCurrUser();
    autoReload();
  }

  bool isAuthenticated() => fb.auth().currentUser != null;

  String get uid => fb.auth().currentUser?.uid;

  Map<String, dynamic> currUser;

  //Convert uid to Name
  getNameFromUid(String id) {
    db.collection("users").where("uid","==",id).get().then((snapshot){
      print('test');
      return snapshot.docs.first.data()['name'];
    });
  }

  //get all Job List
  getJobs() {
    if(currUser['pktVendor'] == "PKT") {
      CollectionReference ref = db.collection("jobs");
      ref
          .orderBy("status", "desc")
          .orderBy("startDatetime", "asc")
          .get()
          .then((snapshot) {
        jobList = snapshot.docs;
      });
    } else{
      CollectionReference ref = db.collection("jobs");
      ref
          .orderBy("vStatus", "desc")
          .orderBy("confirmHelpTime", "asc")
          .get()
          .then((snapshot) {
        jobList = snapshot.docs;
      });
    }
  }

  //is currUser admin?
  isAdmin() {
    String role = currUser['role'];
    String temp = role.substring(0, role.indexOf(" "));
    if (temp == "Admin") {
      print(role);
      admin = true;
    } else {
      admin = false;
    }
  }

  //getUser and Admin
  getCurrUser() {
    db.collection("users").where("uid", "==", uid).get().then((snapshot) {
      currUser = snapshot.docs.first.data();
    }).whenComplete(() {
      isAdmin();
      futureComplete = true;
    }).then((_){
      getJobs();
    });
  }

  //force Reload
  reload() {
    _route.navigate(RoutePaths.finishedDashboard.toUrl(),
        NavigationParams(reload: true, replace: true));
  }

  autoReload() {
    _auto = Timer(Duration(seconds: 30), reload);
  }

  @override
  void ngOnDestroy() {
    // cancel Future
    if (_auto != null) {
      _auto.cancel();
      _auto = null;
    }
  }


  //detail
  String detailUrl(String para) {
    return RoutePaths.detailDashboard.toUrl(parameters: {jobId: '$para'});
  }
}
