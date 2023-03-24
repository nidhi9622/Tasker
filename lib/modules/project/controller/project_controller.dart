import 'package:get/get.dart';

class ProjectController extends GetxController {
  Rx<List> completedProjects = Rx([]);
  Rx<List> ongoingProjects = Rx([]);
  Rx<List> projectItem = Rx([]);
  RxInt displayIndex=RxInt(0);
}
