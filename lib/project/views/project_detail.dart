import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/dashboard/views/homePage.dart';
import 'package:task_manager/dashboard/helper_methods/search.dart';
import '../helper_widgets/project_detail_body.dart';

class ProjectDetail extends StatefulWidget {
  final Map object;

  const ProjectDetail({Key? key, required this.object}) : super(key: key);

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
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
