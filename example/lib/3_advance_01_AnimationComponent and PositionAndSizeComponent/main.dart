import 'package:example/data/FlatColor.dart';
import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

// Reading previous Examples before this one is recommended.
//
// Code from previous example will have their comments or sections removed, simplified, and
// moved to the end of the file to allow meaningful code to stay up top. Please
// do not consider this example as an optimal way to place your code.
//
// main function has been moved to the end.

class MyAnimationComponent extends AnimationComponent
    with ComponentLifeCycleMixin // To get hooks to the Menu's lifecycle
{
  AnimationController _animationController;
  Animation<double> _animation;

  MyAnimationComponent() {
    super.builder = _builder;
  }
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

      // Add a listener to know when animation stops.
      // Since you need to explicit report to the widget that the animation
      // state has changed.
      _animation.addStatusListener((status) {
        if (status == AnimationStatus.dismissed ||
            status == AnimationStatus.completed) {
          if (_lastState == MenuState.OpeningEnd) {
            // To tell the widget that menu has opened
            data.opened();
          } else {
            // to tell the widget that the menu has closed.
            data.closed();
          }
        }
      });
    }

    switch (data.menuState) {
      case MenuState.OpeningStart:
        // Widget is first built for this state.
        //
        // When using Implicit Animations, define widgets with starting
        // configurations at this point.
        //
        // like :
        // AnimatedContainer(color: Colors.transparent,);

        break;
      case MenuState.OpeningEnd:
        // Widget is built for this state Immediately after OpeningStart state.
        //
        // When using Implicit Animation, define widgets with ending configurations
        // at this point.
        // Since implicit animations don't typically have status listeners,
        // you may use data.willOpenAfter(Duration);
        //
        // like :
        // AnimatedContainer(color: Colors.black,);
        //
        // For explicit animations start animation like so:
        _animationController.forward();
        _lastState = data.menuState;
        break;
      case MenuState.Opened:
        // The Widget is built for this state.
        break;
      case MenuState.ClosingStart:
        // Just like to OpeningStart.
        break;
      case MenuState.ClosingEnd:
        // Just like OpeningEnd.
        //
        // you can use data.willCloseAfter(Duration); for implicit animations.
        _animationController.reverse();
        _lastState = data.menuState;
        break;
      case MenuState.Closed:
        // Widget is not built for this state.
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

class ExampleApp extends StatelessWidget {
  final double itemSize = 200;
  final double navButtonSize = 40;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SelectionMenu<FlatColor>(
        componentsConfiguration:
            DialogComponentsConfiguration<FlatColor>().copyWith(
          animationComponent: MyAnimationComponent(),
          menuPositionAndSizeComponent: MenuPositionAndSizeComponent(
              builder: _menuSizeAndPositionBuilder),
          listViewComponent: MyListViewComponent(
              itemSize: itemSize, navigationButtonSize: navButtonSize),
          menuSizeConfiguration: MenuSizeConfiguration(
            maxWidthFraction: 1.0,
            maxHeightFraction: 1.0,
            minHeightFraction: 0.1,
            minWidthFraction: 0.1,
          ),
          triggerComponent: TriggerComponent(builder: _triggerBuilder),
          triggerFromItemComponent: TriggerFromItemComponent<FlatColor>(
              builder: _triggerFromItemBuilder),
          menuAnimationDurations: MenuAnimationDurations(
              forward: Duration(seconds: 2), reverse: Duration(seconds: 1)),
        ),
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsTrigger: true,
      ),
    );
  }

  MenuPositionAndSize _menuSizeAndPositionBuilder(
      MenuPositionAndSizeComponentData data) {
    double menuMidY = data.constraints.biggest.height / 2;
    double menuMidX = data.constraints.biggest.width / 2;

    // The origin of the menu is top-left corner. Which matches the top-left corner
    // of the button. -menuMidY and -menuMidX offset makes the menu middle meet
    // the top-left corner of the button. We add half of the button lengths so
    // that the menu middle and button middle become the same.
    double offsetY = -menuMidY + data.triggerPositionAndSize.size.height / 2;
    double offsetX = -menuMidX + data.triggerPositionAndSize.size.width / 2;

    return MenuPositionAndSize(
      constraints: BoxConstraints.tight(data.constraints.biggest),
      // To ensure that the calculated middle stays the middle, we have to
      // fix the Size of the menu, hence new BoxConstraints are tight to the
      // biggest Size possible.
      positionOffset: Offset(offsetX, offsetY),
    );
  }

  Widget _triggerFromItemBuilder(TriggerFromItemComponentData<FlatColor> data) {
    return SizedBox(
      height: navButtonSize,
      width: navButtonSize,
      child: RaisedButton(
        onPressed: data.triggerMenu,
        color: Color(data.item.hex),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(navButtonSize / 2),
        ),
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget itemBuilder(
      BuildContext context, FlatColor color, OnItemTapped onItemTapped) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Container(
      constraints: BoxConstraints.tight(Size(itemSize, itemSize)),
      child: Stack(
        overflow: Overflow.clip,
        alignment: Alignment.center,
        children: <Widget>[
          Material(
            color: Color(color.hex),
            child: InkWell(
              onTap: onItemTapped,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              onItemTapped();
            },
            child: Text(
              color.name,
              style: textStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //region From Previous Example

  Widget _triggerBuilder(TriggerComponentData data) {
    return SizedBox(
      height: navButtonSize,
      width: navButtonSize,
      child: RaisedButton(
        onPressed: data.triggerMenu,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(navButtonSize / 2),
        ),
        child: Icon(
          Icons.keyboard_arrow_down,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  bool itemSearchMatcher(String searchString, FlatColor color) {
    return color.name.toLowerCase().contains(searchString.trim().toLowerCase());
  }

  void onItemSelected(FlatColor color) {
    print(color.name);
  }

//endregion
}

class MyListViewComponent extends ListViewComponent {
  final double itemSize;
  final double navigationButtonSize;
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  MyListViewComponent({
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

//region From Previous Example
void main() => runApp(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          accentColor: Colors
              .redAccent, // Used by the default Dialog Style of SelectionMenu
        ),
        home: Material(
          child: Container(
            color: Colors.black26,
            child: Center(
              child: ExampleApp(),
            ),
          ),
        ),
      ),
    );

List<FlatColor> colors = FlatColors.colors;
//endregion
