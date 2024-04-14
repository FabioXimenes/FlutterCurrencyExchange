import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle? titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge;

  static TextStyle? titleSmallBold(BuildContext context) => Theme.of(context)
      .textTheme
      .titleSmall
      ?.copyWith(fontWeight: FontWeight.bold);
}
