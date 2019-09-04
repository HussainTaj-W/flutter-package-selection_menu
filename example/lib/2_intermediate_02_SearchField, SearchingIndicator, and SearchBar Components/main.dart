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

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SelectionMenu<FlatColor>(
        componentsConfiguration:
            DialogComponentsConfiguration<FlatColor>().copyWith(
          searchFieldComponent:
              SearchFieldComponent(builder: _searchFieldBuilder),
          // Builds the widget where the user enters search text
          //
          // Defined below for the sake of brevity.

          searchingIndicatorComponent:
              SearchingIndicatorComponent(builder: _searchingIndicatorBuilder),
          // Builds the widget that indicates search in progress.
          //
          // Defined below for the sake of brevity.

          searchBarComponent: SearchBarComponent(builder: _searchBarBuilder),
          // Builds a widget (Search Bar) that typically contains
          // Search Field and Searching Indicator
          //
          // Defined below for the sake of brevity.

          triggerComponent: TriggerComponent(builder: _triggerBuilder),
          triggerFromItemComponent:
              TriggerFromItemComponent(builder: _triggerFromItemBuilder),
        ),
        itemSearchMatcher: this.itemSearchMatcher,
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsTrigger: true,
      ),
    );
  }

  static Widget _searchBarBuilder(SearchBarComponentData data) {
    List<Widget> list = [];
    list.add(Flexible(
      child: data.searchField,
      flex: data.menuFlexValues.searchField,
    ));
    if (data.isSearching)
      list.add(Flexible(
        child: data.searchingIndicator,
        flex: data.menuFlexValues.searchingIndicator,
      ));
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );
  }

  static Widget _searchingIndicatorBuilder(
      SearchingIndicatorComponentData data) {
    return Text("Searching...");
  }

  static Widget _searchFieldBuilder(SearchFieldComponentData data) {
    return TextField(
      controller: data.searchTextController,
      // Assigning controller this way is necessary. The controller listens to
      // changes in the field and fires search process accordingly.
      // This controller is created and managed by SelectionMenu Widget.

      decoration: InputDecoration(
          hintText: "Search Color...",
          border: OutlineInputBorder(borderSide: BorderSide(width: 2))),
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
