import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/dashboard/helper_methods/search.dart';
import '../../app_utils/app_routes.dart';
import '../helper_widgets/project_detail_body.dart';

class ProjectDetail extends StatefulWidget {
  final Map object;

  const ProjectDetail({Key? key, required this.object, }) : super(key: key);

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
 // Map object=Get.arguments["object"];
  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        AppRoutes.go(AppRouteName.homePage);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () {
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
                    showSearch(context: context, delegate: Search(text: ''));
                  },
                  icon: Icon(
                    CupertinoIcons.search,
                    color: Theme.of(context).primaryColorDark,
                  ))
            ],
          ),
          body: ProjectDetailBody(object: widget.object,)),
    );
}
