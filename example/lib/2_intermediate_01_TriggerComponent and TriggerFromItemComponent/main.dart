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
            // The type of this parameter is ComponentsConfiguration, however
            // since almost all Components are required for the Widget to function
            // We use a predefined subclass of ComponentsConfiguration. The
            // specific components we assign will be used along with the default
            // versions of any component that is not assigned.
            //
            // In this example we create Builders and assign them to the Components.
            // An alternative, which is useful in some cases, is extending the
            // Component classes, which is explained in example 2_intermediate_04.

            DialogComponentsConfiguration<FlatColor>(
          triggerComponent: TriggerComponent(builder: _triggerBuilder),
          // This Component is used to build the default button (trigger).
          //
          // If SelectionMenu.showSelectedItemAsButton is true and
          // SelectionMenu.initiallySelectedItemIndex is null, this builder is used
          // when the Widget is built for the first time.
          //
          // Defined below for the sake of brevity.

          triggerFromItemComponent: TriggerFromItemComponent<FlatColor>(
              builder: _triggerFromItemBuilder),
          // This Component is used to build the button, only when an item is selected
          // and SelectionMenu.showSelectedItemAsButton is set to true.
          // If this builder is null, SelectionMenu uses SelectionMenu.itemBuilder
          // in its place.
          //
          // Defined below for the sake of brevity.
          //
        ),
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsTrigger: true,
      ),
    );
  }

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

  //region From Previous Example

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
