import 'package:flutter/material.dart';
import 'package:selection_menu/selection_menu.dart';

import '../data/FlatColor.dart';

// Reading previous Examples before this one is recommended.
//
// Code from previous example will have their comments removed and moved to the
// end of the file to allow meaningful code to stay up top. Please do not consider
// this example as an optimal way to place your code.
//
// main function has been moved to the end.

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectionMenu<FlatColor>(
      itemSearchMatcher: this.itemSearchMatcher,
      // Defaults to null, meaning search is disabled.
      // ItemSearchMatcher takes a searchString and an Item (FontColor in this example)
      // Returns true if searchString can be used to describe Item, else false.
      // Defined below for the sake of brevity.

      searchLatency: Duration(seconds: 1),
      // Defaults to const Duration(milliseconds: 500).
      // This is the delay before the SelectionMenu actually starts searching.
      // Since search is called for every character change in the search field,
      // it acts as a buffering time and does not perform search for every
      // character update during this time.

      itemsList: colors,
      itemBuilder: this.itemBuilder,
      onItemSelected: this.onItemSelected,
      showSelectedItemAsTrigger: true,
      initiallySelectedItemIndex: 0,
      closeMenuInsteadOfPop: true,
      closeMenuOnEmptyMenuSpaceTap: false,
      closeMenuWhenTappedOutside: true,
    );
  }

  bool itemSearchMatcher(String searchString, FlatColor color) {
    return color.name.toLowerCase().contains(searchString.trim().toLowerCase());
  }

  //region From Previous Example

  Widget itemBuilder(BuildContext context, FlatColor color) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Padding(
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
    );
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
