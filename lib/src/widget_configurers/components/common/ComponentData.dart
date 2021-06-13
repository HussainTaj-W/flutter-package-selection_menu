import 'package:flutter/widgets.dart';

/// An interface for ComponentData.
abstract class ComponentData {
  final BuildContext context;
  final dynamic selectedItem;

  ComponentData({required this.context, required this.selectedItem});
}
