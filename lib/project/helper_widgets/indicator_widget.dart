import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/models/data_model.dart';

class IndicatorWidget extends StatelessWidget {
  final DataModel dataModel;
  const IndicatorWidget({Key? key, required this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size deviceSize=MediaQuery.of(context).size;
    return SizedBox(
      width: deviceSize.width * 0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 35,
            center: Text('${dataModel.percentage!}%'),
            animation: true,
            animationDuration: 1000,
            percent: dataModel.percentage! / 100,
            progressColor: Colors.green,
            backgroundColor: Colors.grey[300]!,
          )
        ],
      ),
    );
  }
}
