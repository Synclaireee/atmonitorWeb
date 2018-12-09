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
  templateUrl: 'assign_to_component.html',
  styleUrls: [
    '../util/util.css',
    '../util/bootstrap.min.css',
    '../util/animate.css'
  ],
  directives: [coreDirectives, routerDirectives, MaterialIconComponent, formDirectives],
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
  String techName;
  bool getJobComplete = false;
  bool getUserComplete = false;
  Map<String,dynamic> currUser = new Map<String,dynamic>();
  Map<String,dynamic> currJob = new Map<String,dynamic>();
  List<Map<String,dynamic>> listTechnician = new List<Map<String,dynamic>>();

  @override
  void ngOnInit() {
    getCurrUser();
  }

  getJob() {
      db.collection("jobs").where("ticketNum", "==", jobId).get().then((snapshot){
      currJob = snapshot.docs.first.data();
    }).whenComplete((){
        getTechName();
    });
  }

  // if(currUser.pktvendorid == pktvendorid && substring.role == teknisi)
  getListTechnician() {
      db.collection("users").where("pktVendorId", "==", currUser['pktVendorId']).get().then((snapshot){
        //filtering role
        snapshot.docs.forEach((it){
          String role = it.data()['role'].toString();
          String temp = role.substring(0,role.indexOf(" "));
          if(temp == 'Teknisi'){
            listTechnician.add(it.data());
          }
        });
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
    db.collection("users").where("uid","==",uid).get().then((snapshot) {
      currUser = snapshot.docs.first.data();
    }).whenComplete((){
      getUserComplete = true;
      //get list of technician
      getListTechnician();
    });
  }

  //assign
  assignJob(String techId){
    db.collection("jobs").where("ticketNum","==",currJob['ticketNum']).get().then((snapshot){
      print(snapshot.docs.first.data()['ticketNum']);
      db.runTransaction((fs.Transaction transaction) async{
        fs.DocumentSnapshot documentSnapshot = await transaction.get(snapshot.docs.first.ref);
        await transaction.update(documentSnapshot.ref, data: {"assignedTo" : techId , "status" : "NOT ACCEPTED"});
      });
    });
  }

  //get currJob['assignedTo'] name
  getTechName() {
    if(currJob['assignedTo'] != null){
      db.collection("users").where("uid", "==", currJob['assignedTo']).get().then((snapshot) {
        techName = snapshot.docs.first.data()['name'];
      });
    }
    else{
      print('noData');
    }
  }
}