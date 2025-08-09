import 'package:flutter/material.dart';

extension SliverBoxExtension on Widget {
  Widget asSliverBox() {
    return SliverToBoxAdapter(child: this);
  }
}