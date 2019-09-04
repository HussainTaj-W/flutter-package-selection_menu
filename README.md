# selection_menu

A highly customizable selection/select menu to choose an item from a list.

[Select Menu in different styles](https://i.imgur.com/a5FfkD6.gif)

## Getting Started

This package has two libraries:
* selection_menu: provides the widgets.
* components_configurations: provides customization options.

### Basic Usage

```dart
import 'package:selection_menu/selection_menu.dart';

SelectionMenu<String>(
    itemsList: <String>['A','B','C'],
    onItemSelected: (String selectedItem)
    {
    print(selectedItem);
    },
    itemBuilder: (BuildContext context, String item, OnItemTapped onItemTapped)
    {
       return Material(
         InkWell(
           onTap: onItemTapped,
           child: Text(item),
         ),
       ); 
    },
);
 ```
 
 