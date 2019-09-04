import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
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

class CustomSearchingIndicatorComponent
    extends SearchingIndicatorComponent // A required mixin if you want to hook into the Menu's life cycle
    with
        ComponentLifeCycleMixin {
  AnimationController _animationController;

  CustomSearchingIndicatorComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchingIndicatorComponentData data) {
    _animationController ??= AnimationController(
      vsync: data.tickerProvider,
      duration: Duration(seconds: 1),
    );
    _animationController.repeat();

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

  static Widget _triggerBuilder(TriggerComponentData data) {
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: data.triggerMenu,
      color: Colors.white,
      child: Text("Select Color"),
    );
  }

  static Widget _triggerFromItemBuilder(TriggerFromItemComponentData data) {
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: data.triggerMenu,
      color: Color(data.item.hex),
      child: Text(
        data.item.name,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget itemBuilder(
      BuildContext context, FlatColor color, OnItemTapped onItemTapped) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onItemTapped,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipOval(
                child: Container(
                  color: Color(color.hex),
                  height: 30,
                  width: 30,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
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
        ),
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
            cardTheme: ThemeData.light().cardTheme.copyWith(
                  elevation: 5,
                )),
        home: Material(
          child: Container(
            color: Color(0xff95a5a6),
            child: Center(child: ExampleApp()),
          ),
        ),
      ),
    );

List<FlatColor> colors = FlatColors.colors;
//endregion
