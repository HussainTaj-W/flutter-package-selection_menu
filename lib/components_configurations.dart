/// Provides classes to customize [SelectionMenu] and/or [ListViewMenu].
///
/// It is the combination of libraries [components] and [configurations].
///
/// [components] provides classes to describe specific parts of the Widget.
/// [configurations] provides definitions of [components] in a [ComponentsConfiguration],
/// which is used by [SelectionMenu] or [ListViewMenu].

library components_configurations;

//
import 'package:selection_menu/selection_menu.dart';

import './src/widget_configurers/configurations/configurations.dart';

export './src/widget_configurers/components/components.dart';
export './src/widget_configurers/configurations/configurations.dart';
