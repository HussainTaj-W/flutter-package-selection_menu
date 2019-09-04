import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

// This ComponentsConfiguration will be made from the previous
// example(3_advance_02)'s code.

// It'd easier if you copy the constructor from a already defined ComponentsConfiguration
// like I did here. And then change the change the names.

// This is not the best ComponentsConfiguration implementation but it is
// adequate for demonstration.
class CircularWindowComponentsConfiguration<T>
    extends ComponentsConfiguration<T> {
  final double navigationButtonSize;
  final double itemSize;

  CircularWindowComponentsConfiguration({
    this.navigationButtonSize = 40,
    this.itemSize = 100,
    //
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
    //
  }) : super(
          searchFieldComponent:
              searchFieldComponent ?? CircularWindowSearchFieldComponent(),
          //
          searchingIndicatorComponent: searchingIndicatorComponent ??
              CircularWindowSearchingIndicatorComponent(),
          //
          animationComponent:
              animationComponent ?? CircularWindowAnimationComponent(),
          //
          menuPositionAndSizeComponent: menuPositionAndSizeComponent ??
              CircularWindowMenuPositionAndSizeComponent(),
          //
          triggerComponent: triggerComponent ??
              CircularWindowTriggerComponent(size: navigationButtonSize),
          //
          menuComponent: menuComponent ?? CircularWindowMenuComponent(),
          //
          listViewComponent: listViewComponent ??
              CircularWindowListViewComponent(
                  itemSize: itemSize,
                  navigationButtonSize: navigationButtonSize),
          //
          searchBarComponent:
              searchBarComponent ?? CircularWindowSearchBarComponent(),
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
    maxWidthFraction: 0.9,
    maxHeightFraction: 0.9,
    minHeightFraction: 0.1,
    minWidthFraction: 0.1,
  );

  static MenuAnimationDurations defaultMenuAnimationDurations =
      const MenuAnimationDurations(
    forward: const Duration(milliseconds: 2000),
    reverse: const Duration(milliseconds: 1000),
  );

  static MenuAnimationCurves defaultMenuAnimationCurves =
      const MenuAnimationCurves(
    forward: Curves.elasticOut,
    reverse: Curves.elasticOut,
  );
}

/// A [SearchFieldComponent] used by [CircularWindowComponentsConfiguration].
class CircularWindowSearchFieldComponent extends SearchFieldComponent {
  CircularWindowSearchFieldComponent() {
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

/// A [SearchingIndicatorComponent] used by [CircularWindowComponentsConfiguration].
class CircularWindowSearchingIndicatorComponent
    extends SearchingIndicatorComponent {
  CircularWindowSearchingIndicatorComponent() {
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

/// A [SearchBarComponent] used by [CircularWindowComponentsConfiguration].
class CircularWindowSearchBarComponent extends SearchBarComponent {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  CircularWindowSearchBarComponent() {
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
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Material(
          shape: StadiumBorder(
            side: BorderSide(
              color: Theme.of(data.context).accentColor,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rowChildren,
            ),
          ),
        ),
      ),
    );
  }
}

/// A [ListViewComponent] used by [CircularWindowComponentsConfiguration].
class CircularWindowListViewComponent extends ListViewComponent {
  final double itemSize;
  final double navigationButtonSize;
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  CircularWindowListViewComponent({
    @required this.itemSize,
    @required this.navigationButtonSize,
  }) : assert(itemSize != null, "Size should be provided.") {
    super.builder = _builder;
    _scrollController.addListener(() {
      _currentIndex = (_scrollController.offset / itemSize).round();
    });
  }

  void _scrollUp() {
    if (_currentIndex > 0) {
      _scrollController.animateTo(
        (--_currentIndex) * itemSize,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollDown() {
    if ((_currentIndex + 1) * itemSize <=
        _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        (++_currentIndex) * itemSize,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _builder(ListViewComponentData data) {
    _currentIndex = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: navigationButtonSize,
          width: navigationButtonSize,
          child: RaisedButton(
            onPressed: _scrollUp,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(navigationButtonSize / 2)),
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.keyboard_arrow_up,
            ),
          ),
        ),
        SizedBox(
          height: navigationButtonSize,
        ),
        SizedBox(
          width: itemSize,
          height: itemSize,
          child: Card(
            clipBehavior: Clip.hardEdge,
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(itemSize / 2)),
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: data.itemBuilder,
              itemCount: data.itemCount,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        SizedBox(
          height: navigationButtonSize,
        ),
        SizedBox(
          height: navigationButtonSize,
          width: navigationButtonSize,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(navigationButtonSize / 2)),
            onPressed: _scrollDown,
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.keyboard_arrow_down,
            ),
          ),
        ),
      ],
    );
  }
}

