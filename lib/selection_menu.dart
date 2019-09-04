/// A highly customizable Menu (a list of items) to select an item from.
///
/// This library exports two Widgets, [SelectionMenu] and [ListViewMenu].
/// * [SelectionMenu] - opens and closes a [ListViewMenu] by the use of a
///   button/Widget/trigger.
/// * [ListViewMenu] a list of items to select from.
///
/// TODO Gif to Select menu.
///
/// # Basic Usage
///
/// ```dart
/// SelectionMenu<String>(
///   itemsList: <String>['A','B','C'],
///   onItemSelected: (String selectedItem)
///   {
///     print(selectedItem);
///   },
///   itemBuilder: (BuildContext context, String item)
///   {
///     return Text(item);
///   },
///   // Select the style of menu you wish to use.
///   componentsConfiguration: DialogComponentConfiguration<String>();
/// );
/// ```
///
/// TODo Explanations of terminology used throughout the library.
/// todo A couple of complete code samples that walk through using the API.
/// todo Links to the most important or most commonly used classes and functions.
/// todo Links to external references on the domain the library is concerned with.
///
/// # Customization
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
///
/// See the [components_configurations] library for more details.
///
/// [MenuSizeConfiguration] used as [ComponentsConfiguration.menuSizeConfiguration]
/// defines the Size constraints of the Menu and behaviour in different conditions.
///
/// TODO add docs.
/// TODO add github repo.
/// TODO add examples.
///
/// See also:
/// * [SelectionMenu].
/// * [ListViewMenu].
/// * [ComponentsConfiguration].
///
/// # Examples
///
/// A series of detailed examples are available [here][examples link].
///
/// [Github Repo][repo link].
///
/// [examples link]: https://github.com/HussainTaj-W/flutter-package-selection_menu/tree/master/example
///
/// [components image link]: https://i.imgur.com/QL67eib.jpg =658x384
///
/// [repo link]: https://github.com/HussainTaj-W/flutter-package-selection_menu
/// {@category Configurations}
library selection_menu;

import './components_configurations.dart';
import './src/widget/listview_menu.dart';

export './src/widget/listview_menu.dart';
export './src/widget/selection_menu.dart';
export './src/widget_configurers/menu_configuration_classes.dart';
