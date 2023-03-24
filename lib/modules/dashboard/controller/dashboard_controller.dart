import 'package:get/get.dart';
import '../../notepad/views/notepad.dart';
import '../../project/views/add_project.dart';
import '../../project/views/projects.dart';
import '../views/dashboard.dart';

class DashboardController extends GetxController {
  RxString username=RxString('');
  RxDouble position = RxDouble(1.0);
  RxInt oldIndex = RxInt(0);
  Rx<List> projectList=Rx([]);
  Rx screens=Rx([
    const Dashboard(),
    const Projects(),
    const AddProject(),
    const NotePad()
  ]);
}
