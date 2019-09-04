import 'package:example/data/FlatColor.dart';
import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectionMenu<FlatColor>(
      componentsConfiguration: DialogComponentsConfiguration<FlatColor>(
        triggerFromItemComponent: TriggerFromItemComponent<FlatColor>(
            builder: _triggerFromItemBuilder),
      ),
      itemSearchMatcher: itemSearchMatcher,
      itemsList: colors,
      itemBuilder: this.itemBuilder,
      onItemSelected: this.onItemSelected,
      showSelectedItemAsTrigger: true,
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
              padding: EdgeInsets.only(top: 70),
              color: Color(0xff95a5a6),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 500,
                    ),
                    SizedBox(
                      child: ExampleApp(),
                      width: 300,
                    ),
                    SizedBox(
                      height: 500,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );

List<FlatColor> colors = FlatColors.colors;
//endregion
