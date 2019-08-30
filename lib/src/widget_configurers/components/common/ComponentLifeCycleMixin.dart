import 'WidgetBuildingComponent.dart';

mixin ComponentLifeCycleMixin on WidgetBuildingComponent {
  void init();
  void dispose();

  void reset() {
    dispose();
    init();
  }
}
