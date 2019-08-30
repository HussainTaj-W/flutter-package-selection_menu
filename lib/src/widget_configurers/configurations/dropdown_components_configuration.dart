import 'dart:math';

import 'package:flutter/material.dart';
import 'package:selection_menu/src/widget_configurers/components/components.dart';
import 'package:selection_menu/src/widget_configurers/configurations/menu_configuration_classes.dart';

import 'components_configuration.dart';

/// Defines the appearance of [SelectionMenu] as a typical dropdown menu.
/// The type parameter T is the same as the type parameter for [SelectionMenu].
///
/// See [ComponentsConfiguration] for details on what each parameter of the
/// constructor and static methods mean.
class DropdownComponentsConfiguration<T> extends ComponentsConfiguration<T> {
  DropdownComponentsConfiguration({
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
    searchField: 2,
    searchBar: 3,
    searchingIndicator: 2,
  );

  static MenuSizeConfiguration defaultMenuSizeConfiguration =
      MenuSizeConfiguration(
    minHeightFraction: 0.3,
    minWidthFraction: 0.3,
    maxHeightFraction: 0.8,
    maxWidthFraction: 0.5,
  );

  static Widget searchBarBuilder(SearchBarComponentData data) {
    List<Widget> columnChildren = [];

    columnChildren.add(Flexible(
      flex: data.menuFlexValues.searchField,
      child: data.searchField,
    ));

    if (data.isSearching) {
      columnChildren.add(Flexible(
        flex: data.menuFlexValues.searchingIndicator,
        child: data.searchingIndicator,
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: columnChildren,
    );
  }

  static Widget listViewBuilder(ListViewComponentData data) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.0),
      itemBuilder: data.itemBuilder,
      itemCount: data.itemCount,
    );
  }

  static Widget animationBuilder(AnimationComponentData data) {
    return AnimatedContainer(
      color: Colors.transparent,
      curve: Curves.easeOut,
      duration: data.menuAnimationState == MenuAnimationState.OpeningEnd
          ? data.menuAnimationDurations.forward
          : data.menuAnimationDurations.reverse,
      constraints: data.menuAnimationState == MenuAnimationState.OpeningStart ||
              data.menuAnimationState == MenuAnimationState.ClosingEnd
          ? data.constraints.copyWith(maxHeight: 0, minHeight: 0)
          : data.constraints,
      child: data.child,
    );
  }

  static Widget searchFieldBuilder(SearchFieldComponentData data) {
    Color accentColor = Theme.of(data.context).accentColor;
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
          controller: data.searchTextController,
          style: Theme.of(data.context).textTheme.body1,
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
      child: Container(
        margin: EdgeInsets.only(right: 1, bottom: 1),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withAlpha(150),
                blurRadius: 3,
                offset: Offset(0, 2))
          ],
          color: Theme.of(data.context).cardTheme.color ?? Colors.white,
        ),
        padding: EdgeInsets.all(8.0),
        child: ClipRect(
          child: Column(
            children: columnChildren,
          ),
        ),
      ),
    );
  }

  static Widget triggerBuilder(TriggerComponentData data) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: Theme.of(data.context).accentColor,
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

    final Offset buttonGlobalPosition = data.triggerPositionAndSize.position;
    final Size buttonSize = data.triggerPositionAndSize.size;
    BoxConstraints constraints = data.constraints;

    double midScreenY = 0;
    if (data.menuSizeConfiguration.requestAvoidBottomInset) {
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
    if (!data.menuSizeConfiguration.requestConstantHeight) {
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
  }

  static Widget searchingIndicatorBuilder(
      SearchingIndicatorComponentData data) {
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
  }
}
