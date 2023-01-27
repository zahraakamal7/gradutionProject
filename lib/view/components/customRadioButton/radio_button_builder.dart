import 'package:flutter/material.dart';

import 'radio_button_text_position.dart';

class RadioButtonBuilder<T> {
  final String description;
  final TextStyle? descriptionStyle;
  final RadioButtonTextPosition? textPosition;

  RadioButtonBuilder(
    this.description, {
    this.descriptionStyle,
    this.textPosition,
  });
}
