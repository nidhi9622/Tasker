import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CustomTabBar extends StatefulWidget {
  final List<Tab> tabList;
  RxInt displayIndex;

  CustomTabBar({Key? key, required this.tabList, required this.displayIndex})
      : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) => Padding(
        padding:
            const EdgeInsets.only(left: 14, right: 14, top: 17, bottom: 17),
        child: DefaultTabController(
          length: widget.tabList.length,
          child: Builder(builder: (context) {
            final TabController tabController =
                DefaultTabController.of(context);
            tabController.addListener(() {
              widget.displayIndex.value = tabController.index;
            });
            return Container(
              //height: 65,
              width: double.infinity,
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
                  unselectedLabelColor:
                      Colors.red[200] //const Color(0xffffb2a6),
                  ),
            );
          }),
        ),
      );
}
