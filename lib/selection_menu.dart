/// A highly customizable Menu (a list of items) to select an item from.
///
/// This library exports two Widget, [SelectionMenu] and [ListViewMenu].
/// * [ListViewMenu] a Menu of items to select from, uses a List view.
///   See [ListViewMenu] for more details.
/// * [SelectionMenu] - opens and closes a menu by the press of a button/Widget.
///   Internally uses [ListViewMenu]. See [SelectionMenu] for more details.
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
///   viewComponentBuilders: DialogViewComponentBuilders<String>();
/// );
/// ```
///
/// There are several options to discover.
/// See [SelectionMenu] for details.
///
/// TODo Explanations of terminology used throughout the library.
/// todo A couple of complete code samples that walk through using the API.
/// todo Links to the most important or most commonly used classes and functions.
/// todo Links to external references on the domain the library is concerned with.
///
/// ## Customization
///
/// There are various customization options. The most important class is the
/// [ComponentsConfiguration]. This base class contains methods as instance variables
/// that define the visual appearance of the menu list and button.
/// SubClasses add definitions of these instance variables.
///
/// There are two predefined subclasses of [ComponentsConfiguration].
/// * [DropdownComponentsConfiguration] defines a dropdown style appearance and behavior.
/// * [DialogComponentsConfiguration] (default) defines a popup dialog style appearance and behavior.
///
/// [MenuSizeConfiguration] used as [ComponentsConfiguration.menuSizeConfiguration]
/// defines the Size constraints of the Menu and behaviour in different conditions.
///
/// See [ComponentsConfiguration] for details.
///
/// TODO add docs.
/// TODO add github repo.
/// TODO add examples.

library selection_menu;

import './src/widget/listview_menu.dart';
import './src/widget/selection_menu.dart';
import './src/widget_configurers/configurations/configurations.dart';

export './src/widget/listview_menu.dart';
export './src/widget/selection_menu.dart';
export './src/widget_configurers/configurations/configurations.dart';
