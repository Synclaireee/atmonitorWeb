import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';

import 'AssignTo/assign_to_component.template.dart' as assign_to_template;
import 'Dashboard/dashboard_component.template.dart' as dashboard_template;
import 'NeedHelpDashboard/need_help_component.template.dart' as need_help_template;
export 'route_paths.dart';

class Routes {
  static final assignTo = RouteDefinition(
    routePath: RoutePaths.assignTo,
    component: assign_to_template.AssignToComponentNgFactory,
  );

  static final dashboard = RouteDefinition(
    routePath: RoutePaths.dashboard,
    component: dashboard_template.DashboardComponentNgFactory,
  );

  static final needHelpDashboard = RouteDefinition(
    routePath:  RoutePaths.needHelp,
    component:  need_help_template.NeedHelpComponentNgFactory,
  );
  static final all = <RouteDefinition>[
    assignTo,
    dashboard,
    needHelpDashboard,
  ];
}
