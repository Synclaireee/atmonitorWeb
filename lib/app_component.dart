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
import 'src/route_paths.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: [
    'app_component.css',
    'src/util/util.css',
    'src/util/bootstrap.min.css',
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
  UIConfig _uiConfig;
  Firestore db = fb.firestore();
  String providerAccessToken = "";

  bool isAuthenticated() => fb.auth().currentUser != null;

  String get uid => fb.auth().currentUser?.uid;

  String get uName => fb.auth().currentUser?.displayName;

  Map<String, dynamic> get userJson => fb.auth().currentUser?.toJson();

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
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
          signInSuccessUrl: '/dashboard',
          signInOptions: [
            fb.EmailAuthProvider.PROVIDER_ID,
          ],
          signInFlow: "redirect",
          //signInFlow: "popup",
          credentialHelper: NONE,
          tosUrl: '/dashboard',
          callbacks: callbacks);
    }
    return _uiConfig;
  }

  Future<Null> logout() async {
    await fb.auth().signOut();
    providerAccessToken = "";
  }

}
