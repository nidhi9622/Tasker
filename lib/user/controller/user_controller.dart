import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  Rx<TextEditingController> phoneController = Rx(TextEditingController());
  Rx<TextEditingController> nameController = Rx(TextEditingController());
  Rx<TextEditingController> designationController = Rx(TextEditingController());
  RxString profileImage=RxString('');
}