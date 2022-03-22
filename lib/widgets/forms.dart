import 'package:flutter/material.dart';

TextField inputTextField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
  onTap,
  onComplete,
  isReadOnly = false,
  isEnabled = true,
  FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.auto,
}) {
  return TextField(
    style: textFieldStyle,
    readOnly: isReadOnly,
    onTap: onTap,
    onEditingComplete: onComplete,
    controller: controller,
    decoration: InputDecoration(
      floatingLabelBehavior: floatingLabelBehavior,
      labelText: labelText,
      enabled: isEnabled,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.black12,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.black12,
          width: 0.8,
        ),
      ),
      hintStyle: hintStyleStyle,
    ),
  );
}

TextField inputTextFieldSearch({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
  onTap,
  onComplete,
  onChanged,
  isReadOnly = false,
  isEnabled = true,
  suffixIcon,
  prefixIcon,
  FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.auto,
}) {
  return TextField(
    style: textFieldStyle,
    readOnly: isReadOnly,
    onTap: onTap,
    onEditingComplete: onComplete,
    onChanged: (s) => onChanged(),
    controller: controller,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      floatingLabelBehavior: floatingLabelBehavior,
      labelText: labelText,
      enabled: isEnabled,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.0,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0,
        ),
      ),
      hintStyle: hintStyleStyle,
    ),
  );
}

TextField inputNumberTextField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
}) {
  return TextField(
    style: textFieldStyle,
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.black12,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.black12,
          width: 0.8,
        ),
      ),
      hintStyle: hintStyleStyle,
    ),
  );
}

TextField inputTextArea({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
}) {
  return TextField(
    style: textFieldStyle,
    controller: controller,
    maxLines: 3,
    maxLength: 255,
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      hintStyle: hintStyleStyle,
    ),
  );
}
