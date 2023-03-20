import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/dashboard/helper_methods/search.dart';
import '../helper_widgets/process_detail_view.dart';

class ProcessDetail extends StatefulWidget {
  final String title;
  final List object;

  const ProcessDetail({Key? key, required this.title, required this.object})
      : super(key: key);

  @override
  State<ProcessDetail> createState() => _ProcessDetailState();
}

class _ProcessDetailState extends State<ProcessDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search(text: ''));
              },
              icon: Icon(
                CupertinoIcons.search,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: ProcessDetailView(
        tabList: widget.object,
      ),
    );
  }
}
