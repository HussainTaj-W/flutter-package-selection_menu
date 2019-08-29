import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'dropdown_view_component_builders.dart';
import 'menu_configuration_classes.dart';
import 'view_component_builders.dart';
import 'view_component_type_definitions.dart';

/// Defines the appearance of [DropDownListView] as a popup dialog menu.
/// The type parameter T is the same as the type parameter for [DropDownListView].
///
/// See [ViewComponentBuilders] for details on what each parameter of the
/// constructor and static method means.
class DialogViewComponentBuilders<T> extends ViewComponentBuilders<T> {
  DialogViewComponentBuilders({
    SearchFieldBuilder searchFieldBuilder,
    ButtonBuilder buttonBuilder,
    MenuContainerBuilder menuContainerBuilder,
    MenuPositionAndSizeCalculator menuPositionAndSizeCalculator,
    ButtonFromItemBuilder<T> buttonFromItemBuilder,
    SearchingIndicatorBuilder searchingIndicatorBuilder,
    MenuAnimatedContainerBuilder menuAnimatedContainerBuilder,
    ListViewBuilder listViewBuilder,
    SearchBarBuilder searchBarBuilder,
    MenuFlexValues menuFlexValues,
    MenuSizeConfiguration menuSizeConfiguration,
  }) : super(
          searchFieldBuilder: searchFieldBuilder ?? dialogSearchFieldBuilder,
          searchingIndicatorBuilder:
              searchingIndicatorBuilder ?? dialogSearchingIndicatorBuilder,
          menuAnimatedContainerBuilder: menuAnimatedContainerBuilder ??
              dialogMenuAnimatedContainerBuilder,
          menuPositionAndSizeCalculator: menuPositionAndSizeCalculator ??
              dialogMenuPositionAndSizeCalculator,
          buttonBuilder: buttonBuilder ?? dialogButtonBuilder,
          buttonFromItemBuilder: buttonFromItemBuilder,
          menuContainerBuilder:
              menuContainerBuilder ?? dialogMenuContainerBuilder,
          listViewBuilder: listViewBuilder ?? dialogListViewBuilder,
          searchBarBuilder: searchBarBuilder ?? dialogSearchBarBuilder,
          menuFlexValues: menuFlexValues ?? dialogMenuFlexValues,
          menuSizeConfiguration:
              menuSizeConfiguration ?? dialogMenuSizeConfiguration,
        );

  static MenuFlexValues dialogMenuFlexValues = MenuFlexValues(
    listView: 9,
    searchField: 5,
    searchBar: 2,
    searchingIndicator: 1,
  );

  static MenuSizeConfiguration dialogMenuSizeConfiguration =
      MenuSizeConfiguration(
    maxWidthFraction: 0.8,
    maxHeightFraction: 0.8,
    minHeightFraction: 0.5,
    minWidthFraction: 0.5,
  );

  static ListViewBuilder dialogListViewBuilder =
      DropdownViewComponentBuilders.dropdownListViewBuilder;

  static SearchBarBuilder dialogSearchBarBuilder = (BuildContext context,
      Widget searchField,
      Widget indicator,
      bool isSearching,
      MenuFlexValues menuFlexValues) {
    List<Widget> rowChildren = [];

    rowChildren.add(Flexible(
      child: Icon(
        Icons.search,
        color: Theme.of(context).accentColor,
        size: Theme.of(context).textTheme.body1.fontSize,
      ),
    ));

    rowChildren.add(Flexible(
      flex: menuFlexValues.searchField,
      child: searchField,
    ));

    rowChildren.add(Flexible(
      flex: menuFlexValues.searchingIndicator,
      child: Opacity(
        child: indicator,
        opacity: isSearching ? 1 : 0,
      ),
    ));
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(
              color: Theme.of(context).accentColor,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowChildren,
        ),
      ),
    );
  };

  static MenuAnimatedContainerBuilder dialogMenuAnimatedContainerBuilder = (
    BuildContext context,
    Widget child,
    MenuAnimationState menuState,
    BoxConstraints constraints,
    MenuAnimationDurations menuAnimationDurations,
  ) {
    Matrix4 fromTween = Matrix4.translationValues(
        constraints.maxWidth / 2, constraints.maxHeight / 2, 0.0)
      ..scale(0.1);

    Matrix4 toTween = Matrix4.translationValues(0, 0, 0)..scale(1.0);

    return Container(
      child: AnimatedContainer(
        color: Colors.transparent,
        curve: menuState == MenuAnimationState.OpeningStart ||
                menuState == MenuAnimationState.ClosingEnd
            ? Curves.elasticIn
            : Curves.elasticOut,
        transform: menuState == MenuAnimationState.OpeningStart ||
                menuState == MenuAnimationState.ClosingEnd
            ? fromTween
            : toTween,
        duration: menuState == MenuAnimationState.OpeningEnd
            ? menuAnimationDurations.forward
            : menuAnimationDurations.backward,
        child: child,
      ),
      constraints: constraints,
    );
  };

  static SearchFieldBuilder dialogSearchFieldBuilder =
      (BuildContext context, TextEditingController searchTextController) {
    return TextField(
      cursorColor: Theme.of(context).accentColor,
      controller: searchTextController,
      expands: false,
      maxLines: 1,
      textAlignVertical: TextAlignVertical.bottom,
      style: Theme.of(context).textTheme.body1.copyWith(),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Search...",
        contentPadding: EdgeInsets.all(5),
      ),
    );
  };

  static MenuContainerBuilder dialogMenuContainerBuilder =
      (BuildContext context, Widget child) {
    return Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ));
  };

  static ButtonBuilder dialogButtonBuilder =
      (BuildContext context, ToggleMenu toggleMenu) {
    return RaisedButton(
      onPressed: toggleMenu,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Choose "),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  };

  static MenuPositionAndSizeCalculator dialogMenuPositionAndSizeCalculator =
      (BuildContext context,
          BoxConstraints constraints,
          Offset buttonGlobalPosition,
          Size buttonSize,
          MenuSizeConfiguration _menuDimension) {
    MediaQueryData mqData = MediaQuery.of(context);

    // Available Height for the menu to be shown in.
    double height = 0;

    if (_menuDimension.requestAvoidBottomInset) {
      height = mqData.size.height -
          mqData.viewPadding.top -
          mqData.viewInsets.bottom;
    } else {
      height = mqData.size.height - mqData.viewPadding.top;
    }

    if (height < constraints.maxHeight) {
      constraints = constraints.copyWith(maxHeight: height).normalize();
    }
    if (mqData.size.width < constraints.maxWidth) {
      constraints =
          constraints.copyWith(maxWidth: mqData.size.width).normalize();
    }

    // Position from left of screen where the menu should start.
    double startX = (mqData.size.width - constraints.biggest.width) / 2;

    // Position from top of screen where the menu should start.
    double startY = (height - constraints.biggest.height) / 2;

    if (startY < 0) startY = 0;

    // Avoid Status bar.
    startY += mqData.viewPadding.top;

    return MenuPositionAndSize(
      positionOffset: Offset(
        startX - buttonGlobalPosition.dx,
        startY - buttonGlobalPosition.dy,
      ),
      constraints: constraints,
    );
  };

  static SearchingIndicatorBuilder dialogSearchingIndicatorBuilder =
      (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: AspectRatio(
        aspectRatio: 1,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  };
}
