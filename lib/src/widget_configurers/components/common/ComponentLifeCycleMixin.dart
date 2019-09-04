import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

import 'WidgetBuildingComponent.dart';

/// A mixin that provides methods (hooks) to the lifecycle of the Widget to
/// which the component is assigned.
///
/// The lifeCycle of [AnimationComponent], [TriggerFromItemComponent],
/// and [TriggerComponent] is linked to [SelectionMenu].
/// The other Component's lifecycle is linked to [ListViewMenu].
mixin ComponentLifeCycleMixin on WidgetBuildingComponent {
  void init();
  void dispose();

  void reset() {
    dispose();
    init();
  }
}
