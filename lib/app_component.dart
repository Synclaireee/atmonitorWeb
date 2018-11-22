import 'dart:async';
import 'dart:js';

import 'package:angular_router/angular_router.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:firebase_dart_ui/firebase_dart_ui.dart';

import 'package:firebase/src/interop/firebase_interop.dart';
import 'src/routes.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: [
    'src/util/util.css',
    'src/util/animate.css',
    'src/util/table.css',
    'src/util/perfect-scrollbar.css',
    'src/util/bootstrap.min.css',
    'src/util/select2.min.css'
  ],
  templateUrl: 'app_component.html',
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

class AppComponent implements OnInit {
  List<DocumentSnapshot> jobList;
  UIConfig _uiConfig;

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
    fb.initializeApp(
        apiKey: 'AIzaSyDsjgrTbtdNenCDvx76qhcKR-hGIWJ9x58',
        authDomain: 'fir-testing-c9acf.firebaseapp.com',
        databaseURL: 'https://fir-testing-c9acf.firebaseio.com',
        projectId: 'fir-testing-c9acf',
        storageBucket: 'fir-testing-c9acf.appspot.com',
        messagingSenderId: '895394713441');
    getJobs();
  }

  Future<Null> logout() async {
    await fb.auth().signOut();
    providerAccessToken = "";
  }

  PromiseJsImpl<void> signInFailure(AuthUIError authUiError) {
    // nothing to do;
    return new PromiseJsImpl<void>(() => print("SignIn Failure"));
  }

  bool signInSuccess(fb.UserCredential authResult, String redirectUrl) {
    print(
        "sign in  success. ProviderID =  ${authResult.credential.providerId}");
    print("Info= ${authResult.additionalUserInfo}");

    // returning false gets rid of the double page load (no need to redirect to /)
    return false;
  }

  UIConfig getUIConfig() {
    if (_uiConfig == null) {
      var login = new CustomSignInOptions(
          provider: fb.EmailAuthProvider.PROVIDER_ID,
          // sample below of asking for additional scopes.
          // See https://developer.github.com/apps/building-oauth-apps/scopes-for-oauth-apps/
          scopes: [
            /*'repo', 'gist' */
          ]);

      var callbacks = new Callbacks(
          uiShown: () => print("UI shown callback"),
          signInSuccessWithAuthResult: allowInterop(signInSuccess),
          signInFailure: signInFailure);

      _uiConfig = new UIConfig(
          signInSuccessUrl: '/',
          signInOptions: [
            fb.EmailAuthProvider.PROVIDER_ID,
          ],
          signInFlow: "redirect",
          //signInFlow: "popup",
          credentialHelper: NONE,
          tosUrl: '/',
          callbacks: callbacks);
    }
    return _uiConfig;
  }

  bool isAuthenticated() => fb.auth().currentUser != null;

  String get userEmail => fb.auth().currentUser?.email;

  String get displayName => fb.auth().currentUser?.displayName;

  Map<String, dynamic> get userJson => fb.auth().currentUser?.toJson();

  // If the provider gave us an access token, we put it here.
  String providerAccessToken = "";

  getJobs() {
    Firestore db = fb.firestore();
    CollectionReference ref = db.collection("jobs");
    ref.get().then((snapshot) {
      jobList = snapshot.docs;
    });
    print(jobList);
  }

  deleteManualJob(String ticketNum) {
    Firestore db = fb.firestore();
    Query ref =
        db.collection("jobs").where("ticketNum", "==", ticketNum);
    ref.get().then((snapshot) {
      db.runTransaction((Transaction transaction) async {
        DocumentSnapshot documentSnapshot =
            await transaction.get(snapshot.docs.first.ref);

        await transaction
            .update(documentSnapshot.ref, data: {"status": "DELETED"});

      });
    });
  }
// Nothing here yet. All logic is in TodoListComponent.
}
