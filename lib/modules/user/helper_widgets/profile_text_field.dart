import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final Color borderColor = Colors.brown;
  final BuildContext context;
  final String hintText;
  final String labelText;
  final bool isNumber;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final TextEditingController controller;
  final String? Function(String?) validator;
  //final void Function(String) onChange;
  final IconData icon;
  final bool isPassword;

  const ProfileTextField(
      {Key? key,
      required this.context,
      required this.hintText,
      required this.labelText,
      required this.isNumber,
      required this.inputType,
      required this.inputAction,
      required this.controller,
      required this.validator,
      //required this.onChange,
      required this.icon,
      required this.isPassword})
      : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
      //autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Theme.of(context).primaryColorDark,
      textInputAction: inputAction,
      keyboardType: inputType,
      obscureText: isPassword,
      controller: controller,
      validator: validator,
      //onChanged: onChange,
      maxLength: isNumber ? 10 : 25,
      decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),
          counterStyle:
              TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          labelText: hintText == '' ? labelText : '',
          labelStyle: TextStyle(color: Theme.of(context).primaryColorLight),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[200]!)),
          focusedErrorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
          //enabledBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
          errorMaxLines: 2,
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
          errorStyle: TextStyle(
            color: Theme.of(context).primaryColorLight,
            fontStyle: FontStyle.italic,
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.solid)),
          hintText: labelText,
          hintStyle: const TextStyle(color: Colors.grey)),
    );
}
