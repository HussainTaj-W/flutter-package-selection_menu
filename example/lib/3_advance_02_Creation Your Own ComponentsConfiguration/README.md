# Creating Your Own ComponentsConfiguration
*Example: 3_advance_02*

<!-- TODO add reference to docs -->

![Components Image](../data/selection_menu%20anatomy%20components.jpg)

## Code Highlights

```dart
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/components_configurations.dart';

// It's a good idea to copy the constructor from a predefined 
// ComponentsConfiguration and edit it.
class CircularWindowComponentsConfiguration<T>
    extends ComponentsConfiguration<T> {
  final double navigationButtonSize;
  final double itemSize;

  CircularWindowComponentsConfiguration({
    this.navigationButtonSize = 40,
    this.itemSize = 100,
    //
    //...
  }) : super(
          listViewComponent: listViewComponent ??
              CircularWindowListViewComponent(
                  itemSize: itemSize,),
          // ...
        );

  static MenuFlexValues defaultMenuFlexValues = MenuFlexValues(
    //...
  );

  static MenuSizeConfiguration defaultMenuSizeConfiguration =
      MenuSizeConfiguration(
      //...
  );

  static MenuAnimationDurations defaultMenuAnimationDurations =
      const MenuAnimationDurations(
    //...
  );

  static MenuAnimationCurves defaultMenuAnimationCurves =
    //...
  );
}

class CircularWindowSearchFieldComponent extends SearchFieldComponent {
  //...
}

class CircularWindowSearchingIndicatorComponent
    extends SearchingIndicatorComponent {
  //...
}

class CircularWindowSearchBarComponent extends SearchBarComponent {
  //...
}

class CircularWindowListViewComponent extends ListViewComponent {
 //...
}

class CircularWindowMenuComponent extends MenuComponent {
  //...
}

class CircularWindowAnimationComponent extends AnimationComponent
    with ComponentLifeCycleMixin {
 //...
}

class CircularWindowMenuPositionAndSizeComponent
    extends MenuPositionAndSizeComponent {
  //...
}

class CircularWindowTriggerComponent extends TriggerComponent {
  //...
}

```

For complete code, explained with details, see [main.dart](./main.dart).
## Result

![Result Gif](./3_02.gif)