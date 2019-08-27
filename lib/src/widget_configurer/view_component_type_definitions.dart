import 'package:flutter/widgets.dart';

import 'menu_configuration_classes.dart';

/// Open/Close the menu.
typedef void ToggleMenu();

/// Returns a [Widget] where a user can enter text.
///
/// [context] the [BuildContext] passed by the calling method in [ListViewMenu].
/// [searchTextController] should be assigned to the [TextField.controller] or
/// [TextFormField.controller] property.
///
/// **Example**
///
/// ```dart
/// return TextField(
///   controller = searchTextController,
/// );
/// ```
///
/// The controller is assigned a listener and every time there is a change,
/// the searching process is initiated.
typedef Widget SearchFieldBuilder(
    BuildContext context, TextEditingController searchTextController);

/// Returns a [Widget] that encloses the menu content in a container.
///
/// [context] the [BuildContext] passed by the calling method in [ListViewMenu].
/// [child] the menu content - the combination of searchBar (search Field +
/// searching Indicator) and ListView.
///
/// **Example**
///
/// ```dart
/// return Card(
///   child: child,
/// );
/// ```
typedef Widget MenuContainerBuilder(BuildContext context, Widget child);

/// Returns a [Widget] that acts as the button for the menu to open/close.
///
/// [context] the [BuildContext] passed by the calling method in [DropDownListView].
/// [toggleDropDownMenu] a callback that should be called when the button
/// is pressed.
///
/// **Example**
///
/// ```dart
/// return FlatButton(
///   onPressed: toggleDropDownMenu,
///   child: Text("Click Me"),
/// );
/// ```
typedef Widget ButtonBuilder(
    BuildContext context, ToggleMenu toggleDropDownMenu);

/// Returns a [Widget] that acts as the button for the menu to open/close,
/// additionally, the content of the button reflects the current selected item
/// as defined by the function body.
///
/// <T> the type of a data item in the list provided to the [DropDownListView].
/// [context] the [BuildContext] passed by the calling method in [DropDownListView].
/// [toggleDropDownMenu] a callback that should be called when the button
/// is pressed.
/// [item] the current selected item in the [DropDownListView.itemsList].
///
/// **Example**
/// *Assume T is [String]*
///
/// ```dart
/// return FlatButton(
///   onPressed: toggleDropDownMenu,
///   child: Text(item),
/// );
/// ```
typedef Widget ButtonFromItemBuilder<T>(
    BuildContext context, ToggleMenu toggleDropDownMenu, T item);

/// Returns the [MenuPositionAndSize] for the Menu.
/// Calculates where the menu will be placed and how big it will be.
///
/// [context] the [BuildContext] passed by the calling method in [DropDownListView].
/// [constraints] processed from [MenuSizeConfiguration] passed as
/// [ViewComponentBuilders.menuSizeConfiguration] to [DropDownListView.viewComponentBuilders].
/// [buttonGlobalPosition] the position of the button from the visible top-left corner of the screen.
/// [buttonSize] the [Size] of the button.
/// [menuSizeConfiguration] the same [MenuSizeConfiguration] that was passed to
/// [DropDownListView] through [ViewComponentBuilders.menuSizeConfiguration] as
/// [DropDownListView.viewComponentBuilders].
///
/// **Example**
///
/// ```dart
/// return MenuPositionAndSize(
///   positionOffset: Offset(0.0,buttonSize.height),
///   constraints: constraints,
/// );
/// ```
typedef MenuPositionAndSize MenuPositionAndSizeCalculator(
    BuildContext context,
    BoxConstraints constraints,
    Offset buttonGlobalPosition,
    Size buttonSize,
    MenuSizeConfiguration menuSizeConfiguration);

/// Returns a [Widget] that acts as the Indicator for when search is in progress.
///
/// [context] the [BuildContext] passed by the calling method in [ListViewMenu].
///
/// **Example**
///
/// ```dart
/// return CircularProgressIndicator();
/// ```
typedef Widget SearchingIndicatorBuilder(BuildContext context);

/// Returns a [Widget] capable of implicit animation, itself or through a descendant,
/// associated with state changes of [MenuAnimationState].
///
/// [context] the [BuildContext] passed by the calling method in [DropDownListView].
/// [child] the Menu that must included in the Widget being build.
/// [menuState] state of the animation.
/// [constraints] constraints received from [MenuPositionAndSizeCalculator]
/// [menuAnimationDuration] durations of forward and backward animations.
///
/// **Example**
///
/// ```dart
/// return Opacity(
///   opacity: menuState == MenuState.OpeningEnd ? 1.0 : 0.0,
///   child: child,
/// );
/// ```
///
/// This method is invoked for all [MenuState]s except [MenuState.Closed].
typedef Widget MenuAnimatedContainerBuilder(
    BuildContext context,
    Widget child,
    MenuAnimationState menuState,
    BoxConstraints constraints,
    MenuAnimationDurations menuAnimationDurations);

/// Returns a [Widget] that corresponds to the data at [index] of the list of items
/// currently associated in the [DropDownListView].
///
/// [context] the [BuildContext] passed by the calling method in [ListViewMenu].
///
/// This function is indented to be passed as an argument to the constructor
/// [ListView.builder]. The [DropDownListView] defines this function itself.
/// It is not the same as the [DropDownListView.itemBuilder] property, which is
/// of type [ItemBuilder].
///
/// **Example**
/// *Assuming the body defining class has access to a variable listOfItems [List] of type [String].*
///
/// ```dart
/// return Text(listOfItems[index]);
/// ```
typedef Widget ListViewItemBuilder(BuildContext context, int index);

/// Returns a [ListView] (optionally wrapped in other [Widget]s) using the
/// constructors that take [IndexedWidgetBuilder] like [ListView.builder] and
/// [ListView.separated].
///
/// [context] the [BuildContext] passed by the calling method in [ListViewMenu].
/// [itemBuilder] is intended to be passed as an argument to [ListView.builder] without modifications.
/// [itemCount] is intended to be passed as an argument to [ListView.builder] without modification.
///
/// **Example**
///
/// ```dart
/// return ListView.builder(
/// itemBuilder: itemBuilder,
/// itemCount: itemCount,
/// );
/// ```
typedef Widget ListViewBuilder(
    BuildContext context, ListViewItemBuilder itemBuilder, int itemCount);

/// Returns a [Widget] that wraps [searchField] and [searchingIndicator] in a container,
/// defining their layout.
///
/// [context] the [BuildContext] passed by the calling method in [ListViewMenu].
/// [searchField] the search field built by a [SearchFieldBuilder].
/// [searchingIndicator] the searching indicator built by a [SearchingIndicatorBuilder].
/// [isSearching] tells if the menu is currently in the process of searching. This
/// parameter can be used to make decision related to [searchingIndicator], like
/// whether to show it or not.
/// [menuFlexValues] are the flex values for [Flexible] or [Expanded] if the layout
/// of returned Widget uses Flex to arrange the two Widgets [searchField] and [searchingIndicator].
///
/// See [MenuFlexValues] for more details.
///
/// **Example**
///
/// ```dart
/// return Row(
///   children: <Widget>[
///     Flexible(
///       child: searchField,
///       flex: menuFlexValues.searchField,
///     ),
///     Flexible(
///       child: isSearching ? searchingIndicator : Container(),
///       flex: menuFlexValues.searchingIndicator,
///     ),
///   ],
/// );
/// ```
typedef Widget SearchBarContainerBuilder(
  BuildContext context,
  Widget searchField,
  Widget searchingIndicator,
  bool isSearching,
  MenuFlexValues menuFlexValues,
);
