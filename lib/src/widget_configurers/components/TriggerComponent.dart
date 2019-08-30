import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';

import 'common/ComponentAssertionMessages.dart';
import 'common/WidgetBuildingComponent.dart';

/// Carries the data that might be used in [TriggerComponent.builder].
class TriggerComponentData {
  /// [BuildContext] passed by [SelectionMenu].
  ///
  /// Must not be null.
  final BuildContext context;

  /// A callback that should be called when the trigger is triggered.
  /// Opens/Closes the menu associated with [SelectionMenu].
  ///
  /// Must not be null.
  final ToggleMenu toggleMenu;

  TriggerComponentData({
    @required this.context,
    @required this.toggleMenu,
  }) : assert(context != null && toggleMenu != null,
            ComponentAssertionMessages.nullAttributeInData);
}

/// Defines builder that returns a [Widget] that acts as a trigger.
///
/// **Example**
///
/// ```dart
/// TriggerComponent(
///   builder: (TriggerComponentData data)
///   {
///     return FlatButton(
///       onPressed: data.toggleMenu,
///       child: Text("Click Me"),
///     );
///   }
/// );
/// ```
///
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [TriggerComponentData]
/// * [TriggerBuilder]
class TriggerComponent implements WidgetBuildingComponent {
  /// A builder method to create the trigger [Widget].
  ///
  /// See also:
  /// * [TriggerBuilder].
  TriggerBuilder builder;

  /// See [TriggerBuilder].
  TriggerComponent({@required this.builder});

  /// The method uses the [TriggerComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [SelectionMenu].
  Widget build(TriggerComponentData data) {
    assert(
        data != null, ComponentAssertionMessages.nullDataPassedToBuildMethod);
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder(data);
  }
}

/// This typedef defines a method that returns a [Widget] that acts as the trigger
/// for the menu to open/close.
///
/// Used by [TriggerComponent] as [TriggerComponent.builder].
///
/// **Example**
///
/// ```dart
/// TriggerComponent(
///   builder: (TriggerComponentData data)
///   {
///     return FlatButton(
///       onPressed: data.toggleMenu,
///       child: Text("Click Me"),
///     );
///   }
/// );
/// ```
///
/// See Also:
/// * [TriggerComponent]
/// * [TriggerComponentData]
typedef Widget TriggerBuilder(TriggerComponentData data);

/// Callback to Open/Close the menu.
typedef void ToggleMenu();
