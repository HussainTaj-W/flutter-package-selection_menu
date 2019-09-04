import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

import '../data/FlatColor.dart';

// Reading previous Examples before this one is recommended.
//
// Code from previous example will have their comments or sections removed, simplified, and
// moved to the end of the file to allow meaningful code to stay up top. Please
// do not consider this example as an optimal way to place your code.
//
// main function has been moved to the end.

class ExampleApp extends StatelessWidget {
  static Widget _triggerBuilder(TriggerComponentData data) {
    String menuState = data.menuState.toString();
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: data.triggerMenu,
      child: Text(
        menuState,
        style: TextStyle(),
      ),
    );
  }

  static Widget _triggerFromItemBuilder(TriggerFromItemComponentData data) {
    String menuState = data.menuState.toString();

    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: data.triggerMenu,
      color: Color(data.item.hex),
      child: Text(
        menuState,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  static Widget _menuBuilder(MenuComponentData data) {
    FlatColor selectedItem = data.selectedItem as FlatColor;

    Widget currentItem = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "Currently Selected: ",
          style: Theme.of(data.context).textTheme.body1.copyWith(fontSize: 10),
        ),
        ClipOval(
            child: SizedBox(
          width: 10,
          height: 10,
          child: Container(
            color: Color(selectedItem?.hex ?? Colors.transparent.value),
          ),
        ))
      ],
    );
    return Column(
      children: <Widget>[
        data.isSearchEnabled
            ? Flexible(
                child: data.searchBar,
                flex: data.menuFlexValues.searchBar,
              )
            : Container(),
        currentItem,
        Expanded(
          child: data.listView,
          flex: data.menuFlexValues.listView,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectionMenu<FlatColor>(
      closeMenuOnItemSelected: false,
      componentsConfiguration:
          DropdownComponentsConfiguration<FlatColor>().copyWith(
        triggerComponent: TriggerComponent(builder: _triggerBuilder),
        triggerFromItemComponent:
            TriggerFromItemComponent(builder: _triggerFromItemBuilder),
        menuSizeConfiguration:
            DialogComponentsConfiguration.defaultMenuSizeConfiguration,
        menuComponent: MenuComponent(builder: _menuBuilder),
        menuAnimationDurations: MenuAnimationDurations(
            forward: Duration(seconds: 1), reverse: Duration(seconds: 1)),
      ),
      itemsList: colors,
      itemBuilder: this.itemBuilder,
      onItemSelected: this.onItemSelected,
      showSelectedItemAsTrigger: true,
    );
  }

  //region From Previous Example

  Widget itemBuilder(
      BuildContext context, FlatColor color, OnItemTapped onItemTapped) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Container(
      child: InkWell(
        onTap: onItemTapped,
        highlightColor: Color(color.hex).withAlpha(100),
        splashColor: Color(color.hex),
        child: Container(
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
              ),
          buttonTheme: ThemeData.light().buttonTheme,
        ),
        home: Material(
          child: SafeArea(
            child: Container(
              color: Color(0xff95a5a6),
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 300,
                    child: ExampleApp(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

List<FlatColor> colors = FlatColors.colors;
//endregion