/// A [MenuComponent] used by [CircularWindowComponentsConfiguration].
class CircularWindowMenuComponent extends MenuComponent {
  CircularWindowMenuComponent() {
    super.builder = _builder;
  }

  Widget _builder(MenuComponentData data) {
    List<Widget> columnChildren = [];

    if (data.isSearchEnabled) {
      columnChildren.add(
        data.searchBar,
      );
    }

    columnChildren.add(
      data.listView,
    );

    return ClipRect(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: columnChildren,
      ),
    );
  }
}

/// A [AnimationComponent] used by [CircularWindowComponentsConfiguration].
class CircularWindowAnimationComponent extends AnimationComponent
    with ComponentLifeCycleMixin {
  CircularWindowAnimationComponent() {
    super.builder = _builder;
  }

  AnimationController _animationController;
  Animation _animation;
  MenuState _lastState;

  Widget _builder(AnimationComponentData data) {
    if (_animationController == null) {
      _animationController = AnimationController(
          vsync: data.tickerProvider,
          duration: data.menuAnimationDurations.forward,
          reverseDuration: data.menuAnimationDurations.reverse);

      _animation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      );

      _animation.addStatusListener((status) {
        if (status == AnimationStatus.dismissed ||
            status == AnimationStatus.completed) {
          if (_lastState == MenuState.OpeningEnd) {
            data.opened();
          } else {
            data.closed();
          }
        }
      });
    }

    switch (data.menuState) {
      case MenuState.OpeningStart:
        break;
      case MenuState.OpeningEnd:
        _animationController.forward();
        _lastState = data.menuState;
        break;
      case MenuState.Opened:
        break;
      case MenuState.ClosingStart:
        break;
      case MenuState.ClosingEnd:
        _animationController.reverse();
        _lastState = data.menuState;
        break;
      case MenuState.Closed:
        break;
    }

    return AnimatedBuilder(
      animation: _animation,
      child: Container(
        child: data.child,
        constraints: data.constraints,
      ),
      builder: (BuildContext context, Widget child) {
        return Transform.rotate(
          angle: 6.14 - 6.14 * _animation.value,
          child: Transform.scale(
            scale: 1 * _animation.value,
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController.dispose();
      _animationController = null;
    }
  }

  @override
  void init() {
    _animationController = null;
  }
}

/// A [MenuPositionAndSizeComponent] used by [CircularWindowComponentsConfiguration].
class CircularWindowMenuPositionAndSizeComponent
    extends MenuPositionAndSizeComponent {
  CircularWindowMenuPositionAndSizeComponent() {
    super.builder = _builder;
  }

  MenuPositionAndSize _builder(MenuPositionAndSizeComponentData data) {
    double menuMidY = data.constraints.biggest.height / 2;
    double menuMidX = data.constraints.biggest.width / 2;

    double offsetY = -menuMidY + data.triggerPositionAndSize.size.height / 2;
    double offsetX = -menuMidX + data.triggerPositionAndSize.size.width / 2;

    return MenuPositionAndSize(
      constraints: BoxConstraints.tight(data.constraints.biggest),
      positionOffset: Offset(offsetX, offsetY),
    );
  }
}

/// A [TriggerComponent] used by [CircularWindowComponentsConfiguration].
class CircularWindowTriggerComponent extends TriggerComponent {
  CircularWindowTriggerComponent({@required this.size})
      : assert(size != null, "Size should be provided.") {
    super.builder = _builder;
  }

  final double size;

  Widget _builder(TriggerComponentData data) {
    return SizedBox(
      height: size,
      width: size,
      child: RaisedButton(
        onPressed: data.triggerMenu,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Icon(
          Icons.keyboard_arrow_down,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
