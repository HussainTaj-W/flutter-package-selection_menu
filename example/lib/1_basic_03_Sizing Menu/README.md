# Sizing Menu
*Example: 1_basic_03*

## Code Highlights

```dart
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/components_configurations.dart';

SelectionMenu<FlatColor>(
    menuSizeConfiguration: MenuSizeConfiguration(
      // min, max Width and min, max Height, all must be provided in
      // either fractions, pixels or mixed.
    
      maxHeightFraction: 0.5,
      // Maximum Fraction of screen height that the menu should take.
      //
      // Fractions mean the percentage of the screen width or height.
      //
      // Defaults to null.
      //
      // maxWidthFraction, minWidthFraction, minHeightFraction are similar.
      maxWidthFraction: 1.0,

      minWidth: 100,
      // Defaults to null. These are flutter's logical pixel values.
      //
      // maxWidth, minHeight, maxHeight are similar.
      // These values take preference over the fraction based counterparts,
      // when size is calculated.
      minHeight: 200,
      
      // There are many other important properties, see the main.dart
      // file or TODO: API Reference
    ),
    //Other properties...
  );
```

For complete code, explained with details, see [main.dart](./main.dart).
## Result

![Result Gif](./1_03.gif)

