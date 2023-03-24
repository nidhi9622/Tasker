import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String currentDate = DateFormat("MMM dd, yyyy").format(DateTime.now());
List canceledProjects = [];
List upcomingProjects = [];
List completedProjects = [];
List ongoingProjects = [];
List projectItem = [];
ValueNotifier selectIndex=ValueNotifier(0);
List<Map<String,dynamic>> totalProjectList=[];