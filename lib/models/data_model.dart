class DataModel {
  String? title;
  Map object;
  String? subtitle;
  int? percentage;
  String? description;
  dynamic date;
  bool? reminder;
  String? status;
  dynamic time;
  DataModel(this.object) {
    title = object['title'];
    subtitle = object['subTitle'];
    percentage = object['percentage'];
    description = object['description'];
    date = object['date'];
    reminder = object['reminder'];
    time = object['time'];
    status = object['status'];
  }
}