import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/src/widget_configurers/menu_configuration_classes.dart';

import 'common/ComponentAssertionMessages.dart';
import 'common/ComponentData.dart';
import 'common/WidgetBuildingComponent.dart';

/// Carries the data that might be used in [SearchBarComponent.builder].
class SearchBarComponentData implements ComponentData {
  /// [BuildContext] passed by [SelectionMenu] (internally by [ListViewMenu]).
  ///
  /// Must not be null.
  @override
  final BuildContext context;

  /// The search field built by a [SearchBarComponent.builder].
  ///
  /// Must not be null.
  final Widget searchField;

  /// The searching indicator built by a [SearchingIndicatorComponent.builder].
  ///
  /// Must not be null.
  final Widget searchingIndicator;

  /// Tells if the [ListViewMenu] is currently in the process of searching.
  /// This variable can be used to make decision related to [searchingIndicator],
  /// like whether to show it or not.
  ///
  /// Must not be null.
  final bool? isSearching;

  /// These are the flex values for [Flexible] or [Expanded] if the layout
  /// of returned Widget uses Flex to arrange the two Widgets [searchField] and
  /// [searchingIndicator].
  ///
  /// Must not be null.
  ///
  /// See also:
  /// * [MenuFlexValues].
  final MenuFlexValues menuFlexValues;

  /// Must not be null.
  final TickerProvider tickerProvider;

  SearchBarComponentData({
    required this.context,
    required this.searchField,
    required this.isSearching,
    required this.menuFlexValues,
    required this.searchingIndicator,
    required this.tickerProvider,
    required this.selectedItem,
  });

  @override
  final dynamic selectedItem;
}

/// Defines a Search Bar Widget builder. A Search Bar is any Widget that
/// wraps two Widgets [SearchBarComponentData.searchField] and
/// [SearchBarComponentData.searchingIndicator].
///
/// **Example**
///
/// ```dart
/// SearchBarComponent(
///   builder: (SearchBarComponentData data)
///   {
///     return Row(
///       children: <Widget>[
///         Flexible(
///           child: data.searchField,
///           flex: data.menuFlexValues.searchField,
///         ),
///         Flexible(
///           child: data.isSearching ? data.searchingIndicator : Container(),
///           flex: data.menuFlexValues.searchingIndicator,
///         ),
///       ],
///     );
///   }
/// );
/// ```
///
///  <img src="https://i.imgur.com/QL67eib.jpg" width="658.5" height="384"/>
///
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [SearchBarComponentData]
/// * [SearchBarBuilder]
class SearchBarComponent implements WidgetBuildingComponent {
  /// A builder method to create the Search Bar Widget.
  ///
  /// See also:
  /// * [SearchBarBuilder].
  SearchBarBuilder? builder;

  /// See [SearchBarBuilder].
  SearchBarComponent({this.builder});

  /// The method uses the [SearchBarComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [ListViewMenu].
  Widget build(SearchBarComponentData data) {
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder!(data);
  }
}

/// This typedef defines a method that returns a Widget that wraps
/// [SearchBarComponentData.searchField] and [SearchBarComponentData.searchingIndicator]
/// in a Widget, defining their layout.
///
/// Used by [SearchBarComponent] as [SearchBarComponent.builder].
///
/// **Example**
///
/// ```dart
/// SearchBarComponent(
///   builder: (SearchBarComponentData data)
///   {
///     return Row(
///       children: <Widget>[
///         Flexible(
///           child: data.searchField,
///           flex: data.menuFlexValues.searchField,
///         ),
///         Flexible(
///           child: data.isSearching ? data.searchingIndicator : Container(),
///           flex: data.menuFlexValues.searchingIndicator,
///         ),
///       ],
///     );
///   }
/// );
/// ```
///
/// See Also:
/// * [SearchBarComponent]
/// * [SearchBarComponentData]
typedef SearchBarBuilder = Widget Function(SearchBarComponentData data);
