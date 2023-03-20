import 'package:flutter/material.dart';

TextFormField inputBox({
  keyboardType = TextInputType.text,
  String labelText = "값을 입력하세요",
  String errorMsg = "값을 입력하세요",
  bool obscureText = false,
  Function(dynamic value)? onChanged,
}) {
  return TextFormField(
    obscureText: obscureText,
    onChanged: onChanged,
    keyboardType: keyboardType,
    // onSaved: (value) {},
    // validator 에서 return 한 메세지를 inputBox 하단에 보이기
    autovalidateMode: AutovalidateMode.always,
    validator: (value) {
      if (value!.isEmpty) {
        return errorMsg;
      }
      return null;
    },
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: labelText,
    ),
  );
}
