import 'package:flutter/material.dart';

TextStyle myTextStyle({
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
  TextOverflow? overflow,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    overflow: overflow,
  );
}
