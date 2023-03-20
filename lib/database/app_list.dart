import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard/views/dashboard.dart';
import '../notepad/views/notepad.dart';
import '../project/views/add_project.dart';
import '../project/views/projects.dart';

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