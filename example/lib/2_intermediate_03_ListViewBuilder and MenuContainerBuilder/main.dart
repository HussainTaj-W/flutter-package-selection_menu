import 'package:flutter/material.dart';
import 'package:selection_menu/selection_menu.dart';

import '../data/FlatColor.dart';

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
        viewComponentBuilders:
            DialogViewComponentBuilders<FlatColor>().copyWith(
          listViewBuilder: _listViewBuilder,
          // A builder that creates the ListView in which items are shown.
          //
          // Defined below for brevity.

          menuContainerBuilder: _menuContainerBuilder,
          // A builder that wraps the menu with some Widget. The widget Card is
          // used by the DialogComponentBuilders.
          //
          // Defined below for brevity.

          menuSizeConfiguration: MenuSizeConfiguration(
            maxWidth: 200,
            maxHeight: 200,
            minWidth: 200,
            minHeight: 200,
          ),

          buttonBuilder: _buttonBuilder,
          buttonFromItemBuilder: _buttonFromItemBuilder,
        ),
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsButton: true,
      ),
    );
  }

  static MenuContainerBuilder _menuContainerBuilder =
      (BuildContext context, Widget menu) {
    // menu is a Widget that contains Search Bar and ListView
    return Card(
      elevation: 4,
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: menu,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  };

  static ListViewBuilder _listViewBuilder =
      (BuildContext context, ListViewItemBuilder itemBuilder, int itemCount) {
    return ListView.separated(
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      // It is important that you pass itemBuilder and itemCount to your ListView,
      // these are managed by SelectionMenu itself.
      separatorBuilder: (context, _) {
        return Container(
          height: 1,
          color: Colors.black26,
        );
      },
      padding: EdgeInsets.symmetric(vertical: 50.0),
    );
  };

  //region From Previous Example

  static SearchBarBuilder _searchBarBuilder = (
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
  };

  static SearchingIndicatorBuilder _searchingIndicatorBuilder =
      (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: CircularProgressIndicator(),
      ),
    );
  };

  static SearchFieldBuilder _searchFieldBuilder =
      (BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      // Assigning controller this way is necessary. The controller listens to
      // changes in the field and fires search process accordingly.
      // This controller is created and managed by SelectionMenu Widget.

      decoration: InputDecoration(
        hintText: "Search Color...",
      ),
    );
  };

  static ButtonBuilder _buttonBuilder =
      (BuildContext context, ToggleMenu toggleMenu) {
    return RaisedButton(
      onPressed: toggleMenu,
      color: Colors.white,
      child: Text("Select Color"),
    );
  };

  static ButtonFromItemBuilder<FlatColor> _buttonFromItemBuilder =
      (BuildContext context, ToggleMenu toggleMenu, FlatColor color) {
    return RaisedButton(
      onPressed: toggleMenu,
      color: Color(color.hex),
      child: Text(
        color.name,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  };

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
