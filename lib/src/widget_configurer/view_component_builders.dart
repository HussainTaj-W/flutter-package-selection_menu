import 'package:flutter/widgets.dart';

import 'menu_configuration_classes.dart';
import 'view_component_type_definitions.dart';

/// A base class that define the appearance of [SelectionMenu], where type
/// parameter T is the same as the type parameter of [SelectionMenu].
///
/// A Builder can be a method that returns a Widget, or Position and Size information,
/// or simply a class that contains data related to layout.
/// In any case, everything is an instance variable, even methods
/// (you can say these variables are Function Pointers or Delegates or Callbacks).
///
/// This class can be subclassed. The subclass would assign values to the instance
/// variables.
/// The subclasses can then be passed to [SelectionMenu.viewComponentBuilders].
///
/// Two predefined subclasses are:
/// * [DialogViewComponentBuilders] a dialog or popup style appearance.
/// * [DropdownViewComponentBuilders] a dropdown style appearance.
///
/// ## Terms to Know
/// In the context of this library the following visual component are described as:
///
/// * SearchField: Any [Widget] that allows text editing.
/// * SearchingIndicator: Any [Widget] that indicates that search is in progress.
/// * SearchBar: Any [Widget] that combines the SearchField and SearchingIndicator.
/// * ListView: Any [Widget] that incorporates a [ListView], the list of items.
/// * Menu or MenuContainer: Any [Widget] that lays out and/or wraps SearchBar and ListView.
/// * AnimatedContainer: Any [Widget] that provides implicit animation(s) for Menu.
/// * Button: Any [Widget] that, when pressed, opens or closes the Menu.
class ViewComponentBuilders<T> {
  /// Returns a [Widget] where a user can input text.
  ///
  /// See [SearchFieldBuilder] for more details.
  final SearchFieldBuilder searchFieldBuilder;

  /// Returns a [Widget] that wraps menu content (which are search field, searching indicator and
  /// listView).
  ///
  /// See [MenuContainerBuilder] for more details.
  final MenuContainerBuilder menuContainerBuilder;

  /// Returns a [Widget] that acts as a button to open/close menu.
  ///
  /// See [ButtonBuilder] for more details.
  final ButtonBuilder buttonBuilder;

  /// Returns a [Widget] that acts as a button to open/close menu, where the button
  /// reflects the currently selected item.
  ///
  /// See [ButtonFromItemBuilder] for more details.
  final ButtonFromItemBuilder<T> buttonFromItemBuilder;

  /// Returns a [MenuSizeAndPosition] after performing some calculation.
  ///
  /// See [MenuPositionAndSizeCalculator] for more details.
  final MenuPositionAndSizeCalculator menuPositionAndSizeCalculator;

  /// Returns a [Widget] that acts as an Indicator for when search is in progress.
  ///
  /// See [SearchingIndicatorBuilder] for more details.
  final SearchingIndicatorBuilder searchingIndicatorBuilder;

  /// Returns a [Widget] that supports implicit animations through itself
  /// or through its descendants.
  ///
  /// See [MenuAnimatedContainerBuilder] for more details.
  final MenuAnimatedContainerBuilder menuAnimatedContainerBuilder;

  /// Returns a [ListView] using a constructor that takes a [IndexedWidgetBuilder].
  ///
  /// See [ListViewBuilder] for more details.
  final ListViewBuilder listViewBuilder;

  /// Returns a [Widget] that wraps a search field and and searching indicator.
  ///
  /// See [SearchBarContainerBuilder] for more details.
  final SearchBarContainerBuilder searchBarContainerBuilder;

  /// Defines flex values for various view components ([Widget]s).
  ///
  /// See [MenuFlexValues] for more details.
  final MenuFlexValues menuFlexValues;

  /// Defines the size and behaviour of size in various conditions.
  ///
  /// See [MenuSizeConfiguration] for more details.
  final MenuSizeConfiguration menuSizeConfiguration;

  ViewComponentBuilders({
    @required this.searchFieldBuilder,
    @required this.menuContainerBuilder,
    @required this.buttonBuilder,
    this.buttonFromItemBuilder,
    @required this.menuPositionAndSizeCalculator,
    @required this.searchingIndicatorBuilder,
    @required this.menuAnimatedContainerBuilder,
    @required this.listViewBuilder,
    @required this.searchBarContainerBuilder,
    @required this.menuFlexValues,
    @required this.menuSizeConfiguration,
  }) : assert(
            searchFieldBuilder != null &&
                menuContainerBuilder != null &&
                buttonBuilder != null &&
                menuPositionAndSizeCalculator != null &&
                searchingIndicatorBuilder != null &&
                menuAnimatedContainerBuilder != null &&
                listViewBuilder != null &&
                searchBarContainerBuilder != null &&
                menuFlexValues != null &&
                menuSizeConfiguration != null,
            """All builders and configurations are required. (except one 'dropDownButtonBuilderFromItem'). 
            If you wish to customize only a few builders, 
            pick a Builders class like DefaultComponentBuilders and provide those sepecific builders. 
            Furthermore, if you wish to pick several builders 
            from different Builder Classes, use the copyWith function.""");

  /// Returns a [ViewComponentBuilders] constructed from the values of this, overwritten
  /// by the non-null arguments passed to the method.
  ViewComponentBuilders<T> copyWith({
    SearchFieldBuilder searchFieldBuilder,
    ButtonBuilder buttonBuilder,
    MenuContainerBuilder menuContainerBuilder,
    MenuPositionAndSizeCalculator menuPositionAndSizeCalculator,
    ButtonFromItemBuilder<T> buttonFromItemBuilder,
    SearchingIndicatorBuilder searchingIndicatorBuilder,
    MenuAnimatedContainerBuilder menuAnimatedContainerBuilder,
    ListViewBuilder listViewBuilder,
    SearchBarContainerBuilder searchBarContainerBuilder,
    MenuFlexValues menuFlexValues,
    MenuSizeConfiguration menuSizeConfiguration,
  }) {
    return ViewComponentBuilders<T>(
      buttonBuilder: buttonBuilder ?? this.buttonBuilder,
      buttonFromItemBuilder:
          buttonFromItemBuilder ?? this.buttonFromItemBuilder,
      menuContainerBuilder: menuContainerBuilder ?? this.menuContainerBuilder,
      menuPositionAndSizeCalculator:
          menuPositionAndSizeCalculator ?? this.menuPositionAndSizeCalculator,
      searchFieldBuilder: searchFieldBuilder ?? this.searchFieldBuilder,
      searchingIndicatorBuilder:
          searchingIndicatorBuilder ?? this.searchingIndicatorBuilder,
      menuAnimatedContainerBuilder:
          menuAnimatedContainerBuilder ?? this.menuAnimatedContainerBuilder,
      listViewBuilder: listViewBuilder ?? this.listViewBuilder,
      searchBarContainerBuilder:
          searchBarContainerBuilder ?? this.searchBarContainerBuilder,
      menuFlexValues: menuFlexValues ?? this.menuFlexValues,
      menuSizeConfiguration:
          menuSizeConfiguration ?? this.menuSizeConfiguration,
    );
  }
}
