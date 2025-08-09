import 'package:flutter/material.dart';

extension ExpandedExtension on Widget {
  Widget asExpanded() {
    return Row(children: [Expanded(child: this)]);
  }
}
