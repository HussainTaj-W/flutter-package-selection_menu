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
            DialogComponentsConfiguration<FlatColor>().copyWith(
          listViewComponent: ListViewComponent(builder: _listViewBuilder),
          // A Component that builds the scrollable list in which items are shown.
          //
          // Defined below for brevity.

          menuComponent: MenuComponent(builder: _menuBuilder),
          // A Component that combines SearchBar and ListView.
          // Much like how SearchBar combines SearchField and Searching Indicator.
          //
          // Defined below for brevity.

          triggerComponent: TriggerComponent(builder: _triggerBuilder),
          triggerFromItemComponent:
              TriggerFromItemComponent(builder: _triggerFromItemBuilder),
        ),
        itemSearchMatcher: itemSearchMatcher,
        itemsList: colors,
        itemBuilder: this.itemBuilder,
        onItemSelected: this.onItemSelected,
        showSelectedItemAsTrigger: true,
      ),
    );
  }

  static Widget _menuBuilder(MenuComponentData data) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: data.menuFlexValues.searchBar,
          child: RotatedBox(
            quarterTurns: 3,
            child: data.searchBar,
          ),
        ),
        Expanded(
          child: data.listView,
          flex: data.menuFlexValues.listView,
        ),
      ],
    );
  }

  static Widget _listViewBuilder(ListViewComponentData data) {
    return ListView.separated(
      itemBuilder: data.itemBuilder,
      itemCount: data.itemCount,
      // It is important that you pass itemBuilder and itemCount to your ListView,
      // these are managed by SelectionMenu itself.
      separatorBuilder: (context, _) {
        return Container(
          height: 1,
          color: Colors.black26,
        );
      },
      padding: EdgeInsets.zero,
    );
  }

  //region From Previous Example

  static Widget _triggerBuilder(TriggerComponentData data) {
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: data.triggerMenu,
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

  Widget itemBuilder(
      BuildContext context, FlatColor color, OnItemTapped onItemTapped) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;

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
