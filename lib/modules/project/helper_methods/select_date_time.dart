import 'package:flutter/material.dart';

Future selectDate(BuildContext context) async {
  DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  return datePicked;
}

Future selectTime(BuildContext context) async {
  TimeOfDay? timePicked =
  await showTimePicker(initialTime: TimeOfDay.now(), context: context);
  return timePicked;
}