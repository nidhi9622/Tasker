import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<String> getImage({required ImageSource source}) async {
  var file = await ImagePicker().pickImage(source: source);
  if (Platform.isAndroid) {
    if (file?.path != null) {
      File? crop = await ImageCropper().cropImage(
          sourcePath: file!.path,
          androidUiSettings: const AndroidUiSettings(
              toolbarTitle: "Crop",
              toolbarColor: Colors.white10,
              statusBarColor: Colors.blueGrey));
      var image = crop!.path.toString();
      return image;
    } else {
      return "";
    }
  } else {
    var image = file!.path.toString();
    return image;
  }
}
