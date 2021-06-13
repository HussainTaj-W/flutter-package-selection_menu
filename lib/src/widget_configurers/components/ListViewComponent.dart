import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';

import 'common/ComponentAssertionMessages.dart';
import 'common/ComponentData.dart';
import 'common/WidgetBuildingComponent.dart';

/// Carries the data that might be used in [ListViewComponent.builder].
class ListViewComponentData implements ComponentData {
  /// [BuildContext] passed by [SelectionMenu] (internally by [ListViewMenu]).
  ///
  /// Must not be null.
  @override
  final BuildContext context;

  /// Must not be null.
  ///
  /// See [IndexedWidgetBuilder].
  final IndexedWidgetBuilder itemBuilder;

  /// Count of items that the list constructed by [ListViewComponent.builder]
  /// will hold.
  ///
  /// Must not be null.
  final int itemCount;

  /// Must not be null.
  final TickerProvider tickerProvider;

  ListViewComponentData({
    required this.context,
    required this.itemBuilder,
    required this.tickerProvider,
    required this.itemCount,
    required this.selectedItem,
  });

  @override
  final dynamic selectedItem;
}

/// Defines a Widget builder that returns a Widget that acts as a scrollable
/// list populated by [ListViewComponentData.itemBuilder].
///
/// **Example**
///
/// ```dart
/// ListViewComponent(
///   builder: (ListViewComponentData data)
///   {
///     return ListView.builder(
///     itemBuilder: data.itemBuilder,
///     itemCount: data.itemCount,
///   }
/// );
/// ```
///
/// <img src="https://i.imgur.com/QL67eib.jpg" width="658.5" height="384"/>
///
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [ListViewComponentData]
/// * [ListViewBuilder]
class ListViewComponent implements WidgetBuildingComponent {
  /// A builder method to create the Widget that acts as a scrollable list,
  /// populated by [ListViewComponentData.itemBuilder].
  ///
  /// See also:
  /// * [ListViewBuilder].
  ListViewBuilder? builder;

  /// See [ListViewBuilder].
  ListViewComponent({this.builder});

  /// The method uses the [ListViewComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [SelectionMenu].
  Widget build(ListViewComponentData data) {
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder!(data);
  }
}

/// This typedef defines a method that returns a Widget that acts as a scrollable
/// list. This list is populated by [ListViewComponentData.itemBuilder].
///
/// Used by [ListViewComponent] as [ListViewComponent.builder].
///
/// **Example**
///
/// ```dart
/// ListViewComponent(
///   builder: (ListViewComponentData data)
///   {
///     return ListView.builder(
///     itemBuilder: data.itemBuilder,
///     itemCount: data.itemCount,
///   }
/// );
/// ```
///
/// See Also:
/// * [ListViewComponent]
/// * [ListViewComponentData]
typedef ListViewBuilder = Widget Function(ListViewComponentData data);
