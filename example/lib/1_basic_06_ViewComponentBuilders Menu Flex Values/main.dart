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
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      child: SelectionMenu<FlatColor>(
        viewComponentBuilders: DropdownViewComponentBuilders<FlatColor>(
          // MenuFlexValues are the Flex values of each component of the menu.
          // These values help size things relatively. So that if menu size is
          // changed, the appearance tries to stay consistent.
          //
          // Note: Search Bar is the combination of Search Field and
          // Searching Indicator. So Search Field and Searching Indicator are siblings.
          // And ListView and Search Bar are siblings.
          //
          // This means a flex of search field = 1 and searchingIndicator = 1
          // means that they will always have the same size, regardless of other values.
          // Similarly, if listView and searchBar are both 1, they'll take the
          // same space, regardless of what searchField and searchingIndicator are.
          menuFlexValues: MenuFlexValues(
            searchingIndicator: 1,
            searchBarContainer: 1,
            listView: 1,
            searchField: 1,
          ),

          menuSizeConfiguration: MenuSizeConfiguration(
            maxHeightFraction: 0.5,
            requestAvoidBottomInset: true,
            enforceMinWidthToMatchButton: true,
            enforceMaxWidthToMatchButton: true,
          ),
        ),
        menuAnimationDurations: MenuAnimationDurations(
          forward: const Duration(seconds: 1),
          backward: const Duration(seconds: 1),
        ),
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsButton: true,
        initiallySelectedItemIndex: 0,
        closeMenuInsteadOfPop: true,
        closeMenuOnEmptyMenuSpaceTap: false,
        closeMenuWhenTappedOutside: true,
        itemSearchMatcher: this.itemSearchMatcher,
        searchLatency: Duration(seconds: 1),
      ),
      constraints: BoxConstraints(maxWidth: screenSize.width * 0.75),
    );
  }

  //region From Previous Example

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
