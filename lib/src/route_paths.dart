import 'package:angular_router/angular_router.dart';
const jobId = 'id';
class RoutePaths {
  static final assignTo = RoutePath(path: '${'assignTechnician'}/:$jobId');
  static final dashboard = RoutePath(path: 'dashboard');
  static final needHelp = RoutePath(path: 'needHelpDashboard');
  static final finishedDashboard = RoutePath(path: 'finishedDashboard');
  static final detailDashboard = RoutePath(path:'${'detail'}/:$jobId');
  static final manualTicket = RoutePath(path: 'createManualTicket');
  static final AOCDashboardPKT = RoutePath(path: 'PKTDashboard');
  static final AOCDashboardPKTFinished = RoutePath(path: 'finishedPKTDashboard');
  static final AOCDashboardVendor = RoutePath(path: 'vendorDashboard');
  static final AOCDashboardVendorFinished = RoutePath(path: 'finishedVendorDashboard');
  static final AddTechnician = RoutePath(path: 'addTechnician');
  static final DeleteTechnician = RoutePath(path: 'deleteTechnician');

  String getId(Map<String, String> parameters) {
    final id = parameters[jobId];
    return id == null ? null : jobId;
  }
}