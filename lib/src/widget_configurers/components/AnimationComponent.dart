import 'package:flutter/widgets.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

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
  /// See [MenuState].
  final MenuState? menuState;

  /// Constraints of the menu.
  ///
  /// Must not be null.
  final BoxConstraints? constraints;

  /// Must not be null.
  ///
  /// See [MenuAnimationDurations].
  final MenuAnimationDurations menuAnimationDurations;

  /// Must not be null.
  final TickerProvider tickerProvider;

  final MenuAnimationCurves menuAnimationCurves;

  final MenuStateChanged opened;
  final MenuStateChanged closed;
  final MenuStateWillChangeAfter willOpenAfter;
  final MenuStateWillChangeAfter willCloseAfter;

  @override
  final dynamic selectedItem;

  AnimationComponentData({
    required this.context,
    required this.constraints,
    required this.tickerProvider,
    required this.menuAnimationDurations,
    required this.menuState,
    required this.child,
    required this.selectedItem,
    required this.opened,
    required this.closed,
    required this.willOpenAfter,
    required this.willCloseAfter,
    required this.menuAnimationCurves,
  });
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
///       opacity: data.menuState == MenuAnimationState.OpeningEnd ? 1.0 : 0.0,
///       child: data.child,
///     );
///   }
/// );
/// ```
///
/// A series of detailed examples are available
/// [here](https://github.com/HussainTaj-W/flutter-package-selection_menu-example).
///
/// <img src="https://i.imgur.com/QL67eib.jpg" width="658.5" height="384"/>
///
/// See [ComponentsConfiguration] for more details.
///
/// See Also:
/// * [AnimationComponentData]
/// * [AnimationBuilder]
class AnimationComponent implements WidgetBuildingComponent {
  /// A builder method to create the animating Widget.
  ///
  /// This builder is called for every [AnimationComponentData.menuState]
  /// except [MenuState.Closed].
  ///
  /// See also:
  /// * [AnimationBuilder].
  AnimationBuilder? builder;

  /// See [AnimationBuilder].
  AnimationComponent({this.builder});

  /// The method uses the [AnimationComponent.builder] method to actually
  /// build the Widget.
  ///
  /// [data] Must not be null.
  ///
  /// Used by [SelectionMenu].
  Widget build(AnimationComponentData data) {
    assert(builder != null, ComponentAssertionMessages.nullBuilderMethod);
    return builder!(data);
  }
}

/// Defines a method that returns a Widget that is capable of
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
///       opacity: data.menuState == MenuAnimationState.OpeningEnd ? 1.0 : 0.0,
///       child: data.child,
///     );
///   }
/// );
/// ```
///
/// See Also:
/// * [AnimationComponent].
/// * [AnimationComponentData].
/// * [MenuState].
typedef AnimationBuilder = Widget Function(AnimationComponentData data);

/// A callback that informs about Menu state change.
///
/// It is used by [AnimationComponent] to communicate with [SelectionMenu].
typedef MenuStateChanged = void Function();

/// A callback that informs about Menu state change that will occur after [time].
///
/// It is used by [AnimationComponent] to communicate with [SelectionMenu].
typedef MenuStateWillChangeAfter = void Function(Duration time);
