import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';

import 'common/ComponentAssertionMessages.dart';
import 'common/WidgetBuildingComponent.dart';

/// Carries the data that might be used in [SearchFieldComponent.builder].
class SearchFieldComponentData {
  /// [BuildContext] passed by [SelectionMenu] (internally by [ListViewMenu]).
  ///
  /// Must not be null.
  final BuildContext context;

  /// The controller is assigned a listener and every time there is a change,
  /// the searching process is initiated by [ListViewMenu].
  ///
  /// [searchTextController] should be assigned to the [TextField.controller] or
  /// [TextFormField.controller] property.
  ///
  /// Must not be null.
  final TextEditingController searchTextController;

  SearchFieldComponentData({
    @required this.context,
    @required this.searchTextController,
  }) : assert(context != null && searchTextController != null,
            ComponentAssertionMessages.nullAttributeInData);
}

/// Defines a Search Field [Widget] builder. A Search Field is any Widget that
/// allows to edit text.
///
/// **Example**
///
/// ```dart
/// SearchFieldComponent(
///   builder: (SearchFieldComponentData data)
///   {
///     return TextField(
///       controller = data.searchTextController,
///     );
///   }
/// );
/// ```
///
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [SearchFieldComponentData]
/// * [SearchFieldBuilder]
class SearchFieldComponent implements WidgetBuildingComponent {
  /// A builder method to create the Search Field [Widget]. A search field
  /// is any [Widget] that allows editing text.
  ///
  /// See also:
  /// * [SearchFieldBuilder].
  SearchFieldBuilder builder;

  /// See [SearchFieldBuilder].
  SearchFieldComponent({@required this.builder});

  /// The method uses the [SearchFieldComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [ListViewMenu].
  Widget build(SearchFieldComponentData data) {
    assert(
        data != null, ComponentAssertionMessages.nullDataPassedToBuildMethod);
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder(data);
  }
}

/// This typedef defines a method that returns a [Widget] where a user can enter
/// text.
///
/// Used by [SearchFieldComponent] as [SearchFieldComponent.builder].
///
/// **Example**
///
/// ```dart
/// SearchFieldComponent(
///   builder: (SearchFieldComponentData data)
///   {
///     return TextField(
///       controller = data.searchTextController,
///     );
///   }
/// );
/// ```
///
/// See Also:
/// * [SearchFieldComponent]
/// * [SearchFieldComponentData]
typedef Widget SearchFieldBuilder(SearchFieldComponentData data);
