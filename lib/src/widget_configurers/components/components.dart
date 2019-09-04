/// Defines Component classes that can be used to configure
/// [ComponentsConfiguration].
///
/// Each component defines a specific UI related part of the [SelectionMenu] or
/// [ListViewMenu].
///
/// Components follow a similar pattern.
/// Take for example a component called **X**.
///
/// This library provides:
///
/// * Class: **X**Component. [SearchFieldComponent] for example.
/// * Class: **X**ComponentData. [SearchFieldComponentData] for example.
/// * Function Type: **X**Builder. [SearchFieldBuilder] for example.
///
/// _XComponentData_ contains data that might be required during the process of
/// building. Like [SearchFieldComponentData.context].
///
/// _XComponent_ carries a builder method of type _XBuilder_ which takes an
/// instance of _XComponentData_ as a parameter.
///
/// Like so:
///
/// ```dart
/// XComponent(
///   builder: instanceOfXBuilder(XComponentData data)
///   {
///     //implementation.
///   }
/// );
/// ```
///
/// ![Image of Components](https://i.imgur.com/QL67eib.jpg)
library components;

//
import 'package:selection_menu/selection_menu.dart';

import './../configurations/configurations.dart';
import 'SearchFieldComponent.dart';

export 'AnimationComponent.dart';
export 'ListViewComponent.dart';
export 'MenuComponent.dart';
export 'MenuPositionAndSizeComponent.dart';
export 'SearchBarComponent.dart';
export 'SearchFieldComponent.dart';
export 'SearchingIndicatorComponent.dart';
export 'TriggerComponent.dart';
export 'TriggerFromItemComponent.dart';
export 'common/ComponentLifeCycleMixin.dart';
