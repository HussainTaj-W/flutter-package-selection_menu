import 'package:example/data/FlatColor.dart';
import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

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
        componentsConfiguration: DropdownComponentsConfiguration<FlatColor>(
          // ComponentsConfiguration take a MenuSizeConfiguration too.
          // If you are providing a ComponentsConfiguration and a MenuSizeConfiguration,
          // you must provide the size configuration inside the ComponentsConfiguration.
          menuSizeConfiguration: MenuSizeConfiguration(
            maxHeightFraction: 0.8,
            minHeightFraction: 0.3,
            maxWidthFraction: 0.8,
            minWidthFraction: 0.3,
            requestAvoidBottomInset: true,
            enforceMinWidthToMatchTrigger: true,
            requestConstantHeight: true,
          ),
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
      constraints: BoxConstraints(maxWidth: screenSize.width * 0.75),
    );
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
          child: Container(
            color: Colors.black26,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ExampleApp(),
              ),
            ),
          ),
        ),
      ),
    );

List<FlatColor> colors = FlatColors.colors;
//endregion
