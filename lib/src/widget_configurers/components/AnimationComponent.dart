import 'package:flutter/widgets.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/src/widget_configurers/menu_configuration_classes.dart';

import 'common/ComponentAssertionMessages.dart';
import 'common/ComponentData.dart';
import 'common/WidgetBuildingComponent.dart';

/// Data that might be used in [AnimationComponent.builder].
class AnimationComponentData implements ComponentData {
  /// [BuildContext] passed by [SelectionMenu].
  ///
  /// Must not be null.
  @override
  final BuildContext context;

  /// The Widget this component has to animate, typically it is the Menu.
  ///
  /// Must not be null.
  final Widget child;

  /// Must not be null.
  ///
  /// See [MenuAnimationState].
  final MenuAnimationState menuAnimationState;

  /// Constraints of the menu.
  ///
  /// Must not be null.
  final BoxConstraints constraints;

  /// Must not be null.
  ///
  /// See [MenuAnimationDurations].
  final MenuAnimationDurations menuAnimationDurations;

  /// Must not be null.
  final TickerProvider tickerProvider;

  AnimationComponentData({
    @required this.context,
    @required this.constraints,
    @required this.tickerProvider,
    @required this.menuAnimationDurations,
    @required this.menuAnimationState,
    @required this.child,
    @required this.selectedItem,
  }) : assert(
            context != null &&
                constraints != null &&
                tickerProvider != null &&
                menuAnimationState != null &&
                child != null &&
                menuAnimationDurations != null,
            ComponentAssertionMessages.nullAttributeInData);

  @override
  final dynamic selectedItem;
}

/// Defines builder that returns a Widget acts as a container that is capable
/// of animation.
///
/// Additionally, this Component is responsible for enforcing the menu
/// constraints, pre-calculated constraints by [MenuPositionAndSizeComponent]
/// are passed as [AnimationComponentData.constraints].
///
/// Implicit animations work well. However, explicit animation might require
/// this component to be extended so that more instance variables can be introduced.
/// For instance, you might want to store an [AnimationController] as an instance
/// variable.
///
/// **Example**
///
/// ```dart
/// AnimationComponent(
///   builder: (AnimationComponentData data)
///   {
///     return Opacity(
///       opacity: data.menuAnimationState == MenuAnimationState.OpeningEnd ? 1.0 : 0.0,
///       child: data.child,
///     );
///   }
/// );
/// ```
///
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [AnimationComponentData]
/// * [AnimationBuilder]
class AnimationComponent implements WidgetBuildingComponent {
  /// A builder method to create the animating Widget.
  ///
  /// This builder is called for every [AnimationComponentData.menuAnimationState]
  /// except [MenuAnimationState.Closed].
  ///
  /// See also:
  /// * [AnimationBuilder].
  AnimationBuilder builder;

  /// See [AnimationBuilder].
  AnimationComponent({@required this.builder});

  /// The method uses the [AnimationComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [SelectionMenu].
  Widget build(AnimationComponentData data) {
    assert(
        data != null, ComponentAssertionMessages.nullDataPassedToBuildMethod);
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder(data);
  }
}

/// This typedef defines a method that returns a Widget that is capable of
/// animation.
///
/// Used by [AnimationComponent] as [AnimationComponent.builder].
///
/// **Example**
///
/// ```dart
/// AnimationComponent(
///   builder: (AnimationComponentData data)
///   {
///     return Opacity(
///       opacity: data.menuAnimationState == MenuAnimationState.OpeningEnd ? 1.0 : 0.0,
///       child: data.child,
///     );
///   }
/// );
/// ```
///
/// See Also:
/// * [AnimationComponent]
/// * [AnimationComponentData]

typedef Widget AnimationBuilder(AnimationComponentData data);
