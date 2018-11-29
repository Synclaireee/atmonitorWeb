import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:atmonitor/app_component.template.dart' as ng;
import 'main.template.dart' as self;

@GenerateInjector(
  routerProviders,
)

final InjectorFactory injector = self.injector$Injector;

void main() {
  if(fb.apps.length <= 0) {
    fb.initializeApp(
        apiKey: 'AIzaSyDsjgrTbtdNenCDvx76qhcKR-hGIWJ9x58',
        authDomain: 'fir-testing-c9acf.firebaseapp.com',
        databaseURL: 'https://fir-testing-c9acf.firebaseio.com',
        projectId: 'fir-testing-c9acf',
        storageBucket: 'fir-testing-c9acf.appspot.com',
        messagingSenderId: '895394713441');
  }
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
