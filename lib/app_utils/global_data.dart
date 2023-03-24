import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String currentDate = DateFormat("MMM dd, yyyy").format(DateTime.now());
ValueNotifier selectIndex = ValueNotifier(0);
