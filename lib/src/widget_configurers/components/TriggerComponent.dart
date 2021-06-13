import 'package:flutter/widgets.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

import 'common/ComponentAssertionMessages.dart';
import 'common/ComponentData.dart';
import 'common/WidgetBuildingComponent.dart';

/// Carries the data that might be used in [TriggerComponent.builder].
class TriggerComponentData implements ComponentData {
  /// [BuildContext] passed by [SelectionMenu].
  ///
  /// Must not be null.
  @override
  final BuildContext context;

  /// A callback that should be called when the trigger is triggered.
  /// Opens/Closes the menu associated with [SelectionMenu].
  ///
  /// Must not be null.
  final TriggerMenu triggerMenu;

  /// Must not be null.
  final TickerProvider tickerProvider;

  final MenuState? menuState;

  TriggerComponentData({
    required this.context,
    required this.triggerMenu,
    required this.tickerProvider,
    required this.selectedItem,
    required this.menuState,
  });

  @override
  final dynamic selectedItem;
}

/// Defines builder that returns a Widget that acts as a trigger.
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
///```
///
///  <img src="https://i.imgur.com/QL67eib.jpg" width="658.5" height="384"/>
///
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [TriggerComponentData]
/// * [TriggerBuilder]
class TriggerComponent implements WidgetBuildingComponent {
  /// A builder method to create the trigger Widget.
  ///
  /// See also:
  /// * [TriggerBuilder].
  TriggerBuilder? builder;

  /// See [TriggerBuilder].
  TriggerComponent({this.builder});

  /// The method uses the [TriggerComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [SelectionMenu].
  Widget build(TriggerComponentData data) {
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder!(data);
  }
}

/// This typedef defines a method that returns a Widget that acts as the trigger
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
typedef TriggerBuilder = Widget Function(TriggerComponentData data);

/// Callback to Open/Close the menu.
typedef TriggerMenu = void Function();
