import 'dart:async';
import 'dart:math';
import 'dart:core';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:firebase_dart_ui/firebase_dart_ui.dart';
import 'package:firebase_admin_interop/firebase_admin_interop.dart' as ad;

import '../routes.dart';

@Component(
  selector: 'manualTicket',
  styleUrls: [
    '../util/util.css',
    '../util/bootstrap.min.css',
    '../util/animate.css',
  ],
  templateUrl: 'add_technician_component.html',
  directives: [
    coreDirectives,
    FirebaseAuthUIComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialSelectSearchboxComponent,
    routerDirectives,
    formDirectives,
  ],
  pipes: [commonPipes],
  exports: [RoutePaths, Routes],
)
class AddTechnicianComponent implements OnInit {
  Router _route;
  AddTechnicianComponent(this._route);

  Firestore db = fb.firestore();
  bool futureComplete = false;

  String get uid => fb.auth().currentUser?.uid;
  Map<String, dynamic> currUser;

  Map<String, dynamic> cTech = {
    'email': null,
    'name': null,
    'phone': null,
    'pktVendor': null,
    'pktVendorId': null,
    'role': null,
    'uid': null
  };

  @override
  void ngOnInit() {
    getCurrUser();
  }

  getCurrUser() {
    db.collection("users").where("uid", "==", uid).get().then((snapshot) {
      currUser = snapshot.docs.first.data();
    }).whenComplete(() {
      futureComplete = true;
    });
  }

  clear(){
    cTech['name'] = null;
    cTech['email'] = null;
    cTech['phone'] = null;
  }
  onSubmit() async{

    cTech['pktVendor'] = currUser['pktVendor'];
    cTech['pktVendorId'] = currUser['pktVendorId'];
    cTech['role'] = "Teknisi " + currUser['pktVendor'];

    var secondApp = fb.initializeApp(
        apiKey: 'AIzaSyDsjgrTbtdNenCDvx76qhcKR-hGIWJ9x58',
        authDomain: 'fir-testing-c9acf.firebaseapp.com',
        databaseURL: 'https://fir-testing-c9acf.firebaseio.com',
        projectId: 'fir-testing-c9acf',
        storageBucket: 'fir-testing-c9acf.appspot.com',
        messagingSenderId: '895394713441',
        name: "second");

    await secondApp.auth().createUserAndRetrieveDataWithEmailAndPassword(cTech['email'], "default").then((u){
      cTech['uid'] = u.user.uid;
      print(cTech['uid']);
      db.collection("users").add(cTech);
      secondApp.auth().signOut();
    });


//    //test
//    final admins = ad.FirebaseAdmin.instance;
//    final apps = admins.initializeApp(
//      new ad.AppOptions(
//        credential: admins.certFromPath("../util/serviceAccount.json"),
//        databaseURL: "https://fir-testing-c9acf.firebaseio.com",
//      )
//    );
//
//    ad.CreateUserRequest req = new ad.CreateUserRequest(
//      disabled: false,
//      displayName: cTech['name'],
//      email: cTech['email'],
//      emailVerified: false,
//      password: "default",
//      phoneNumber: cTech['phone']
//    );
//
//    await apps.auth().createUser(req).then((u){
//      cTech['uid'] = u.uid;
//      db.collection("users").add(cTech);
//    });
//    //test

  }

  logout() async{
    await fb.auth().signOut();
  }
}
