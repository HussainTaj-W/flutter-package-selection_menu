import 'package:flutter/widgets.dart';

/// An interface for ComponentData.
abstract class ComponentData {
  final BuildContext context;
  final dynamic selectedItem;

  ComponentData({@required this.context, @required this.selectedItem})
      : assert(
            context != null,
            "A WidgetBuildingComponentData was assigned null context.\n"
            "A Widget might need a BuildContext to access required information like themes.\n"
            "Assigning it is deemed neccessary.\n");
}
