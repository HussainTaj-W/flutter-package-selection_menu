import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';

import 'view_component_builders.dart';

/// Defines the size constraints of the Menu and behavior of Size in certain conditions.
class MenuSizeConfiguration {
  /// Maximum fraction (0.0 - 1.0 inclusive) of screen width the menu should take.
  final double maxWidthFraction;

  /// Maximum fraction (0.0 - 1.0 inclusive) of screen height the menu should take.
  final double maxHeightFraction;

  /// Minimum fraction (0.0 - 1.0 inclusive) of screen width the menu should take.
  final double minWidthFraction;

  /// Minimum fraction (0.0 - 1.0 inclusive) of screen height the menu should take.
  final double minHeightFraction;

  /// Minimum width of menu in logical pixels.
  ///
  /// Takes preference over [minWidthFraction].
  final double minWidth;

  /// Minimum height of menu in logical pixels.
  ///
  /// Takes preference over [minHeightFraction].
  final double minHeight;

  /// Maximum width of menu in logical pixels.
  ///
  /// Takes preference over [maxWidthFraction].
  final double maxWidth;

  /// Maximum height of menu in logical pixels.
  ///
  /// Takes preference over [maxHeightFraction].
  final double maxHeight;

  /// Preferred Width of menu in logical pixels.
  final double width;

  /// Preferred Height of menu in logical pixels.
  final double height;

  /// Defines if the menu's minimum width should be forced to match the width of
  /// the button for the menu.
  ///
  /// [ViewComponentBuilders.menuPositionAndSizeCalculator] has the ability to
  /// override this option's effects.
  final bool enforceMinWidthToMatchButton;

  /// Defines if the menu's maximum width should be forced to match the width of
  /// the button for the menu.
  ///
  /// [ViewComponentBuilders.menuPositionAndSizeCalculator] has the ability to
  /// override this option's effects.
  final bool enforceMaxWidthToMatchButton;

  /// Defines if the menu's height should be forced to remain consistent,
  /// disregarding the available space and position.
  ///
  /// Behavior of this option depends on the implementation of
  /// [ViewComponentBuilders.menuPositionAndSizeCalculator].
  final bool requestConstantHeight;

  /// Defines if the menu should avoid Inset on the bottom, typically caused by
  /// the opened keyboard.
  ///
  /// Behavior of this option depends on the implementation of
  /// [ViewComponentBuilders.menuPositionAndSizeCalculator].
  final bool requestAvoidBottomInset;

  const MenuSizeConfiguration({
    this.maxWidthFraction = 1,
    this.maxHeightFraction = 1,
    this.minWidthFraction = 0,
    this.minHeightFraction = 0,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.width,
    this.height,
    this.enforceMinWidthToMatchButton = false,
    this.enforceMaxWidthToMatchButton = false,
    this.requestConstantHeight = false,
    this.requestAvoidBottomInset = true,
  })  : assert(
            maxWidthFraction >= 0 &&
                maxWidthFraction <= 1 &&
                maxHeightFraction >= 0 &&
                maxHeightFraction <= 1 &&
                minWidthFraction >= 0 &&
                minWidthFraction <= 1 &&
                minHeightFraction >= 0 &&
                minHeightFraction <= 1,
            """Fractions must be between 0.0 and 1.0 (inclusive). 
            Fractions mean the percentage of screen size the menu will use. 
            0.1 means 10% of the screen width/height."""),
        assert(
            maxWidthFraction >= minWidthFraction &&
                maxHeightFraction >= minHeightFraction,
            """Max Width and Max Height should be lesser or equal to Min Width and Min Height respectively.
                AKA, the contrainsts should be normalized."""),
        assert(minWidth == null || maxWidth == null || minWidth <= maxWidth,
            """minWidth should be less than or equal to maxWidth."""),
        assert(minHeight == null || maxHeight == null || minHeight <= maxHeight,
            """minHeight should be less than or equal to maxHeight.""");
}

/// Container for Menu's constraints and position.
class MenuPositionAndSize {
  /// BoxConstraints for the menu.
  final BoxConstraints constraints;

  /// Offset of top-left corner Menu, where top-left corner of the button is the origin.
  final Offset positionOffset;

  const MenuPositionAndSize({
    @required this.constraints,
    @required this.positionOffset,
  }) : assert(constraints != null && positionOffset != null,
            "Both positionOffset and constraints are required to place the menu in place");
}

/// Animation States the menu goes through during opening and closing.
enum MenuAnimationState {
  OpeningStart,
  OpeningEnd,
  Opened,
  ClosingStart,
  ClosingEnd,
  Closed,
}

/// A collection of flex attributes of Flexible/Expanded Widgets used in menu layout.
class MenuFlexValues {
  final int searchField;
  final int searchingIndicator;
  final int listView;
  final int searchBarContainer;

  const MenuFlexValues({
    this.searchBarContainer,
    this.searchField,
    this.searchingIndicator,
    this.listView,
  });
}

class MenuAnimationDurations {
  /// Duration of animation when menu is opening.
  final Duration forward;

  /// Duration of animation when menu is closing.
  final Duration backward;

  const MenuAnimationDurations(
      {@required this.forward, @required this.backward})
      : assert(forward != null && backward != null,
            """Both Durations are required. 
            If there is no animation required then pass Duration.zero.""");
}
