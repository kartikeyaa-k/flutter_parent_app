import 'package:flutter/material.dart';
import 'package:parent_app/features/core/style/primary_theme.dart';

InputDecoration primaryTextFieldDecoration({required String hintText}) {
  return InputDecoration(
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.black54,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.5),
      ),
    ),
    hintText: hintText,
    hintMaxLines: 1,
    hintStyle: PrimaryTheme.labelTextStyle
        .copyWith(color: PrimaryTheme.alternativeColor.withOpacity(0.5)),
  );
}
