import 'dart:async';
import 'dart:js';

import 'package:angular_router/angular_router.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:firebase_dart_ui/firebase_dart_ui.dart';

import '../routes.dart';


@Component(
  selector: 'needHelp',
  styleUrls: [
    '../util/util.css',
    '../util/bootstrap.min.css',
    '../util/animate.css'
  ],
  templateUrl: 'need_help_component.html',
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
class NeedHelpComponent implements OnInit, OnDestroy {
  Router _route;
  List<DocumentSnapshot> jobList;
  Firestore db = fb.firestore();
  bool admin;
  bool futureComplete = false;
  Timer _auto;

  NeedHelpComponent(this._route);

  @override
  void ngOnInit() {
    getCurrUser();
    autoReload();
  }

  bool isAuthenticated() => fb.auth().currentUser != null;

  String get uid => fb.auth().currentUser?.uid;

  Map<String, dynamic> currUser;


  //get all Job List
  getJobs() {
    CollectionReference ref = db.collection("jobs");
    ref
        .orderBy("status", "desc")
        .orderBy("startDatetime", "asc")
        .get()
        .then((snapshot) {
      jobList = snapshot.docs;
    });
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
    }).then((_) {
      getJobs();
    });
  }

  //generateJobUrl
  String jobUrl(String para) {
    return RoutePaths.assignTo.toUrl(parameters: {jobId: '$para'});
  }

  //force Reload
  reload() {
    _route.navigate(RoutePaths.needHelp.toUrl(),
        NavigationParams(reload: true, replace: true));
  }

  autoReload() {
    _auto = Timer(Duration(seconds: 30), reload);
  }

  @override
  void ngOnDestroy() {
    // cancel Future
    // TODO ganti try
    if (_auto != null) {
      _auto.cancel();
      _auto = null;
    }
  }
}
