import 'WidgetBuildingComponent.dart';

/// A mixin that provides methods (hooks) to the lifecycle of the Widget to
/// which the component is assigned.
mixin ComponentLifeCycleMixin on WidgetBuildingComponent {
  void init();
  void dispose();

  void reset() {
    dispose();
    init();
  }
}
