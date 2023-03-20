import 'package:flutter/material.dart';
import '../../database/app_list.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
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
          tabs: tabs,
          labelColor: Colors.white,
          unselectedLabelColor:
          Colors.red[200] //const Color(0xffffb2a6),
      ),
    );
  }
}
