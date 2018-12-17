import 'dart:async';
import 'dart:html' as h;
import 'dart:js';

import 'package:angular_forms/angular_forms.dart';
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
  selector: 'aocDashboardPKT',
  styleUrls: [
    '../util/util.css',
    '../util/bootstrap.min.css',
    '../util/animate.css'
  ],
  templateUrl: 'aoc_dashboard_vendor_component.html',
  directives: [
    coreDirectives,
    FirebaseAuthUIComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    routerDirectives,
    formDirectives,
  ],
  pipes: [commonPipes],
  exports: [RoutePaths, Routes],
)
class AOCDashboardVendorComponent implements OnInit, OnDestroy {
  Router _route;
  List<DocumentSnapshot> jobList;
  Firestore db = fb.firestore();
  Timer _auto;

  List<DocumentSnapshot> vendorList;
  AOCDashboardVendorComponent(this._route);

  String selectedVendor = '';

  @override
  void ngOnInit() {
    getJobs();
    getVendors();
    autoReload();
  }

  bool isAuthenticated() => fb.auth().currentUser != null;

  String get uid => fb.auth().currentUser?.uid;


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

  //force Reload
  reload() {
    _route.navigate(RoutePaths.AOCDashboardVendor.toUrl(),
        NavigationParams(reload: true));
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


  //allVendors
  getVendors(){
    db.collection("pktVendors").where("pktVendor", "==", "Vendor").get().then((snapshot){
      vendorList = snapshot.docs;
    });
  }
}
