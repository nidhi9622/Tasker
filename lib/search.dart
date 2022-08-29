import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/projectDetail.dart';
import 'dashboard.dart';

class Search extends SearchDelegate<String> {
  String text;
  Search({required this.text});
  @override
  set query(String value) {
    super.query = text;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
            onPressed: () {
              query = '';
            },
            icon: Icon(
              CupertinoIcons.clear,
              color: Theme.of(context).primaryColorDark,
            ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    dynamic list;
    list = projectItem
        .where((element) =>
            element['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return list.isEmpty
        ? const Center(
            child: Text("No Result Found",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25)))
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: query.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(
                        thickness: 2,
                      );
                    },
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final object = list[index];
                      return ListTile(
                        title: Text(object['title']),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ProjectDetail(object: object)));
                        },
                      );
                    })
                : null,
          );
  }
}
