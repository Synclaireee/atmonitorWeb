import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';

import 'AssignTo/assign_to_component.template.dart' as assign_to_template;
import 'Dashboard/dashboard_component.template.dart' as dashboard_template;
import 'NeedHelpDashboard/need_help_component.template.dart' as need_help_template;
import 'FinishedDashboard/finished_dashboard_component.template.dart' as finished_dashboard_template;
import 'DetailDashboard/detail_dashboard_component.template.dart' as detail_dashboard_template;
import 'ManualTicket/manual_ticket_component.template.dart' as manual_ticket_template;
import 'AOCDashboardPKT/aoc_dashboard_pkt_component.template.dart' as aoc_dashboard_pkt_template;
import 'AOCDashboardPKTFinished/aoc_dashboard_pkt_finished_component.template.dart' as aoc_dashboard_pkt_finished_template;
import 'AOCDashboardVendor/aoc_dashboard_vendor_component.template.dart' as aoc_dasboard_vendor_template;
import 'AOCDashboardVendorFinished/aoc_dashboard_vendor_finished_component.template.dart' as aoc_dashboard_vendor_finished_template;

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


  static final detailDashboard = RouteDefinition(
    routePath:  RoutePaths.detailDashboard,
    component:  detail_dashboard_template.DetailDashboardComponentNgFactory
  );

  static final finishedDashboard = RouteDefinition(
    routePath:  RoutePaths.finishedDashboard,
    component:  finished_dashboard_template.FinishedDashboardComponentNgFactory,
  );

  static final manualTicket = RouteDefinition(
    routePath: RoutePaths.manualTicket,
    component: manual_ticket_template.ManualTicketComponentNgFactory,
  );

  static final AOCDashboardPKT = RouteDefinition(
    routePath: RoutePaths.AOCDashboardPKT,
    component: aoc_dashboard_pkt_template.AOCDashboardPKTComponentNgFactory,
  );
  static final AOCDashboardPKTFinished = RouteDefinition(
    routePath: RoutePaths.AOCDashboardPKTFinished,
    component: aoc_dashboard_pkt_finished_template.AOCDashboardPKTFinishedComponentNgFactory
  );

  static final AOCDashboardVendor = RouteDefinition(
    routePath: RoutePaths.AOCDashboardVendor,
    component: aoc_dasboard_vendor_template.AOCDashboardVendorComponentNgFactory,
  );

  static final AOCDashboardVendorFinished = RouteDefinition(
    routePath: RoutePaths.AOCDashboardVendorFinished,
    component: aoc_dashboard_vendor_finished_template.AOCDashboardVendorFinishedComponentNgFactory,
  );
  static final all = <RouteDefinition>[
    assignTo,
    dashboard,
    needHelpDashboard,
    finishedDashboard,
    detailDashboard,
    manualTicket,
    AOCDashboardPKT,
    AOCDashboardPKTFinished,
    AOCDashboardVendor,
    AOCDashboardVendorFinished,
  ];
}
