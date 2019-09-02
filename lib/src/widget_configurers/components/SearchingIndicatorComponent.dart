import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';

import 'common/ComponentAssertionMessages.dart';
import 'common/ComponentData.dart';
import 'common/WidgetBuildingComponent.dart';

/// Carries the data that might be used in [SearchingIndicatorComponent.builder].
class SearchingIndicatorComponentData implements ComponentData {
  /// [BuildContext] passed by [SelectionMenu] (internally by [ListViewMenu]).
  ///
  /// Must not be null.
  @override
  final BuildContext context;

  /// Must not be null.
  final isSearching;

  /// Must not be null.
  final TickerProvider tickerProvider;

  SearchingIndicatorComponentData({
    @required this.context,
    @required this.isSearching,
    @required this.tickerProvider,
    @required this.selectedItem,
  }) : assert(context != null && isSearching != null && tickerProvider != null,
            ComponentAssertionMessages.nullAttributeInData);
  @override
  final dynamic selectedItem;
}

/// Defines a Searching Indicator Widget builder. A Searching Indicator
/// is any Widget that will be shown when the search in progress has to be shown.
///
/// **Example**
///
/// ```dart
/// SearchingIndicatorComponent(
///   builder: (SearchingIndicatorComponentData data)
///   {
///     return CircularProgressIndicator();
///   }
/// );
/// ```
///
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [SearchingIndicatorComponentData]
/// * [SearchingIndicatorBuilder]
class SearchingIndicatorComponent implements WidgetBuildingComponent {
  /// A builder method to create the Searching Indicator Widget.
  ///
  /// See also:
  /// * [SearchingIndicatorBuilder].
  SearchingIndicatorBuilder builder;

  /// See [SearchingIndicatorBuilder].
  SearchingIndicatorComponent({@required this.builder});

  /// The method uses the [SearchingIndicatorComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [ListViewMenu].
  Widget build(SearchingIndicatorComponentData data) {
    assert(
        data != null, ComponentAssertionMessages.nullDataPassedToBuildMethod);
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder(data);
  }
}

/// This typedef defines a method that returns a Widget that acts as the
/// Indicator for when search is in progress.
///
/// Used by [SearchingIndicatorComponent] as [SearchingIndicatorComponent.builder].
///
/// **Example**
///
/// ```dart
/// SearchingIndicatorComponent(
///   builder: (SearchingIndicatorComponentData data)
///   {
///     return CircularProgressIndicator();
///   }
/// );
/// ```
///
/// See Also:
/// * [SearchingIndicatorComponent]
/// * [SearchingIndicatorComponentData]
typedef Widget SearchingIndicatorBuilder(SearchingIndicatorComponentData data);
