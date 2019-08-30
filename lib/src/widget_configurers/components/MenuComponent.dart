import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/src/widget/listview_menu.dart';
import 'package:selection_menu/src/widget_configurers/configurations/menu_configuration_classes.dart';

import 'common/ComponentAssertionMessages.dart';
import 'common/WidgetBuildingComponent.dart';

/// Carries the data that might be used in [MenuComponent.builder].
class MenuComponentData {
  /// [BuildContext] passed by [SelectionMenu] (internally by [ListViewMenu]).
  ///
  /// Must not be null.
  final BuildContext context;

  /// The search bar [Widget] built by a [SearchBarComponent.builder].
  ///
  /// Must not be null.
  final Widget searchBar;

  /// The scrollable list built by a [ListViewComponent.builder].
  ///
  /// Must not be null.
  final Widget listView;

  /// These are the flex values for [Flexible] or [Expanded] if the layout
  /// of returned Widget uses Flex to arrange the two Widgets [searchBar] and
  /// [listView].
  ///
  /// Must not be null.
  ///
  /// See also:
  /// * [MenuFlexValues].
  final MenuFlexValues menuFlexValues;

  final bool isSearchEnabled;

  MenuComponentData({
    @required this.context,
    @required this.searchBar,
    @required this.menuFlexValues,
    @required this.listView,
    @required this.isSearchEnabled,
  }) : assert(
            context != null &&
                listView != null &&
                menuFlexValues != null &&
                searchBar != null &&
                isSearchEnabled != null,
            ComponentAssertionMessages.nullAttributeInData);
}

/// Defines a Menu [Widget] builder. A Menu is any Widget that
/// wraps two Widgets [MenuComponentData.searchBar] and
/// [MenuComponentData.listView].
///
/// **Example**
///
/// ```dart
/// MenuComponent(
///   builder: (MenuComponentData data)
///   {
///     return Card(
///       child: Column(
///         children: <Widget>[
///           data.isSearchEnabled
///           ? Expanded(
///             child: data.searchBar,
///             flex: data.menuFlexValues.searchBar,
///           )
///           : Container(),// Show an nothing (empty) container when search is disabled.
///           Expanded(
///             child: data.listView,
///             flex: data.menuFlexValues.listView,
///           ),
///         ],
///       ),
///     );
///   }
/// );
/// ```
///
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [MenuComponentData]
/// * [MenuBuilder]
class MenuComponent implements WidgetBuildingComponent {
  /// A builder method to create the menu [Widget]. It combines the search bar
  /// and list view.
  ///
  /// See also:
  /// * [MenuBuilder].
  /// * [SearchBarComponent].
  /// * [ListViewComponent].
  MenuBuilder builder;

  /// See [MenuBuilder].
  MenuComponent({@required this.builder});

  /// The method uses the [MenuComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [ListViewMenu].
  Widget build(MenuComponentData data) {
    assert(
        data != null, ComponentAssertionMessages.nullDataPassedToBuildMethod);
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder(data);
  }
}

/// This typedef defines a method that returns a [Widget] that wraps
/// [MenuComponentData.searchBar] and [MenuComponentData.listView]
/// in a Widget, defining their layout.
///
/// Used by [MenuComponent] as [MenuComponent.builder].
///
/// **Example**
///
/// ```dart
/// MenuComponent(
///   builder: (MenuComponentData data)
///   {
///     return Card(
///       child: Column(
///         children: <Widget>[
///           data.isSearchEnabled
///           ? Expanded(
///             child: data.searchBar,
///             flex: data.menuFlexValues.searchBar,
///           )
///           : Container(),// Show an nothing (empty) container when search is disabled.
///           Expanded(
///             child: data.listView,
///             flex: data.menuFlexValues.listView,
///           ),
///         ],
///       ),
///     );
///   }
/// );
/// ```
///
/// See Also:
/// * [MenuComponent]
/// * [MenuComponentData]
typedef Widget MenuBuilder(MenuComponentData data);
