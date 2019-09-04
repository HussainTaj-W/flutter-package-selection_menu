/// Provides classes to customize [SelectionMenu] and/or [ListViewMenu].
///
/// There are two parts of this library, **Components** and
/// **Components Configurations**.
///
/// # Components Configurations
/// [ComponentsConfiguration] is a base class that defines the appearance of
/// [SelectionMenu] and [ListViewMenu].
///
/// It is simply a collection of [components](#components) and configurations.
///
/// This class can be subclassed. The subclass would assign values to the instance
/// variables of [ComponentsConfiguration].
/// The subclasses can then be passed to [SelectionMenu.componentsConfiguration]
/// or [ListViewMenu.componentsConfiguration].
///
/// Two predefined subclasses are:
/// * [DialogComponentsConfiguration] a dialog or popup style appearance.
/// * [DropdownComponentsConfiguration] a dropdown style appearance.
///
/// # Components
///
/// <img src="https://i.imgur.com/QL67eib.jpg" />
///
/// Components are classes that can be used to configure [ComponentsConfiguration].
///
/// Each component defines a specific UI related part of the [SelectionMenu] or
/// [ListViewMenu].
///
/// Components follow a similar pattern.
/// Take for example a component called **X**.
///
/// The library provides:
///
/// * Class: **X**Component. [SearchFieldComponent] for example.
/// * Class: **X**ComponentData. [SearchFieldComponentData] for example.
/// * Function Type: **X**Builder. [SearchFieldBuilder] for example.
///
/// _XComponentData_ contains data that might be required during the process of
/// building. Like [SearchFieldComponentData.context].
///
/// _XComponent_ carries a builder method of type _XBuilder_ which takes an
/// instance of _XComponentData_ as a parameter.
///
/// Like so:
///
/// ```dart
/// XComponent(
///   builder: instanceOfXBuilder(XComponentData data)
///   {
///     //implementation.
///   }
/// );
/// ```
///
/// These classes can also be extended like so:
///
/// ```dart
/// class XComponentSub extends XComponent
/// {
///   String myTempString;
///   XComponentSub()
///   {
///     //...
///     super.builder = _builder;
///   }
///
///   Widget _builder()
///   {
///     // implementation...
///   }
/// }
/// ```
///
/// If your class needs to access the Widgets life cycle, for example the
/// dispose method, you can use [ComponentLifeCycleMixin].
///
/// # Examples
/// A series of detailed examples are available [here][examples link].
///
/// [Github Repo][repo link].
///
/// [examples link]: https://github.com/HussainTaj-W/flutter-package-selection_menu/tree/master/example
///
/// [components image link]: https://i.imgur.com/QL67eib.jpg =658x384
///
/// [repo link]: https://github.com/HussainTaj-W/flutter-package-selection_menu

/// {@category Components}
library components_configurations;

//
import 'package:selection_menu/selection_menu.dart';

import './src/widget_configurers/components/components.dart';
import './src/widget_configurers/configurations/configurations.dart';

export './src/widget_configurers/components/components.dart';
export './src/widget_configurers/configurations/configurations.dart';
