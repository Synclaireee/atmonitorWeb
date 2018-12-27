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

import '../routes.dart';

@Component(
  selector: 'manualTicket',
  styleUrls: [
    '../util/util.css',
    '../util/bootstrap.min.css',
    '../util/animate.css',
  ],
  templateUrl: 'manual_ticket_component.html',
  directives: [
    coreDirectives,
    FirebaseAuthUIComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialSelectSearchboxComponent,
    routerDirectives,
    formDirectives
  ],
  pipes: [commonPipes],
  exports: [RoutePaths, Routes],
)
class ManualTicketComponent implements OnInit {
  List<DocumentSnapshot> jobList;
  Firestore db = fb.firestore();
  bool futureComplete = false;

  String get uid => fb.auth().currentUser?.uid;
  Map<String, dynamic> currUser;
  List<DocumentSnapshot> machines;

  Map<String, dynamic> currJob = {
    'isManual': true,
    'location': null,
    'pktId': null,
    'pktName': null,
    'problemDesc': null,
    'serialNum': null,
    'startDatetime': null,
    'status': 'PENDING',
    'ticketNum': null,
    'vendorId': null,
    'vendorName': null,
    'wsid': null
  };

  @override
  void ngOnInit() {
    getTicketNum();
    getCurrUser();
  }

  getCurrUser() {
    db.collection("users").where("uid", "==", uid).get().then((snapshot) {
      currUser = snapshot.docs.first.data();
    }).whenComplete(() {
      futureComplete = true;
    }).then((_) {
      getMachine();
    });
  }

  getMachine() {
    db
        .collection("machines")
        .where("pktId", "==", currUser['pktVendorId'])
        .get()
        .then((snapshot) {
      machines = snapshot.docs.toList();
    }).then((_) {});
  }

  getTicketNum(){
    Random rnd = new Random();
    String temp;
    temp = (rnd.nextDouble()*10000000000).floor().toString();
    db.collection("jobs").where("ticketNum","==",temp).get().then((snapshot){
      if(snapshot.docs.isEmpty){
        currJob['ticketNum'] = temp;
        return;
      }
      else{
        print('duplicate');
        getTicketNum();
      }
    });
  }
  clear(){
    currJob['problemDesc'] ='';
  }
  onSubmit() async{
    currJob['startDatetime'] = DateTime.now();
    await db.collection("machines").where("wsid", "==", currJob['wsid']).get().then((snapshot){

      currJob['location'] = snapshot.docs.first.data()['location'].toString();
      currJob['pktId'] = snapshot.docs.first.data()['pktId'].toString();
      currJob['pktName'] = snapshot.docs.first.data()['pktName'].toString();
      currJob['serialNum'] = snapshot.docs.first.data()['serialNum'].toString();
      currJob['vendorId'] = snapshot.docs.first.data()['vendorId'].toString();
      currJob['vendorName'] = snapshot.docs.first.data()['vendorName'].toString();

    });

    db.collection("jobs").add(currJob);
  }

}
