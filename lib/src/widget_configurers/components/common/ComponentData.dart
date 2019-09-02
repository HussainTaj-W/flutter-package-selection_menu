import 'package:flutter/widgets.dart';

/// An interface for ComponentData.
abstract class ComponentData {
  final BuildContext context;
  final dynamic selectedItem;

  ComponentData({@required this.context, @required this.selectedItem})
      : assert(context != null,
            '''A WidgetBuildingComponentData was assigned null context. 
  A Widget might need a BuildContext to access required information like themes.
  Assigning it is deemed neccessary.''');
}
