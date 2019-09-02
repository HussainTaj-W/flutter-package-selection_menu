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
/// TODO: Add Image
///
/// See:
/// * [AnimationComponent].
/// * [ListViewComponent].
/// * [SearchFieldComponent].
/// * [SearchingIndicatorComponent].
/// * [SearchBarComponent].
/// * [MenuComponent].
/// * [MenuPositionAndSizeComponent].
/// * [TriggerComponent].
/// * [TriggerFromItemComponent].
/// * [ComponentLifeCycleMixin].

library components;

//
import 'package:selection_menu/selection_menu.dart';

import './../configurations/configurations.dart';
import 'AnimationComponent.dart';
import 'ListViewComponent.dart';
import 'MenuComponent.dart';
import 'MenuPositionAndSizeComponent.dart';
import 'SearchBarComponent.dart';
import 'SearchFieldComponent.dart';
import 'SearchingIndicatorComponent.dart';
import 'TriggerComponent.dart';
import 'TriggerFromItemComponent.dart';
import 'common/ComponentLifeCycleMixin.dart';

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
