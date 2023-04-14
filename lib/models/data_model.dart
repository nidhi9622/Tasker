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

class DataModel {
  String? title;
  String? subTitle;
  String? description;
  double? percentage;
  String? date;
  bool? reminder;
  String? time;
  String? formattedTime;
  int? selectedHour;
  int? selectedMin;
  String? status;
  int? id;
  String? projectStatus;

  DataModel(
      {this.title,
      this.subTitle,
      this.description,
      this.id,
      this.percentage,
      this.formattedTime,
      this.selectedMin,
      this.selectedHour,
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
    selectedHour = json['selectedHour'];
    selectedMin = json['selectedMin'];
    date = json['date'];
    reminder = json['reminder'];
    formattedTime = json['formattedTime'];
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
    data['selectedMin'] = selectedMin;
    data['selectedHour'] = selectedHour;
    data['status'] = status;
    data['id'] = id;
    data['formattedTime'] = formattedTime;
    data['projectStatus'] = projectStatus;
    return data;
  }
}
