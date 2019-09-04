import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';

import 'common/ComponentAssertionMessages.dart';
import 'common/ComponentData.dart';
import 'common/WidgetBuildingComponent.dart';
import 'components.dart';

/// Carries the data that might be used in [TriggerFromItemComponent.builder].
///
/// <T> type parameter is the type of data stored as [TriggerFromItemComponentData.item].
class TriggerFromItemComponentData<T> implements ComponentData {
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
  final T item;

  /// Must not be null.
  final TickerProvider tickerProvider;

  final MenuState menuState;

  TriggerFromItemComponentData({
    @required this.context,
    @required this.triggerMenu,
    @required this.item,
    @required this.tickerProvider,
    @required this.selectedItem,
    @required this.menuState,
  }) : assert(
            context != null &&
                triggerMenu != null &&
                item != null &&
                tickerProvider != null &&
                menuState != null,
            ComponentAssertionMessages.nullAttributeInData);
  @override
  final dynamic selectedItem;
}

/// Defines a Widget that acts like a button. Additionally, the button reflects
/// the content provided as [TriggerFromItemComponentData.item].
///
/// **Example**
///
/// ```dart
/// TriggerFromItemComponent<String>(
///   builder: (TriggerFromItemComponentData<String> data)
///   {
///     return FlatButton(
///       onPressed: data.toggleDropDownMenu,
///       child: Text(data.item),
///     );
///   }
/// );
/// ```
///
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [TriggerFromItemComponentData]
/// * [TriggerFromItemBuilder]
class TriggerFromItemComponent<T> implements WidgetBuildingComponent {
  /// A builder method to create a Widget that acts as a trigger. Additionally,
  /// reflects the content of [TriggerFromItemComponentData.item].
  ///
  /// See also:
  /// * [TriggerFromItemBuilder].
  TriggerFromItemBuilder<T> builder;

  /// See [TriggerFromItemBuilder].
  TriggerFromItemComponent({@required this.builder});

  /// The method uses the [TriggerFromItemComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [SelectionMenu].
  Widget build(TriggerFromItemComponentData<T> data) {
    assert(
        data != null, ComponentAssertionMessages.nullDataPassedToBuildMethod);
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder(data);
  }
}

/// This typedef defines a method that returns a Widget that acts as a trigger
/// for the menu to open/close, additionally, the content of the button reflects
/// a [TriggerFromItemComponentData.item] as defined by the function body.
///
/// Used by [TriggerFromItemComponent] as [TriggerFromItemComponent.builder].
///
/// **Example**
///
/// ```dart
/// TriggerFromItemComponent<String>(
///   builder: (TriggerFromItemComponentData<String> data)
///   {
///     return FlatButton(
///       onPressed: data.toggleDropDownMenu,
///       child: Text(data.item),
///     );
///   }
/// );
/// ```
///
/// See Also:
/// * [TriggerFromItemComponent]
/// * [TriggerFromItemComponentData]
typedef Widget TriggerFromItemBuilder<T>(TriggerFromItemComponentData<T> data);
