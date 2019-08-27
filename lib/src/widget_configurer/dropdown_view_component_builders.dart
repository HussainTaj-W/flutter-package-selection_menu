import 'dart:math';

import 'package:flutter/material.dart';

import 'menu_configuration_classes.dart';
import 'view_component_builders.dart';
import 'view_component_type_definitions.dart';

/// Defines the appearance of [SelectionMenu] as a typical dropdown menu.
/// The type parameter T is the same as the type parameter for [SelectionMenu].
///
/// See [ViewComponentBuilders] for details on what each parameter of the
/// constructor and static methods mean.
class DropdownViewComponentBuilders<T> extends ViewComponentBuilders<T> {
  DropdownViewComponentBuilders({
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
  }) : super(
          searchFieldBuilder: searchFieldBuilder ?? dropdownSearchFieldBuilder,
          searchingIndicatorBuilder:
              searchingIndicatorBuilder ?? dropdownSearchingIndicatorBuilder,
          menuAnimatedContainerBuilder: menuAnimatedContainerBuilder ??
              dropdownMenuAnimatedContainerBuilder,
          menuPositionAndSizeCalculator: menuPositionAndSizeCalculator ??
              dropdownMenuPositionAndSizeCalculator,
          buttonBuilder: buttonBuilder ?? dropdownButtonBuilder,
          buttonFromItemBuilder: buttonFromItemBuilder,
          menuContainerBuilder:
              menuContainerBuilder ?? dropdownMenuContainerBuilder,
          listViewBuilder: listViewBuilder ?? dropdownListViewBuilder,
          searchBarContainerBuilder:
              searchBarContainerBuilder ?? dropdownSearchBarContainerBuilder,
          menuFlexValues: menuFlexValues ?? dropdownMenuFlexValues,
          menuSizeConfiguration:
              menuSizeConfiguration ?? dropdownMenuSizeConfiguration,
        );

  static MenuFlexValues dropdownMenuFlexValues = MenuFlexValues(
    listView: 9,
    searchField: 2,
    searchBarContainer: 3,
    searchingIndicator: 2,
  );

  static MenuSizeConfiguration dropdownMenuSizeConfiguration =
      MenuSizeConfiguration(
    minHeightFraction: 0.3,
    minWidth: 0.3,
    maxHeightFraction: 0.8,
    maxWidth: 0.5,
  );

  static SearchBarContainerBuilder dropdownSearchBarContainerBuilder =
      (BuildContext context, Widget searchField, Widget indicator,
          bool isSearching, MenuFlexValues menuFlexValues) {
    List<Widget> columnChildren = [];

    columnChildren.add(Flexible(
      flex: menuFlexValues.searchField,
      child: searchField,
    ));

    if (isSearching) {
      columnChildren.add(Flexible(
        flex: menuFlexValues.searchingIndicator,
        child: indicator,
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: columnChildren,
    );
  };

  static ListViewBuilder dropdownListViewBuilder =
      (BuildContext context, ListViewItemBuilder itemBuilder, int itemCount) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.0),
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  };

  static MenuAnimatedContainerBuilder dropdownMenuAnimatedContainerBuilder = (
    BuildContext context,
    Widget child,
    MenuAnimationState menuState,
    BoxConstraints constraints,
    MenuAnimationDurations menuAnimationDurations,
  ) {
    return AnimatedContainer(
      color: Colors.transparent,
      curve: Curves.easeOut,
      duration: menuState == MenuAnimationState.OpeningEnd
          ? menuAnimationDurations.forward
          : menuAnimationDurations.backward,
      constraints: menuState == MenuAnimationState.OpeningStart ||
              menuState == MenuAnimationState.ClosingEnd
          ? constraints.copyWith(maxHeight: 0, minHeight: 0)
          : constraints,
      child: child,
    );
  };

