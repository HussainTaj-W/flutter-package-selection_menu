import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';

import 'common/ComponentAssertionMessages.dart';
import 'common/WidgetBuildingComponent.dart';

/// Carries the data that might be used in [ListViewComponent.builder].
class ListViewComponentData {
  /// [BuildContext] passed by [SelectionMenu] (internally by [ListViewMenu]).
  ///
  /// Must not be null.
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

  ListViewComponentData({
    @required this.context,
    @required this.itemBuilder,
    @required this.itemCount,
  }) : assert(context != null && itemBuilder != null && itemCount != null,
            ComponentAssertionMessages.nullAttributeInData);
}

/// Defines a [Widget] builder that returns a [Widget] that acts as a scrollable
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
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [ListViewComponentData]
/// * [ListViewBuilder]
class ListViewComponent implements WidgetBuildingComponent {
  /// A builder method to create the [Widget] that acts as a scrollable list,
  /// populated by [ListViewComponentData.itemBuilder].
  ///
  /// See also:
  /// * [ListViewBuilder].
  ListViewBuilder builder;

  /// See [ListViewBuilder].
  ListViewComponent({@required this.builder});

  /// The method uses the [ListViewComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [SelectionMenu].
  Widget build(ListViewComponentData data) {
    assert(
        data != null, ComponentAssertionMessages.nullDataPassedToBuildMethod);
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder(data);
  }
}

/// This typedef defines a method that returns a [Widget] that acts as a scrollable
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
typedef Widget ListViewBuilder(ListViewComponentData data);
