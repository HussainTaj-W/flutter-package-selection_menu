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
    // Since we have SelectionMenu.showSelectedItemAsButton as true,
    // The SelectionMenu.itemBuilder is used to create the button, which is
    // a Row that spans the screen width.
    // SelectionMenu has been placed in a Container with constraints to control
    // its width. However, this has its drawbacks, there can be an even better
    // solution using ViewComponentBuilders.buttonFromItemBuilder.
    // Builders will be demonstrated in later examples.
    //
    // Note that SelectionMenu is just the button. The menu is an Overlay.

    Size screenSize = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(maxWidth: screenSize.width * 0.75),
      child: SelectionMenu<FlatColor>(
        menuSizeConfiguration: MenuSizeConfiguration(
          maxHeightFraction: 0.5,
          // Maximum Fraction of screen height that the menu should take.
          // Defaults to 1 which means 100%.
          //
          // maxWidthFraction, minWidthFraction, minHeightFraction are similar
          // (min values default to 0).

          minWidth: 300,
          // Defaults to null. These are flutter's logical pixel values.
          //
          // maxWidth, minHeight, maxHeight are similar.
          // These values take preference over the fraction based counterparts.

          requestAvoidBottomInset: true,
          // Avoid bottom inset often caused by keyboard opening up.
          // Defaults to true, only shown for demonstration purposes.
          //
          // Behavior depends on the ViewComponentBuilders used. Which will be
          // demonstrated in later examples.

          enforceMinWidthToMatchButton: true,
          // Defaults to false,
          // enforceMaxWidthToMatchButton is similar.

          width: 100,
          // Preferred Width of the menu in logical pixels.
          //
          // Note: The menu always tries to be as wide and as high as possible in
          // The DropDownViewBuilders and DialogViewBuilders.
          //
          // This value and MenuSizeConfiguration.height exist so that people who
          // create their own ViewComponentBuilders.positionAndSizeBuilder can
          // make use of it. ViewComponentBuilders are demonstrated in later examples.

          requestConstantHeight: true,
          // Defines that menu should try to take up constant height.
          // However, it depends on the used ViewComponentBuilders how the size
          // will react to this option.
          //  ViewComponentBuilders are demonstrated in later examples.
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
    );
  }

  //region From Previous Example

  bool itemSearchMatcher(String searchString, FlatColor color) {
    return color.name.toLowerCase().contains(searchString.trim().toLowerCase());
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
