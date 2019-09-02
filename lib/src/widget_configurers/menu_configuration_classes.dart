import 'package:flutter/widgets.dart';
import 'package:selection_menu/components_configurations.dart';

/// Defines the size constraints of the Menu and behavior of Size in certain conditions.
///
/// Constraints must be provided, these can be in the form of screen fractions,
/// logical pixels or mixed.
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
  ///
  /// Preferred over [widthFraction];
  final double width;

  /// Preferred Height of menu in logical pixels.
  ///
  /// Preferred over [heightFraction];
  final double height;

  /// Preferred Width of menu in fraction (0.0 - 1.0 inclusive) of screen width.
  final double widthFraction;

  /// Preferred Height of menu in fraction (0.0 - 1.0 inclusive) of screen height.
  final double heightFraction;

  /// Defines if the menu's minimum width should be forced to match the width of
  /// the button for the menu.
  ///
  /// [ComponentsConfiguration.menuPositionAndSizeComponent] has the ability to
  /// override this option's effects.
  final bool enforceMinWidthToMatchTrigger;

  /// Defines if the menu's maximum width should be forced to match the width of
  /// the button for the menu.
  ///
  /// [ComponentsConfiguration.menuPositionAndSizeComponent] has the ability to
  /// override this option's effects.
  final bool enforceMaxWidthToMatchTrigger;

  /// Defines if the menu's height should be forced to remain consistent,
  /// disregarding the available space and position.
  ///
  /// Behavior of this option depends on the implementation of
  /// [ComponentsConfiguration.menuPositionAndSizeComponent].
  final bool requestConstantHeight;

  /// Defines if the menu should avoid Inset on the bottom, typically caused by
  /// the opened keyboard.
  ///
  /// Behavior of this option depends on the implementation of
  /// [ComponentsConfiguration.menuPositionAndSizeComponent].
  final bool requestAvoidBottomInset;

  const MenuSizeConfiguration({
    this.maxWidthFraction,
    this.maxHeightFraction,
    this.minWidthFraction,
    this.minHeightFraction,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.width,
    this.height,
    this.widthFraction,
    this.heightFraction,
    this.enforceMinWidthToMatchTrigger = false,
    this.enforceMaxWidthToMatchTrigger = false,
    this.requestConstantHeight = false,
    this.requestAvoidBottomInset = true,
  })  : assert(minWidth != null || minWidthFraction != null,
            '''No minimum width provided. 
        At least one of minWidth or minWidthFraction must not be null.'''),
        assert(maxWidth != null || maxWidthFraction != null,
            '''No maximum width provided. 
        At least one of maxWidth or maxWidthFraction must not be null.'''),
        assert(minHeight != null || minHeightFraction != null,
            '''No minimum height provided. 
        At least one of minHeight or minHeightFraction must not be null.'''),
        assert(maxHeight != null || maxHeightFraction != null,
            '''No maximum height provided. 
        At least one of maxHeight or maxHeightFraction must not be null.'''),
        assert(
            (maxWidthFraction == null ||
                    minWidthFraction == null ||
                    maxWidthFraction >= minWidthFraction) &&
                (maxHeightFraction == null ||
                    minHeightFraction == null ||
                    maxHeightFraction >= minHeightFraction),
            """Max Width and Max Height should be lesser or equal to Min Width and Min Height respectively.
                AKA, the contrainsts should be normalized."""),
        assert(minWidth == null || maxWidth == null || minWidth <= maxWidth,
            """minWidth should be less than or equal to maxWidth."""),
        assert(minHeight == null || maxHeight == null || minHeight <= maxHeight,
            """minHeight should be less than or equal to maxHeight.""");

  /// Returns BoxConstraints calculated from the configuration.
  BoxConstraints getConstraints(Size triggerSize, Size screenSize) {
    assert(triggerSize != null && screenSize != null,
        "Constraints cannot be constructed if triggerSize and screensize Both are available.");

    double minWidth = (this.enforceMinWidthToMatchTrigger
        ? triggerSize.width
        : this.minWidth ?? minWidthFraction * screenSize.width);
    double maxWidth = (this.enforceMaxWidthToMatchTrigger
        ? triggerSize.width
        : this.maxWidth ?? screenSize.width * this.maxWidthFraction);

    double maxHeight =
        this.maxHeight ?? screenSize.height * this.maxHeightFraction;
    double minHeight =
        this.minHeight ?? this.minHeightFraction * screenSize.height;

    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    ).normalize();
  }

  /// Returns Size calculated from the configuration.
  Size getPreferredSize(Size screenSize) {
    if ((width != null || widthFraction != null) &&
        (height != null || heightFraction != null)) {
      return Size(
        width ?? widthFraction * screenSize.width,
        height ?? heightFraction * screenSize.height,
      );
    }
    return null;
  }
}

/// Container for Menu's constraints and, position and size.
class MenuPositionAndSize {
  /// Size of menu is defined by BoxConstraints.
  final BoxConstraints constraints;

  /// Preferred size of the menu.
  final Size size;

  /// Offset of top-left corner Menu, where top-left corner of the button is the origin.
  final Offset positionOffset;

  const MenuPositionAndSize({
    @required this.constraints,
    @required this.positionOffset,
    this.size,
  }) : assert(constraints != null && positionOffset != null,
            "Both positionOffset and constraints are required to place the menu in place");
}

/// Container for Trigger's Size and position.
class TriggerPositionAndSize {
  /// BoxConstraints for the menu.
  Size size;

  /// Offset of top-left corner Menu, where top-left corner of the **visible**
  /// screen is the origin.
  Offset position;

  TriggerPositionAndSize({
    @required this.size,
    @required this.position,
  }) : assert(size != null && position != null,
            "Both position and size are required.");
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
///
/// See:
/// * [SearchBarComponent].
/// * [MenuComponent].
class MenuFlexValues {
  final int searchField;
  final int searchingIndicator;
  final int listView;
  final int searchBar;

  const MenuFlexValues({
    this.searchBar,
    this.searchField,
    this.searchingIndicator,
    this.listView,
  });
}

class MenuAnimationDurations {
  /// Duration of animation when menu is opening.
  final Duration forward;

  /// Duration of animation when menu is closing.
  final Duration reverse;

  const MenuAnimationDurations({@required this.forward, @required this.reverse})
      : assert(
            forward != null && reverse != null, """Both Durations are required. 
            If there is no animation required then pass Duration.zero.""");
}
