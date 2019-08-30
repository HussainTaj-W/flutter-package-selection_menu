import 'package:flutter/material.dart';
import 'package:selection_menu/selection_menu.dart';

import '../data/FlatColor.dart';

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

// List of items that will be used
List<FlatColor> colors = FlatColors.colors;

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //FlatColor is the type of data that will be presented in the list or selected.
    return SelectionMenu<FlatColor>(
      itemsList: colors,

      itemBuilder: this.itemBuilder,
      // A callback to return a widget created from an Item (type FlatColor in this example.)
      // Since SelectionMenu.showSelectedItemAsButton is true (see below), this
      // itemBuilder will be used to create the button as well as the items.
      //
      // We will later learn a better alternative to create a button using
      // , in the upcoming examples.
      //
      // Function defined below for the sake of brevity.

      onItemSelected: this.onItemSelected,
      // A callback for when an item is selected.
      // Defined below for the sake of brevity.

      showSelectedItemAsTrigger: true,
      // Defaults to false. When true, shows the selected Item as the button/trigger.

      initiallySelectedItemIndex: 0,
      // Defaults to null, which is valid and means that a default button will be
      // shown instead of an item. This default button can be customized by using
      // ViewComponentBuilders.buttonBuilder as it will be demonstrated in
      // later examples.

      closeMenuInsteadOfPop: true,
      // Defaults to true, used only for demonstration purposes.

      closeMenuOnEmptyMenuSpaceTap: false,
      // Defaults to false, used only for demonstration purposes.

      closeMenuWhenTappedOutside: true,
      // Defaults to true, used only for demonstration purposes.
      // Defines if tapping outside the menu should close it.
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

  void onItemSelected(FlatColor color) {
    print(color.name);
  }
}
