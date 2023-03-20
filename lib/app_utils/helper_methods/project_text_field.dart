import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final int maxLength;
  final String? Function(String?) validator;
  final int maxLines;

  const ProjectTextField(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.inputType,
      required this.inputAction,
      required this.maxLength,
      required this.validator,
      required this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: TextFormField(
        controller: controller,
        textInputAction: inputAction,
        keyboardType: inputType,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
        ],
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          counterStyle:
              TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          alignLabelWithHint: true,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffffb2a6))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColorLight)),
          errorMaxLines: 2,
          errorStyle: const TextStyle(height: 0),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
                  style: BorderStyle.solid, color: Color(0xffffb2a6))),
        ),
      ),
    );
  }
}
