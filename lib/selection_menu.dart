/// A highly customizable Menu (a list of items) to select an item from.
///
/// This library exports two Widgets, [SelectionMenu] and [ListViewMenu].
/// * [SelectionMenu] - opens and closes a [ListViewMenu] by the use of a
///   button/Widget/trigger.
/// * [ListViewMenu] a list of items to select from.
///
/// ![Select Menu in different styles](https://i.imgur.com/a5FfkD6.gif)
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:selection_menu/selection_menu.dart';
///
/// SelectionMenu<String>(
///   itemsList: <String>['A','B','C'],
///   onItemSelected: (String selectedItem)
///   {
///     print(selectedItem);
///   },
///   itemBuilder: (BuildContext context, String item, OnItemTapped onItemTapped)
///   {
///     return Material(
///       InkWell(
///         onTap: onItemTapped,
///         child: Text(item),
///       ),
///     );
///   },
/// );
/// ```
///
/// **A series of detailed examples are available
/// [here](https://github.com/HussainTaj-W/flutter-package-selection_menu/tree/master/example).**
///
/// ## Customization
///
/// Customization is possible through the use of Component classes.
/// Every part of [SelectionMenu] and [ListViewMenu] is a Component.
///
/// <img src="https://i.imgur.com/QL67eib.jpg" width="658.5" height="384"/>
///
/// All components are collected in a class [ComponentsConfiguration].
/// There are some predefined subclasses, or implementations of [ComponentsConfiguration].
///
/// There are two predefined subclasses of [ComponentsConfiguration].
/// * [DropdownComponentsConfiguration] defines a dropdown style appearance and behavior.
/// * [DialogComponentsConfiguration] (default) defines a popup dialog style appearance and behavior.
/// The third style in the above image is part of the example series.
///
/// **Example**
///
///
/// ```dart
/// import 'package:selection_menu/selection_menu.dart';
///
/// // IMPORT this package to get access to configuration classes.
/// import 'package:selection_menu/components_configurations.dart';
///
/// SelectionMenu<String>(
///   itemsList: <String>['A','B','C'],
///   onItemSelected: (String selectedItem)
///   {
///     print(selectedItem);
///   },
///   itemBuilder: (BuildContext context, String item, OnItemTapped onItemTapped)
///   {
///     return Material(
///       InkWell(
///         onTap: onItemTapped,
///         child: Text(item),
///       ),
///     );
///   },
///   componentsConfigurations: DropdownComponentsConfigurations<String>(),
/// );
/// ```
///
/// See the [components_configurations] library for more details.
///
/// ## Examples
///
/// A series of detailed examples are available
/// [here](https://github.com/HussainTaj-W/flutter-package-selection_menu/tree/master/example).
///
/// [Github Repo](https://github.com/HussainTaj-W/flutter-package-selection_menu).
///
/// See also:
/// * [SelectionMenu].
/// * [ListViewMenu].
/// * [ComponentsConfiguration].
library selection_menu;

import './components_configurations.dart';
import './src/widget/listview_menu.dart';

export './src/widget/listview_menu.dart';
export './src/widget/selection_menu.dart';
