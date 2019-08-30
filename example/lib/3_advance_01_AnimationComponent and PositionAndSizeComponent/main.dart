import 'package:example/data/FlatColor.dart';
import 'package:flutter/material.dart';
import 'package:selection_menu/components.dart';
import 'package:selection_menu/selection_menu.dart';

// Reading previous Examples before this one is recommended.
//
// Code from previous example will have their comments or sections removed, simplified, and
// moved to the end of the file to allow meaningful code to stay up top. Please
// do not consider this example as an optimal way to place your code.
//
// main function has been moved to the end.

final Size _itemSize = const Size(200, 200);

class MyAnimationComponent extends AnimationComponent
    with ComponentLifeCycleMixin // To get hooks to the Menu's lifecycle
{
  AnimationController _animationController;

  MyAnimationComponent() {
    super.builder = _builder;
  }

  Animation<double> _animation;

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
    }

    switch (data.menuAnimationState) {
      case MenuAnimationState.OpeningStart:
        // Widget is first built for this state.
        //
        // When using Implicit Animations, define widgets with starting
        // configurations at this point.
        //
        // like :
        // AnimatedContainer(color: Colors.transparent,);

        break;
      case MenuAnimationState.OpeningEnd:
        // Widget is built for this state Immediately after OpeningStart state.
        //
        // When using Implicit Animation, define widgets with ending configurations
        // at this point.
        //
        // like :
        // AnimatedContainer(color: Colors.black,);
        _animationController.forward();
        break;
      case MenuAnimationState.Opened:
        // Widget is not built for this state.
        break;
      case MenuAnimationState.ClosingStart:
        // Just like to OpeningStart.
        break;
      case MenuAnimationState.ClosingEnd:
        // Just like OpeningEnd.
        _animationController.reverse();
        break;
      case MenuAnimationState.Closed:
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SelectionMenu<FlatColor>(
        componentsConfiguration:
            DialogComponentsConfiguration<FlatColor>().copyWith(
          animationComponent: MyAnimationComponent(),
          menuPositionAndSizeComponent: MenuPositionAndSizeComponent(
              builder: _menuSizeAndPositionBuilder),
          listViewComponent: MyListViewComponent(),
          menuComponent: MenuComponent(builder: _menuBuilder),
          menuSizeConfiguration: MenuSizeConfiguration(
            maxWidth: 200,
            maxHeight: 300,
            minWidth: 200,
            minHeight: 300,
          ),
          triggerComponent: TriggerComponent(builder: _triggerBuilder),
          triggerFromItemComponent: TriggerFromItemComponent<FlatColor>(
              builder: _triggerFromItemBuilder),
        ),
        menuAnimationDurations: MenuAnimationDurations(
            forward: Duration(seconds: 2), reverse: Duration(seconds: 1)),
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsTrigger: true,
        initiallySelectedItemIndex: 0,
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

  Widget _menuBuilder(MenuComponentData data) {
    return Container(
      child: data.listView,
    );
  }

  Widget _triggerFromItemBuilder(TriggerFromItemComponentData<FlatColor> data) {
    return SizedBox(
      height: 40,
      width: 40,
      child: RaisedButton(
        onPressed: data.toggleMenu,
        color: Color(data.item.hex),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget itemBuilder(BuildContext context, FlatColor color) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Container(
      constraints: BoxConstraints.tight(_itemSize),
      child: Stack(
        overflow: Overflow.clip,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            color: Color(color.hex),
          ),
          Text(
            color.name,
            style: textStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  //region From Previous Example

  Widget _searchBarBuilder(SearchBarComponentData data) {
    List<Widget> list = [];
    list.add(Expanded(
      child: data.searchField,
      flex: data.menuFlexValues.searchField,
    ));
    if (data.isSearching)
      list.add(Expanded(
        child: data.searchingIndicator,
        flex: data.menuFlexValues.searchingIndicator,
      ));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );
  }

  Widget _searchingIndicatorBuilder(SearchingIndicatorComponentData data) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _searchFieldBuilder(SearchFieldComponentData data) {
    return TextField(
      controller: data.searchTextController,
      decoration: InputDecoration(
        hintText: "Search Color...",
      ),
    );
  }

  Widget _triggerBuilder(TriggerComponentData data) {
    return RaisedButton(
      onPressed: data.toggleMenu,
      color: Colors.white,
      child: Text("Select Color"),
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
  MyListViewComponent() {
    super.builder = _builder;
  }

  final ScrollController _scrollController = ScrollController();

  Widget _builder(ListViewComponentData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 30,
          width: 30,
          child: RaisedButton(
            onPressed: () {
              _scrollController.animateTo(
                ((_scrollController.offset / _itemSize.height).floor() - 1) *
                    _itemSize.height,
                duration: Duration(seconds: 1),
                curve: Curves.easeOut,
              );
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.keyboard_arrow_up,
            ),
          ),
        ),
        Spacer(),
        Container(
          constraints: BoxConstraints.tight(_itemSize),
          child: Card(
            clipBehavior: Clip.hardEdge,
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_itemSize.height / 2)),
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: data.itemBuilder,
              itemCount: data.itemCount,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        Spacer(),
        SizedBox(
          height: 30,
          width: 30,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              _scrollController.animateTo(
                ((_scrollController.offset / _itemSize.height).floor() + 1) *
                    _itemSize.height,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            },
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
          child: Center(
            child: ExampleApp(),
          ),
        ),
      ),
    );

List<FlatColor> colors = FlatColors.colors;
//endregion
