import 'package:example/data/FlatColor.dart';
import 'package:flutter/material.dart';
import 'package:selection_menu/selection_menu.dart';

// Reading previous Examples before this one is recommended.
//
// Code from previous example will have their comments or sections removed, simplified, and
// moved to the end of the file to allow meaningful code to stay up top. Please
// do not consider this example as an optimal way to place your code.
//
// main function has been moved to the end.

class ExampleApp extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final Size _itemSize = const Size(200, 200);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SelectionMenu<FlatColor>(
        viewComponentBuilders:
            DialogViewComponentBuilders<FlatColor>().copyWith(
          menuAnimatedContainerBuilder: _animatedContainerBuilder,
          menuPositionAndSizeCalculator: _menuSizeAndPositionCalculator,
          listViewBuilder: _listViewBuilder,
          menuContainerBuilder: _menuContainerBuilder,
          menuSizeConfiguration: MenuSizeConfiguration(
            maxWidth: 200,
            maxHeight: 300,
            minWidth: 200,
            minHeight: 300,
          ),
          buttonBuilder: _buttonBuilder,
          buttonFromItemBuilder: _buttonFromItemBuilder,
        ),
        menuAnimationDurations: MenuAnimationDurations(
            forward: Duration(seconds: 2), backward: Duration(seconds: 2)),
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsButton: true,
        initiallySelectedItemIndex: 0,
      ),
    );
  }

  Widget _animatedContainerBuilder(
    BuildContext container,
    Widget menu,
    MenuAnimationState state,
    BoxConstraints constraints,
    MenuAnimationDurations durations,
  ) {
    // Tween of Transition and Scale together this way allows to create the effect
    // of Scaling up and down from the center.
    double offsetX = constraints.maxWidth / 2;
    double offsetY = constraints.maxHeight / 2;
    Matrix4 fromTween = Matrix4.identity();

    Matrix4 toTween = Matrix4.identity();

    return Container(
      child: AnimatedContainer(
        color: Colors.transparent,
        curve: state == MenuAnimationState.OpeningStart ||
                state == MenuAnimationState.ClosingEnd
            ? Curves.easeIn
            : Curves.easeOut,
//        transform: state == MenuAnimationState.OpeningStart ||
//                state == MenuAnimationState.ClosingEnd
//            ? fromTween
//            : toTween,
        duration: state == MenuAnimationState.OpeningEnd
            ? durations.forward
            : durations.backward,
        child: Transform.rotate(
          angle: state == MenuAnimationState.OpeningStart ||
                  state == MenuAnimationState.ClosingEnd
              ? 90
              : 0,
          child: menu,
        ),
        alignment: FractionalOffset.center,
      ),
      constraints: constraints,
    );
  }

  MenuPositionAndSize _menuSizeAndPositionCalculator(
      BuildContext context,
      BoxConstraints constraints,
      Offset buttonPosition,
      Size buttonSize,
      MenuSizeConfiguration sizeConfig) {
    double menuMidY = constraints.biggest.height / 2;
    double menuMidX = constraints.biggest.width / 2;

    // The origin of the menu is top-left corner. Which matches the top-left corner
    // of the button. -menuMidY and -menuMidX offset makes the menu middle meet
    // the top-left corner of the button. We add half of the button lengths so
    // that the menu middle and button middle become the same.
    double offsetY = -menuMidY + buttonSize.height / 2;
    double offsetX = -menuMidX + buttonSize.width / 2;

    return MenuPositionAndSize(
      constraints: BoxConstraints.tight(constraints.biggest),
      // To ensure that the calculated middle stays the middle, we have to
      // fix the Size of the menu, hence new BoxConstraints are tight to the
      // biggest Size possible.
      positionOffset: Offset(offsetX, offsetY),
    );
  }

  Widget _menuContainerBuilder(BuildContext context, Widget menu) {
    return Container(
      child: menu,
      alignment: FractionalOffset.center,
      color: Colors.red,
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

  Widget _buttonFromItemBuilder(
      BuildContext context, ToggleMenu toggleMenu, FlatColor color) {
    return SizedBox(
      height: 40,
      width: 40,
      child: RaisedButton(
        onPressed: toggleMenu,
        color: Color(color.hex),
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

  Widget _listViewBuilder(
      BuildContext context, ListViewItemBuilder itemBuilder, int itemCount) {
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
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_itemSize.height / 2)),
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: itemBuilder,
              itemCount: itemCount,
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

  //region From Previous Example

  Widget _searchBarBuilder(
    BuildContext context,
    Widget searchField,
    Widget searchIndicator,
    bool isSearching,
    MenuFlexValues values, // Example 1_basic_06 explains this parameter.
  ) {
    List<Widget> list = [];
    list.add(Expanded(
      child: searchField,
      flex: values.searchField,
    ));
    if (isSearching)
      list.add(Expanded(
        child: searchIndicator,
        flex: values.searchingIndicator,
      ));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );
  }

  Widget _searchingIndicatorBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _searchFieldBuilder(
      BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      // Assigning controller this way is necessary. The controller listens to
      // changes in the field and fires search process accordingly.
      // This controller is created and managed by SelectionMenu Widget.

      decoration: InputDecoration(
        hintText: "Search Color...",
      ),
    );
  }

  Widget _buttonBuilder(BuildContext context, ToggleMenu toggleMenu) {
    return RaisedButton(
      onPressed: toggleMenu,
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
