import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';

import 'AssignTo/assign_to_component.template.dart' as assign_to_template;

export 'route_paths.dart';

class Routes {
  static final assignTo = RouteDefinition(
      routePath: RoutePaths.assignTo,
      component: assign_to_template.AssignToComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    assignTo,
  ];
}