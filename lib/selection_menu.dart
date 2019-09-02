/// A highly customizable Menu (a list of items) to select an item from.
///
/// This library exports two Widgets, [SelectionMenu] and [ListViewMenu].
/// * [ListViewMenu] a list of items to select from.
/// * [SelectionMenu] - opens and closes a [ListViewMenu] by the press of a
///   button/Widget/trigger.
///
/// TODO add links to images with terms.
///
/// ## Basic Usage
///
/// ```dart
/// SelectionMenu<String>(
///   // The list of Items you wish to show in the menu.
///   itemsList: <String>['A','B','C'],
///   // The callback when an item is selected from the menu.
///   onItemSelected: (String selectedItem)
///   {
///     print(selectedItem);
///   },
///   // The builder that builds Widgets out of list items.
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
/// ## Customization
///
/// Every part of [SelectionMenu] and [ListViewMenu] is a Component.
/// These components are defined in the library [components].
/// These are basically builders of Widgets.
///
/// All components are collected under a class [ComponentsConfiguration].
/// It resides in the [configurations] library which also defines some predefined
/// subclasses, or implementations of [ComponentsConfiguration].
///
/// There are two predefined subclasses of [ComponentsConfiguration].
/// * [DropdownComponentsConfiguration] defines a dropdown style appearance and behavior.
/// * [DialogComponentsConfiguration] (default) defines a popup dialog style appearance and behavior.
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

library selection_menu;

import './components_configurations.dart';
import './src/widget/listview_menu.dart';

export './src/widget/listview_menu.dart';
export './src/widget/selection_menu.dart';
export './src/widget_configurers/menu_configuration_classes.dart';
