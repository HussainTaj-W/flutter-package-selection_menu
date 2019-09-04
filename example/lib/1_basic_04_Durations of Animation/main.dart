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
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      child: SelectionMenu<FlatColor>(
        // ComponentsConfiguration is the core of the high customizability this
        // Widget provides.
        //
        // The default ComponentsConfiguration is DialogComponentsConfiguration.
        // A second one, and the only other provided predefined so far, is
        // DropdownComponentsConfiguration, which displays a dropdown style menu.
        componentsConfiguration: DialogComponentsConfiguration(
            // Animations can be created and controlled by ComponentsConfiguration.animationComponent.
            // This will be demonstrated in later examples.

            menuAnimationDurations: MenuAnimationDurations(
              forward: const Duration(seconds: 2),
              // Menu opening animation duration.
              reverse: const Duration(seconds: 2),
              // Menu closing animation duration.
            ),
            //
            // ComponentsConfiguration take a MenuSizeConfiguration too.
            // If you are providing a ComponentsConfiguration and a MenuSizeConfiguration,
            // you must provide the size configuration inside the ComponentsConfiguration.
            menuSizeConfiguration: MenuSizeConfiguration(
              maxHeightFraction: 0.5,
              maxWidthFraction: 0.8,
              minWidth: 300,
              minHeight: 200,
              requestAvoidBottomInset: true,
              enforceMinWidthToMatchTrigger: true,
              width: 100,
              requestConstantHeight: true,
            )),
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
      constraints: BoxConstraints(maxWidth: screenSize.width * 0.75),
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
