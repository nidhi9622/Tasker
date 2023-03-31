import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app_utils/global_data.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
import '../../dashboard/helper_methods/search.dart';
import '../helper_widgets/project_detail_body.dart';

class ProjectDetail extends StatefulWidget {
  final Map<String,dynamic> object;

  const ProjectDetail({Key? key, required this.object, }) : super(key: key);

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  List totalProjectList=[];
  @override
  void initState() {
    if (GetPrefs.containsKey(GetPrefs.projects)) {
      var map = GetPrefs.getString(GetPrefs.projects);
      totalProjectList = jsonDecode(map);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            selectIndex.value=0;
            AppRoutes.go(AppRouteName.homePage);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search(text: '', totalProjectList: totalProjectList));
              },
              icon: Icon(
                CupertinoIcons.search,
                color: Theme.of(context).primaryColorDark,
              ))
        ],
      ),
      body: ProjectDetailBody(object: widget.object,));
}