  static SearchFieldBuilder dropdownSearchFieldBuilder =
      (BuildContext context, TextEditingController searchTextController) {
    Color accentColor = Theme.of(context).accentColor;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: accentColor.withAlpha(100),
          ),
        ),
      ),
      child: Center(
        child: TextField(
          cursorColor: accentColor,
          controller: searchTextController,
          style: Theme.of(context).textTheme.body1,
          expands: false,
          maxLines: 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search...",
            contentPadding: EdgeInsets.all(5),
          ),
        ),
      ),
    );
  };

  static MenuContainerBuilder dropdownMenuContainerBuilder =
      (BuildContext context, Widget child) {
    return Container(
      margin: EdgeInsets.only(right: 1, bottom: 1),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black.withAlpha(150),
              blurRadius: 3,
              offset: Offset(0, 2))
        ],
        color: Theme.of(context).cardTheme.color ?? Colors.white,
      ),
      padding: EdgeInsets.all(8.0),
      child: child,
    );
  };

  static ButtonBuilder dropdownButtonBuilder =
      (BuildContext context, ToggleMenu toggleDropDownMenu) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: Theme.of(context).accentColor,
      onPressed: toggleDropDownMenu,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Choose "),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  };

  static MenuPositionAndSizeCalculator dropdownMenuPositionAndSizeCalculator =
      (BuildContext context,
          BoxConstraints constraints,
          Offset buttonGlobalPosition,
          Size buttonSize,
          MenuSizeConfiguration _menuDimension) {
    MediaQueryData mqData = MediaQuery.of(context);

    double midScreenY = 0;
    if (_menuDimension.requestAvoidBottomInset) {
      // Middle of screen excluding the Insets (The area taken by keyboard).
      midScreenY = (mqData.size.height - mqData.viewInsets.bottom) / 2;
    } else {
      // Middle of the screen.
      midScreenY = mqData.size.height / 2;
    }
    // An offset that aligns button and menu to vertical center.
    double xOffset = -(constraints.maxWidth - buttonSize.width) / 2;
    // An offset that pushes the menu down, so the button is visible.
    double yOffset = buttonSize.height;

    // If constant height is not requested.
    if (!_menuDimension.requestConstantHeight) {
      // If button is in the lower half of the screen.
      if (buttonGlobalPosition.dy + buttonSize.height / 2 > midScreenY) {
        constraints = constraints
            .copyWith(
              maxHeight: min(constraints.maxHeight,
                  buttonGlobalPosition.dy - mqData.viewPadding.top),
            )
            .normalize();
      } else // the button is in the upper half of the screen.
      {
        constraints = constraints
            .copyWith(
              maxHeight: min(
                  constraints.maxHeight,
                  mqData.size.height -
                      buttonGlobalPosition.dy -
                      buttonSize.height),
            )
            .normalize();
      }
    }
    // if button is in the lower half of the screen.
    if (buttonGlobalPosition.dy + buttonSize.height / 2 > midScreenY) {
      // the offset should place the menu above the button.
      yOffset = -constraints.maxHeight;
    }

    // If offset makes the menu go out of screen bounds from left side.
    if (buttonGlobalPosition.dx + xOffset < 0) {
      xOffset = -buttonGlobalPosition.dx;
    } // If offset makes the menu go out of screen bounds from right side.
    else if (buttonGlobalPosition.dx + buttonSize.width - xOffset >
        mqData.size.width) {
      xOffset += mqData.size.width -
          (buttonGlobalPosition.dx + constraints.maxWidth + xOffset);
    }

    // If offset makes the menu go out of screen bounds from above.
    if (buttonGlobalPosition.dy + yOffset < 0) {
      yOffset = -buttonGlobalPosition.dy + mqData.viewPadding.top;
    } // If offset makes the menu go out of screen bounds from below.
    else if (buttonGlobalPosition.dy + yOffset + constraints.maxHeight >
        mqData.size.height) {
      yOffset += mqData.size.height -
          (buttonGlobalPosition.dy + constraints.maxHeight + yOffset);
    }

    return MenuPositionAndSize(
      constraints: constraints,
      positionOffset: Offset(xOffset, yOffset),
    );
  };

  static SearchingIndicatorBuilder dropdownSearchingIndicatorBuilder =
      (BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: AspectRatio(
          aspectRatio: 1,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      ),
    );
  };
}
