import 'package:flutter/material.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/src/widget_configurers/components/components.dart';
import 'package:selection_menu/src/widget_configurers/menu_configuration_classes.dart';

import '../components_configuration.dart';

/// Defines the appearance of [SelectionMenu] as a popup dialog menu.
/// The type parameter T should be the same as the type parameter for [SelectionMenu].
///
/// See [ComponentsConfiguration].
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
          searchFieldComponent:
              searchFieldComponent ?? DialogSearchFieldComponent(),
          //
          searchingIndicatorComponent: searchingIndicatorComponent ??
              DialogSearchingIndicatorComponent(),
          //
          animationComponent: animationComponent ?? DialogAnimationComponent(),
          //
          menuPositionAndSizeComponent: menuPositionAndSizeComponent ??
              DialogMenuPositionAndSizeComponent(),
          //
          triggerComponent: triggerComponent ?? DialogTriggerComponent(),
          //
          menuComponent: menuComponent ?? DialogMenuComponent(),
          //
          listViewComponent: listViewComponent ?? DialogListViewComponent(),
          //
          searchBarComponent: searchBarComponent ?? DialogSearchBarComponent(),
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
    searchBar: 0,
    searchingIndicator: 1,
  );

  static MenuSizeConfiguration defaultMenuSizeConfiguration =
      MenuSizeConfiguration(
    maxWidthFraction: 0.8,
    maxHeightFraction: 0.8,
    minHeightFraction: 0.5,
    minWidthFraction: 0.5,
  );
}

/// A [SearchFieldComponent] used by [DialogComponentsConfiguration].
class DialogSearchFieldComponent extends SearchFieldComponent {
  DialogSearchFieldComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchFieldComponentData data) {
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
}

/// A [SearchingIndicatorComponent] used by [DialogComponentsConfiguration].
class DialogSearchingIndicatorComponent extends SearchingIndicatorComponent {
  DialogSearchingIndicatorComponent() {
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

/// A [SearchBarComponent] used by [DialogComponentsConfiguration].
class DialogSearchBarComponent extends SearchBarComponent {
  DialogSearchBarComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchBarComponentData data) {
    List<Widget> rowChildren = [];

    rowChildren.add(Flexible(
      child: Icon(
        Icons.search,
        color: Theme.of(data.context).accentColor,
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
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.only(bottom: 8.0),
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
}

/// A [ListViewComponent] used by [DialogComponentsConfiguration].
class DialogListViewComponent extends ListViewComponent {
  DialogListViewComponent() {
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

/// A [MenuComponent] used by [DialogComponentsConfiguration].
class DialogMenuComponent extends MenuComponent {
  DialogMenuComponent() {
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

/// A [AnimationComponent] used by [DialogComponentsConfiguration].
class DialogAnimationComponent extends AnimationComponent {
  DialogAnimationComponent() {
    super.builder = _builder;
  }

  Widget _builder(AnimationComponentData data) {
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
        child: Material(
          color: Colors.transparent,
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: data.child,
            ),
          ),
        ),
      ),
      constraints: data.constraints,
    );
  }
}

/// A [MenuPositionAndSizeComponent] used by [DialogComponentsConfiguration].
class DialogMenuPositionAndSizeComponent extends MenuPositionAndSizeComponent {
  DialogMenuPositionAndSizeComponent() {
    super.builder = _builder;
  }

  MenuPositionAndSize _builder(MenuPositionAndSizeComponentData data) {
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
}

/// A [TriggerComponent] used by [DialogComponentsConfiguration].
class DialogTriggerComponent extends TriggerComponent {
  DialogTriggerComponent() {
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
