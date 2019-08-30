import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:selection_menu/src/widget_configurers/components/components.dart';
import 'package:selection_menu/src/widget_configurers/configurations/menu_configuration_classes.dart';

import 'components_configuration.dart';
import 'dropdown_components_configuration.dart';

/// Defines the appearance of [DropDownListView] as a popup dialog menu.
/// The type parameter T is the same as the type parameter for [DropDownListView].
///
/// See [ComponentsConfiguration] for details on what each parameter of the
/// constructor and static method means.
class DialogComponentsConfiguration<T> extends ComponentsConfiguration<T> {
  DialogComponentsConfiguration({
    SearchFieldComponent searchFieldComponent,
    TriggerComponent triggerComponent,
    MenuComponent menuComponent,
    MenuPositionAndSizeComponent menuPositionAndSizeComponent,
    SearchingIndicatorComponent searchingIndicatorComponent,
    AnimationComponent animationComponent,
    ListViewComponent listViewComponent,
    SearchBarComponent searchBarComponent,
    //
    TriggerFromItemComponent<T> triggerFromItemComponent,
    //
    MenuFlexValues menuFlexValues,
    MenuSizeConfiguration menuSizeConfiguration,
  }) : super(
          searchFieldComponent: searchFieldComponent ??
              SearchFieldComponent(builder: searchFieldBuilder),
          //
          searchingIndicatorComponent: searchingIndicatorComponent ??
              SearchingIndicatorComponent(builder: searchingIndicatorBuilder),
          //
          animationComponent: animationComponent ??
              AnimationComponent(builder: animationBuilder),
          //
          menuPositionAndSizeComponent: menuPositionAndSizeComponent ??
              MenuPositionAndSizeComponent(builder: menuPositionAndSizeBuilder),
          //
          triggerComponent:
              triggerComponent ?? TriggerComponent(builder: triggerBuilder),
          //
          menuComponent: menuComponent ?? MenuComponent(builder: menuBuilder),
          //
          listViewComponent:
              listViewComponent ?? ListViewComponent(builder: listViewBuilder),
          //
          searchBarComponent: searchBarComponent ??
              SearchBarComponent(builder: searchBarBuilder),
          //
          triggerFromItemComponent: triggerFromItemComponent,
          //
          menuFlexValues: menuFlexValues ?? defaultMenuFlexValues,
          //
          menuSizeConfiguration:
              menuSizeConfiguration ?? defaultMenuSizeConfiguration,
        );

  static MenuFlexValues defaultMenuFlexValues = MenuFlexValues(
    listView: 9,
    searchField: 5,
    searchBar: 2,
    searchingIndicator: 1,
  );

  static MenuSizeConfiguration defaultMenuSizeConfiguration =
      MenuSizeConfiguration(
    maxWidthFraction: 0.8,
    maxHeightFraction: 0.8,
    minHeightFraction: 0.5,
    minWidthFraction: 0.5,
  );

  static ListViewBuilder listViewBuilder =
      DropdownComponentsConfiguration.listViewBuilder;

  static Widget searchBarBuilder(SearchBarComponentData data) {
    List<Widget> rowChildren = [];

    rowChildren.add(Flexible(
      child: Icon(
        Icons.search,
        color: Theme.of(data.context).accentColor,
        size: Theme.of(data.context).textTheme.body1.fontSize,
      ),
    ));

    rowChildren.add(Flexible(
      flex: data.menuFlexValues.searchField,
      child: data.searchField,
    ));

    rowChildren.add(Flexible(
      flex: data.menuFlexValues.searchingIndicator,
      child: Opacity(
        child: data.searchingIndicator,
        opacity: data.isSearching ? 1 : 0,
      ),
    ));
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(
              color: Theme.of(data.context).accentColor,
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
  }

  static Widget animationBuilder(AnimationComponentData data) {
    Matrix4 fromTween = Matrix4.translationValues(
        data.constraints.maxWidth / 2, data.constraints.maxHeight / 2, 0.0)
      ..scale(0.1);

    Matrix4 toTween = Matrix4.translationValues(0, 0, 0)..scale(1.0);

    return Container(
      child: AnimatedContainer(
        color: Colors.transparent,
        curve: data.menuAnimationState == MenuAnimationState.OpeningStart ||
                data.menuAnimationState == MenuAnimationState.ClosingEnd
            ? Curves.elasticIn
            : Curves.elasticOut,
        transform: data.menuAnimationState == MenuAnimationState.OpeningStart ||
                data.menuAnimationState == MenuAnimationState.ClosingEnd
            ? fromTween
            : toTween,
        duration: data.menuAnimationState == MenuAnimationState.OpeningEnd
            ? data.menuAnimationDurations.forward
            : data.menuAnimationDurations.reverse,
        child: data.child,
      ),
      constraints: data.constraints,
    );
  }

  static Widget searchFieldBuilder(SearchFieldComponentData data) {
    return TextField(
      cursorColor: Theme.of(data.context).accentColor,
      controller: data.searchTextController,
      expands: false,
      maxLines: 1,
      textAlignVertical: TextAlignVertical.bottom,
      style: Theme.of(data.context).textTheme.body1.copyWith(),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Search...",
        contentPadding: EdgeInsets.all(5),
      ),
    );
  }

  static Widget menuBuilder(MenuComponentData data) {
    List<Widget> columnChildren = [];

    if (data.isSearchEnabled) {
      columnChildren.add(
        Expanded(
          flex: data.menuFlexValues.searchBar,
          child: data.searchBar,
        ),
      );
    }

    columnChildren.add(
      Expanded(
        flex: data.menuFlexValues.listView,
        child: data.listView,
      ),
    );

    return Material(
      color: Colors.transparent,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRect(
            child: Column(
              children: columnChildren,
            ),
          ),
        ),
      ),
    );
  }

  static Widget triggerBuilder(TriggerComponentData data) {
    return RaisedButton(
      onPressed: data.toggleMenu,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Choose "),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  static MenuPositionAndSize menuPositionAndSizeBuilder(
      MenuPositionAndSizeComponentData data) {
    MediaQueryData mqData = MediaQuery.of(data.context);

    BoxConstraints constraints = data.constraints;

    // Available Height for the menu to be shown in.
    double height = 0;

    if (data.menuSizeConfiguration.requestAvoidBottomInset) {
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
        startX - data.triggerPositionAndSize.position.dx,
        startY - data.triggerPositionAndSize.position.dy,
      ),
      constraints: constraints,
    );
  }

  static Widget searchingIndicatorBuilder(
      SearchingIndicatorComponentData data) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: AspectRatio(
        aspectRatio: 1,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
