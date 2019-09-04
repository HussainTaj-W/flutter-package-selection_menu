# Extending Components
*Example: 2_intermediate_04*

<!-- TODO add reference to docs -->

![Components Image](../data/selection_menu%20anatomy%20components.jpg)

## Code Highlights

```dart
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/components_configurations.dart';

class CustomSearchingIndicatorComponent
    extends SearchingIndicatorComponent 
    // A required mixin if you want to hook into the Menu's life cycle
    with
        ComponentLifeCycleMixin {

  // A Component lives as long as SelectionMenu lives.
  // However, you can hook to SelectionMenu or ListViewMenu's dispose 
  // and init methods.
  
  // Instance variables...
  CustomSearchingIndicatorComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchingIndicatorComponentData data) {
    // Implementation...
  }

  @override
  void dispose() {
    // Implementation...
  }

  @override
  void init() {
    // Implementation...
  }
}

SelectionMenu<FlatColor>(
    componentsConfiguration:
        DialogComponentsConfiguration<FlatColor>(
          searchingIndicatorComponent: CustomSearchingIndicatorComponent()
        ),
    ),
    // Other Properties...
  );
```

For complete code, explained with details, see [main.dart](./main.dart).
## Result

![Result Gif](./2_04.gif)