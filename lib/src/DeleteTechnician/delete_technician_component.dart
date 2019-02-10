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
  templateUrl: 'delete_technician_component.html',
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
class DeleteTechnicianComponent implements OnInit {
  String qSearch;
  fs.Firestore db = fb.firestore();


  String get uid =>
      fb
          .auth()
          .currentUser
          ?.uid;

  bool getUserComplete = false;
  Map<String, dynamic> currUser = new Map<String, dynamic>();
  List<Map<String, dynamic>> listTechnician = new List<Map<String, dynamic>>();

  @override
  void ngOnInit() {
    qSearch = "";
    getCurrUser();
  }

  bool isAuthenticated() =>
      fb
          .auth()
          .currentUser != null;

  // if(currUser.pktvendorid == pktvendorid && substring.role == teknisi)
  getListTechnician() {
    db.collection("users")
        .where("pktVendorId", "==", currUser['pktVendorId'])
        .get()
        .then((snapshot) {
      //filtering role
      snapshot.docs.forEach((it) {
        String role = it.data()['role'].toString();
        String temp = role.substring(0, role.indexOf(" "));
        if (temp == 'Teknisi') {
          listTechnician.add(it.data());
        }
      });
    });
  }

  //getUser
  getCurrUser() {
    db.collection("users").where("uid", "==", uid).get().then((snapshot) {
      currUser = snapshot.docs.first.data();
    }).whenComplete(() {
      getUserComplete = true;
      //get list of technician
      getListTechnician();
    });
  }

  deleteTechnician(String techId) {
    db.collection("users").where("uid","==",techId).get().then((snapshot){
      snapshot.docs.first.ref.delete();
    });
    print(techId);
  }
}