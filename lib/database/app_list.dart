import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/dashboard/views/dashboard.dart';
import '../modules/notepad/views/notepad.dart';
import '../modules/project/views/add_project.dart';
import '../modules/project/views/projects.dart';

List<Tab> tabs = [
  Tab(text: 'all'.tr),
  Tab(text: 'Ongoing'.tr),
  Tab(text: 'Completed'.tr),
];
List<Tab> detailedPageTab = [
  Tab(text: 'taskList'.tr),
  Tab(text: 'notes'.tr),
];

List dropdownOptions = [
  'Ongoing'.tr,
  'Complete'.tr,
  'Upcoming'.tr,
  'Canceled'.tr
];
List<Widget> screens = [
  const Dashboard(),
  const Projects(),
  const AddProject(),
  const NotePad()
];