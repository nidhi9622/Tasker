// class DataModel {
//   String? title;
//   Map object;
//   String? subtitle;
//   double? percentage;
//   String? description;
//   String? date;
//   bool? reminder;
//   String? status;
//   String? time;
//   DataModel(this.object) {
//     title = object['title'];
//     subtitle = object['subTitle'];
//     percentage = object['percentage'];
//     description = object['description'];
//     date = object['date'];
//     reminder = object['reminder'];
//     time = object['time'];
//     status = object['status'];
//   }
// }
/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
import 'package:task_manager/app_utils/project_status.dart';

class DataModel {
  String? title;
  String? subTitle;
  String? description;
  double? percentage;
  String? date;
  bool? reminder;
  String? time;
  String? status;
  int? id;
  ProjectStatus? projectStatus;

  DataModel(
      {this.title,
      this.subTitle,
      this.description,
      this.id,
      this.percentage,
      this.date,
      this.reminder,
      this.time,
      this.status,
      this.projectStatus});

  DataModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['subTitle'];
    description = json['description'];
    percentage = json['percentage'];
    date = json['date'];
    reminder = json['reminder'];
    time = json['time'];
    status = json['status'];
    projectStatus = json['projectStatus'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['description'] = description;
    data['percentage'] = percentage;
    data['date'] = date;
    data['reminder'] = reminder;
    data['time'] = time;
    data['status'] = status;
    data['id'] = id;
    data['projectStatus'] = projectStatus;
    return data;
  }
}
