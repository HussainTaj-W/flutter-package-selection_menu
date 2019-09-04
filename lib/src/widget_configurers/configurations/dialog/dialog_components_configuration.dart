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
    MenuAnimationDurations menuAnimationDurations,
    MenuAnimationCurves menuAnimationCurves,
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
          //
          menuAnimationDurations:
              menuAnimationDurations ?? defaultMenuAnimationDurations,
          //
          menuAnimationCurves:
              menuAnimationCurves ?? defaultMenuAnimationCurves,
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

  static MenuAnimationDurations defaultMenuAnimationDurations =
      const MenuAnimationDurations(
    forward: const Duration(milliseconds: 500),
    reverse: const Duration(milliseconds: 500),
  );

  static MenuAnimationCurves defaultMenuAnimationCurves =
      const MenuAnimationCurves(
    forward: Curves.elasticOut,
    reverse: Curves.elasticOut,
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
class DialogAnimationComponent extends AnimationComponent
    with ComponentLifeCycleMixin {
  DialogAnimationComponent() {
    super.builder = _builder;
  }

  AnimationController _animationController;
  Animation _animation;
  MenuState _state;

  Widget _builder(AnimationComponentData data) {
    if (_animationController == null) {
      _animationController = AnimationController(
        vsync: data.tickerProvider,
        duration: data.menuAnimationDurations.forward,
        reverseDuration: data.menuAnimationDurations.reverse,
      );

      _animationController.addStatusListener((status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = MenuState.Opened;
            break;
          case AnimationStatus.reverse:
            _state = MenuState.Closed;
            break;
          case AnimationStatus.dismissed:
            continue completed;

          completed:
          case AnimationStatus.completed:
            if (_state == MenuState.Opened)
              data.opened();
            else
              data.closed();
            break;
        }
      });
      _animation = CurvedAnimation(
        parent: _animationController,
        curve: data.menuAnimationCurves.forward,
        reverseCurve: data.menuAnimationCurves.reverse,
      );
    }
    if (data.menuState == MenuState.OpeningEnd) {
      _animationController.forward();
    }

    if (data.menuState == MenuState.ClosingEnd) {
      Duration duration = Duration(
          microseconds: (data.menuAnimationDurations.reverse.inMicroseconds *
                  _animation.value)
              .round());
      if (duration < const Duration(milliseconds: 10)) {
        data.closed();
      } else {
        _animationController.reverseDuration = duration;
        _animationController.reverse();
      }
    }

    Widget toAnimate = Material(
      color: Colors.transparent,
      child: Card(
        margin: EdgeInsets.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          constraints: data.constraints,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: data.child,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget toAnimate) {
        return Transform.scale(
          scale: _animation.value,
          child: toAnimate,
        );
      },
      child: toAnimate,
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

/// A [MenuPositionAndSizeComponent] used by [DialogComponentsConfiguration].
class DialogMenuPositionAndSizeComponent extends MenuPositionAndSizeComponent {
  DialogMenuPositionAndSizeComponent() {
    super.builder = _builder;
  }

  MenuPositionAndSize _builder(MenuPositionAndSizeComponentData data) {
    MediaQueryData mqData = MediaQuery.of(data.context);

    BoxConstraints constraints = data.constraints;
    if (data.menuSizeConfiguration.requestConstantHeight) {
      constraints = BoxConstraints.tight(
          data.menuSizeConfiguration.getPreferredSize(mqData.size) ??
              data.constraints.biggest);
    }

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
      onPressed: data.triggerMenu,
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
