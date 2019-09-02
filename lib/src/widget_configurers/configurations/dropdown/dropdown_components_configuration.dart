import 'dart:math';

import 'package:flutter/material.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/src/widget_configurers/components/components.dart';
import 'package:selection_menu/src/widget_configurers/menu_configuration_classes.dart';

import '../components_configuration.dart';

/// Defines the appearance of [SelectionMenu] as a typical dropdown menu.
/// The type parameter T is the same as the type parameter for [SelectionMenu].
///
/// See [ComponentsConfiguration].
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
          searchFieldComponent:
              searchFieldComponent ?? DropdownSearchFieldComponent(),
          //
          searchingIndicatorComponent: searchingIndicatorComponent ??
              DropdownSearchingIndicatorComponent(),
          //
          animationComponent:
              animationComponent ?? DropdownAnimationComponent(),
          //
          menuPositionAndSizeComponent: menuPositionAndSizeComponent ??
              DropdownMenuPositionAndSizeComponent(),
          //
          triggerComponent: triggerComponent ?? DropdownTriggerComponent(),
          //
          menuComponent: menuComponent ?? DropdownMenuComponent(),
          //
          listViewComponent: listViewComponent ?? DropdownListViewComponent(),
          //
          searchBarComponent:
              searchBarComponent ?? DropdownSearchBarComponent(),
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
    searchBar: 0,
    searchingIndicator: 2,
  );

  static MenuSizeConfiguration defaultMenuSizeConfiguration =
      MenuSizeConfiguration(
    minHeightFraction: 0.3,
    minWidthFraction: 0.3,
    maxHeightFraction: 0.8,
    maxWidthFraction: 0.5,
  );
}

/// A [AnimationComponent] used by [DropdownComponentsConfiguration].
class DropdownAnimationComponent extends AnimationComponent
    with ComponentLifeCycleMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  DropdownAnimationComponent() {
    super.builder = _builder;
  }

  Widget _builder(AnimationComponentData data) {
    _animationController ??= AnimationController(
      vsync: data.tickerProvider,
      duration: data.menuAnimationDurations.forward,
      reverseDuration: data.menuAnimationDurations.reverse,
    );
    _animation ??= CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    if (data.menuAnimationState == MenuAnimationState.OpeningEnd)
      _animationController.forward();

    if (data.menuAnimationState == MenuAnimationState.ClosingEnd)
      _animationController.reverse();

    return Container(
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
      child: SizeTransition(
        axisAlignment: -1.0,
        sizeFactor: _animation,
        child: Container(
          child: data.child,
          constraints: data.constraints,
        ),
      ),
      constraints: BoxConstraints.loose(data.constraints.biggest),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
  }

  @override
  void init() {
    _animationController = null;
  }
}

/// A [SearchFieldComponent] used by [DropdownComponentsConfiguration].
class DropdownSearchFieldComponent extends SearchFieldComponent {
  DropdownSearchFieldComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchFieldComponentData data) {
    Color accentColor = Theme.of(data.context).accentColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
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
            contentPadding: const EdgeInsets.all(10.0),
          ),
        ),
      ),
    );
  }
}

/// A [SearchingIndicatorComponent] used by [DropdownComponentsConfiguration].
class DropdownSearchingIndicatorComponent extends SearchingIndicatorComponent {
  DropdownSearchingIndicatorComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchingIndicatorComponentData data) {
    double size = Theme.of(data.context).iconTheme.size ??
        Theme.of(data.context).textTheme.body1.fontSize ??
        15;
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: size / 5,
        ),
        width: size,
        height: size,
      ),
    );
  }
}

/// A [SearchBarComponent] used by [DropdownComponentsConfiguration].
class DropdownSearchBarComponent extends SearchBarComponent {
  DropdownSearchBarComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchBarComponentData data) {
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: columnChildren,
    );
  }
}

/// A [ListViewComponent] used by [DropdownComponentsConfiguration].
class DropdownListViewComponent extends ListViewComponent {
  DropdownListViewComponent() {
    super.builder = _builder;
  }

  Widget _builder(ListViewComponentData data) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.0),
      itemBuilder: data.itemBuilder,
      itemCount: data.itemCount,
    );
  }
}

/// A [MenuComponent] used by [DropdownComponentsConfiguration].
class DropdownMenuComponent extends MenuComponent {
  DropdownMenuComponent() {
    super.builder = _builder;
  }

  Widget _builder(MenuComponentData data) {
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

    return ClipRect(
      child: Column(
        children: columnChildren,
      ),
    );
  }
}

/// A [MenuPositionAndSizeComponent] used by [DropdownComponentsConfiguration].
class DropdownMenuPositionAndSizeComponent
    extends MenuPositionAndSizeComponent {
  DropdownMenuPositionAndSizeComponent() {
    super.builder = _builder;
  }

  MenuPositionAndSize _builder(MenuPositionAndSizeComponentData data) {
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
}

/// A [TriggerComponent] used by [DropdownComponentsConfiguration].
class DropdownTriggerComponent extends TriggerComponent {
  DropdownTriggerComponent() {
    super.builder = _builder;
  }

  Widget _builder(TriggerComponentData data) {
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
}
