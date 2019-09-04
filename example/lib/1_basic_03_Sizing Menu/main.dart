import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
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
    // The SelectionMenu.itemBuilder is used to create the button(trigger), which is
    // a Row that spans the screen width.
    // SelectionMenu has been placed in a Container with constraints to control
    // its width. However, this has its drawbacks, there can be an even better
    // solution using ComponentsConfiguration.triggerFromItemComponent.
    // ComponentsConfiguration and Components will be demonstrated in later examples.
    //
    // Note that SelectionMenu is just the button (trigger). The menu is an Overlay.

    Size screenSize = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(maxWidth: screenSize.width * 0.75),
      child: SelectionMenu<FlatColor>(
        menuSizeConfiguration: MenuSizeConfiguration(
          maxHeightFraction: 0.5,
          // Maximum Fraction of screen height that the menu should take.
          // Defaults to null.
          //
          // maxWidthFraction, minWidthFraction, minHeightFraction are similar
          maxWidthFraction: 1.0,

          minWidth: 100,
          // Defaults to null. These are flutter's logical pixel values.
          //
          // maxWidth, minHeight, maxHeight are similar.
          // These values take preference over the fraction based counterparts,
          // when size is calculated.
          minHeight: 200,

          requestAvoidBottomInset: true,
          // Avoid bottom inset often caused by keyboard opening up.
          // Defaults to true, only shown for demonstration purposes.
          //
          // Behavior depends on the ComponentsConfiguration used. Which will be
          // demonstrated in later examples.

          enforceMinWidthToMatchTrigger: true,
          // Defaults to false,
          // enforceMaxWidthToMatchButton is similar.

          width: 100,
          // Preferred Width of the menu in logical pixels.
          //
          // This value is preferred over its counterpart widthFraction.
          //
          // Note: The menu always tries to be as wide and as high as possible in
          // The DropdownComponentsConfiguration and DialogComponentsConfiguration.

          widthFraction: 0.1,
          // Preferred width in screen fraction.
          //
          // Similar to width.

          requestConstantHeight: true,
          // Defines that menu should try to take up constant height.
          // However, it depends on the used ComponentsConfiguration how the size
          // will react to this option.
          //  ComponentsConfiguration is demonstrated in later examples.
        ),
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsTrigger: true,
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
            child: Center(
              child: ExampleApp(),
            ),
          ),
        ),
      ),
    );

List<FlatColor> colors = FlatColors.colors;
//endregion
