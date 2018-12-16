import 'package:angular_router/angular_router.dart';
const jobId = 'id';
class RoutePaths {
  static final assignTo = RoutePath(path: '${'assignTechnician'}/:$jobId');
  static final dashboard = RoutePath(path: 'dashboard');
  static final needHelp = RoutePath(path: 'needHelpDashboard');
  static final finishedDashboard = RoutePath(path: 'finishedDashboard');
  static final detailDashboard = RoutePath(path:'${'detail'}/:$jobId');
  static final manualTicket = RoutePath(path: '/createManualTicket');

  String getId(Map<String, String> parameters) {
    final id = parameters[jobId];
    return id == null ? null : jobId;
  }
}