import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<Tab> tabList;
  ValueNotifier displayIndex;

  CustomTabBar({Key? key, required this.tabList, required this.displayIndex})
      : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 17, bottom: 17),
      child: DefaultTabController(
        length: widget.tabList.length,
        child: Builder(builder: (context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            widget.displayIndex.value = tabController.index;
            // setState(() {
            // displayIndex = tabController.index;
            // });
          });
          return Container(
            height: 65,
            width: deviceSize.width,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15)),
            child: TabBar(
                padding: const EdgeInsets.all(8),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.red[200]),
                tabs: widget.tabList,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.red[200] //const Color(0xffffb2a6),
                ),
          );
        }),
      ),
    );
  }
}
