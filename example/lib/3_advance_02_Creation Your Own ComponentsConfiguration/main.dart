import 'package:example/3_advance_02_Creation%20Your%20Own%20ComponentsConfiguration/circular_window_components_configuration.dart';
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
  final double itemSize = 250;
  final double navButtonSize = 40;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SelectionMenu<FlatColor>(
        componentsConfiguration: CircularWindowComponentsConfiguration(
          navigationButtonSize: navButtonSize,
          itemSize: itemSize,
          triggerFromItemComponent: TriggerFromItemComponent<FlatColor>(
              builder: _triggerFromItemBuilder),
        ),
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsTrigger: true,
      ),
    );
  }

  Widget _triggerFromItemBuilder(TriggerFromItemComponentData<FlatColor> data) {
    return SizedBox(
      height: this.navButtonSize,
      width: this.navButtonSize,
      child: RaisedButton(
        onPressed: data.triggerMenu,
        color: Color(data.item.hex),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(navButtonSize / 2),
        ),
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget itemBuilder(
      BuildContext context, FlatColor color, OnItemTapped onItemTapped) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;

    return Container(
      constraints: BoxConstraints.tight(Size(itemSize, itemSize)),
      child: Stack(
        overflow: Overflow.clip,
        alignment: Alignment.center,
        children: <Widget>[
          Material(
            color: Color(color.hex),
            child: InkWell(
              onTap: onItemTapped,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              onItemTapped();
            },
            child: Text(
              color.name,
              style: textStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //region From Previous Example

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
            child: Center(
              child: ExampleApp(),
            ),
          ),
        ),
      ),
    );

List<FlatColor> colors = FlatColors.colors;
//endregion
