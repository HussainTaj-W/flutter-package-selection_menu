import 'package:flutter/material.dart';
import 'package:selection_menu/components.dart';
import 'package:selection_menu/selection_menu.dart';

import '../data/FlatColor.dart';

// THIS EXAMPLE IS A CONTINUATION OF EXAMPLE 2_intermediate_02
//
// Reading previous Examples before this one is recommended.
//
// Code from previous example will have their comments or sections removed, simplified, and
// moved to the end of the file to allow meaningful code to stay up top. Please
// do not consider this example as an optimal way to place your code.
//
// main function has been moved to the end.

class CustomSearchingIndicatorComponent extends SearchingIndicatorComponent
    // A required mixin if you want to hook into the Menu's life cycle
    with
        ComponentLifeCycleMixin {
  AnimationController _animationController;

  CustomSearchingIndicatorComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchingIndicatorComponentData data) {
    if (_animationController == null) {
      _animationController = AnimationController(
          vsync: data.tickerProvider, duration: Duration(seconds: 1));
      _animationController.repeat();
    }
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Icon(Icons.search),
      ),
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
  void init() {}
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SelectionMenu<FlatColor>(
        componentsConfiguration:
            DialogComponentsConfiguration<FlatColor>().copyWith(
          searchingIndicatorComponent: CustomSearchingIndicatorComponent(),
          // A subclass of SearchIndicatorComponent.
          //
          // Defined above for the sake of brevity.

          searchFieldComponent:
              SearchFieldComponent(builder: _searchFieldBuilder),
          searchBarComponent: SearchBarComponent(builder: _searchBarBuilder),
          triggerComponent: TriggerComponent(builder: _triggerBuilder),
          triggerFromItemComponent:
              TriggerFromItemComponent(builder: _triggerFromItemBuilder),
        ),

        searchLatency: const Duration(seconds: 5),
        // Added to simulate long searches.

        itemSearchMatcher: this.itemSearchMatcher,
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsTrigger: true,
      ),
    );
  }

  //region From Previous Example

  static Widget _searchBarBuilder(SearchBarComponentData data) {
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

  static Widget _searchFieldBuilder(SearchFieldComponentData data) {
    return TextField(
      controller: data.searchTextController,
      // Assigning controller this way is necessary. The controller listens to
      // changes in the field and fires search process accordingly.
      // This controller is created and managed by SelectionMenu Widget.

      decoration: InputDecoration(
        hintText: "Search Color...",
      ),
    );
  }

  static Widget _triggerBuilder(TriggerComponentData data) {
    return RaisedButton(
      onPressed: data.toggleMenu,
      color: Colors.white,
      child: Text("Select Color"),
    );
  }

  static Widget _triggerFromItemBuilder(TriggerFromItemComponentData data) {
    return RaisedButton(
      onPressed: data.toggleMenu,
      color: Color(data.item.hex),
      child: Text(
        data.item.name,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, FlatColor color) {
    TextStyle textStyle = Theme.of(context).textTheme.body1;

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipOval(
            child: Container(
              color: Color(color.hex),
              height: 20,
              width: 20,
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: EdgeInsets.only(left: 3),
              child: Text(
                color.name,
                style: textStyle,
              ),
            ),
          ),
          Text(
            ('#' + color.hex.toRadixString(16)).toUpperCase(),
            style: textStyle.copyWith(
              color: Colors.grey.shade600,
              fontSize: textStyle.fontSize * 0.75,
            ),
          ),
        ],
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
