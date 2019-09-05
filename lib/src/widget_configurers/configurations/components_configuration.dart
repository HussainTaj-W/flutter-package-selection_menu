import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/src/widget_configurers/components/components.dart';
import 'package:selection_menu/src/widget_configurers/menu_configuration_classes.dart';

/// A base class that define the appearance of [SelectionMenu] and [ListViewMenu].
///
/// It is simply a collection of [components] and configurations.
///
/// A Component is a class with a builder method that returns a Widget,
/// or Position and Size information, or simply a class that contains data related
/// to layout.
///
/// <img src="https://i.imgur.com/QL67eib.jpg" width="658.5" height="384"/>
///
/// This class can be subclassed. The subclass would assign values to the instance
/// variables of [ComponentsConfiguration].
/// The subclasses can then be passed to [SelectionMenu.componentsConfiguration]
/// or [ListViewMenu.componentsConfiguration].
///
/// Two predefined subclasses are:
/// * [DialogComponentsConfiguration] a dialog or popup style appearance.
/// * [DropdownComponentsConfiguration] a dropdown style appearance.
///
/// **Related examples can be found
/// [here](https://github.com/HussainTaj-W/flutter-package-selection_menu-example).**
class ComponentsConfiguration<T> {
  /// Defines a builder that returns a Widget where a user can input text.
  ///
  /// See [SearchFieldComponent].
  final SearchFieldComponent searchFieldComponent;

  /// Returns a Widget that wraps [SearchBarComponent] and [ListViewMenu].
  ///
  /// See [MenuComponent].
  final MenuComponent menuComponent;

  /// Returns a Widget that acts as a button(trigger) to open/close menu.
  ///
  /// See [TriggerComponent].
  final TriggerComponent triggerComponent;

  /// Returns a Widget that acts as a trigger(like a button for example) to
  /// open/close menu, where the trigger reflects the currently selected item.
  ///
  /// See [TriggerFromItemComponent] for more details.
  final TriggerFromItemComponent<T> triggerFromItemComponent;

  /// Returns a [MenuSizeAndPosition] after performing some calculation.
  ///
  /// See [MenuPositionAndSizeComponent].
  final MenuPositionAndSizeComponent menuPositionAndSizeComponent;

  /// Returns a Widget that acts as an Indicator for when search is in progress.
  ///
  /// See [SearchingIndicatorComponent].
  final SearchingIndicatorComponent searchingIndicatorComponent;

  /// Returns a container Widget that supports animation.
  ///
  /// See [AnimationComponent].
  final AnimationComponent animationComponent;

  /// Returns a Widget which acts as a scrollable list.
  ///
  /// See [ListViewComponent].
  final ListViewComponent listViewComponent;

  /// Returns a Widget that wraps [SearchingIndicatorComponent] and
  /// [SearchFieldComponent].
  ///
  /// See [SearchBarComponent].
  final SearchBarComponent searchBarComponent;

  /// Defines flex values for some components.
  ///
  /// See [MenuFlexValues].
  final MenuFlexValues menuFlexValues;

  /// Defines the size and behaviour of menu in various conditions.
  ///
  /// Used by [SelectionMenu] to size its [ListViewMenu].
  ///
  /// See [MenuSizeConfiguration].
  final MenuSizeConfiguration menuSizeConfiguration;

  final MenuAnimationDurations menuAnimationDurations;

  final MenuAnimationCurves menuAnimationCurves;

  List<ComponentLifeCycleMixin> _selectMenuComponents;
  List<ComponentLifeCycleMixin> _listViewMenuComponents;

  ComponentsConfiguration({
    @required this.searchFieldComponent,
    @required this.menuComponent,
    @required this.triggerComponent,
    this.triggerFromItemComponent,
    @required this.menuPositionAndSizeComponent,
    @required this.searchingIndicatorComponent,
    @required this.animationComponent,
    @required this.listViewComponent,
    @required this.searchBarComponent,
    @required this.menuFlexValues,
    @required this.menuSizeConfiguration,
    @required this.menuAnimationDurations,
    @required this.menuAnimationCurves,
  }) : assert(
            searchFieldComponent != null &&
                menuComponent != null &&
                triggerComponent != null &&
                menuPositionAndSizeComponent != null &&
                searchingIndicatorComponent != null &&
                animationComponent != null &&
                listViewComponent != null &&
                searchBarComponent != null &&
                menuFlexValues != null &&
                menuSizeConfiguration != null &&
                menuAnimationDurations != null &&
                menuAnimationCurves != null,
            "All components and configurations are required. (except one 'triggerFromItemComponent').\n"
            "If you wish to customize only a few components,\n"
            "pick a ComponentsConfiguration class like DefaultComponentsConfiguration\n"
            "and provide those sepecific builders in the constructor.\n"
            "Furthermore, if you wish to pick several components\n"
            "from different Builder Classes, you may use the copyWith method.\n") {
    _initLists();
  }

  /// Returns a [ComponentsConfiguration] constructed from the values of this,
  /// overwritten by the non-null arguments passed to the method.
  ComponentsConfiguration<T> copyWith({
    SearchFieldComponent searchFieldComponent,
    TriggerComponent triggerComponent,
    MenuComponent menuComponent,
    MenuPositionAndSizeComponent menuPositionAndSizeComponent,
    TriggerFromItemComponent<T> triggerFromItemComponent,
    SearchingIndicatorComponent searchingIndicatorComponent,
    AnimationComponent animationComponent,
    ListViewComponent listViewComponent,
    SearchBarComponent searchBarComponent,
    MenuFlexValues menuFlexValues,
    MenuSizeConfiguration menuSizeConfiguration,
    MenuAnimationDurations menuAnimationDurations,
    MenuAnimationCurves menuAnimationCurves,
  }) {
    return ComponentsConfiguration<T>(
      triggerComponent: triggerComponent ?? this.triggerComponent,
      triggerFromItemComponent:
          triggerFromItemComponent ?? this.triggerFromItemComponent,
      menuComponent: menuComponent ?? this.menuComponent,
      menuPositionAndSizeComponent:
          menuPositionAndSizeComponent ?? this.menuPositionAndSizeComponent,
      searchFieldComponent: searchFieldComponent ?? this.searchFieldComponent,
      searchingIndicatorComponent:
          searchingIndicatorComponent ?? this.searchingIndicatorComponent,
      animationComponent: animationComponent ?? this.animationComponent,
      listViewComponent: listViewComponent ?? this.listViewComponent,
      searchBarComponent: searchBarComponent ?? this.searchBarComponent,
      menuFlexValues: menuFlexValues ?? this.menuFlexValues,
      menuSizeConfiguration:
          menuSizeConfiguration ?? this.menuSizeConfiguration,
      menuAnimationDurations:
          menuAnimationDurations ?? this.menuAnimationDurations,
      menuAnimationCurves: menuAnimationCurves ?? this.menuAnimationCurves,
    );
  }

  /// Initialize Components used by [SelectionMenu].
  void initSelectionMenuComponents() {
    _selectMenuComponents.forEach((x) {
      x.init();
    });
  }

  /// Initialize Components used by [ListViewMenu].
  void initListViewMenuComponents() {
    _listViewMenuComponents.forEach((x) {
      x.init();
    });
  }

  /// Dispose Components used by [SelectionMenu].
  void disposeSelectionMenuComponents() {
    _selectMenuComponents.forEach((x) {
      x.dispose();
    });
  }

  /// Dispose Components used by [ListViewMenu].
  void disposeListViewMenuComponents() {
    _listViewMenuComponents.forEach((x) {
      x.dispose();
    });
  }

  void _initLists() {
    _selectMenuComponents = [];
    _listViewMenuComponents = [];

    if (searchFieldComponent is ComponentLifeCycleMixin) {
      _listViewMenuComponents
          .add(searchFieldComponent as ComponentLifeCycleMixin);
    }
    if (menuComponent is ComponentLifeCycleMixin) {
      _listViewMenuComponents.add(menuComponent as ComponentLifeCycleMixin);
    }
    if (searchingIndicatorComponent is ComponentLifeCycleMixin) {
      _listViewMenuComponents
          .add(searchingIndicatorComponent as ComponentLifeCycleMixin);
    }
    if (listViewComponent is ComponentLifeCycleMixin) {
      _listViewMenuComponents.add(listViewComponent as ComponentLifeCycleMixin);
    }
    if (searchBarComponent is ComponentLifeCycleMixin) {
      _listViewMenuComponents
          .add(searchBarComponent as ComponentLifeCycleMixin);
    }

    if (triggerComponent is ComponentLifeCycleMixin) {
      _selectMenuComponents.add(triggerComponent as ComponentLifeCycleMixin);
    }
    if (triggerFromItemComponent != null &&
        triggerFromItemComponent is ComponentLifeCycleMixin) {
      _selectMenuComponents
          .add(triggerFromItemComponent as ComponentLifeCycleMixin);
    }
    if (animationComponent is ComponentLifeCycleMixin) {
      _selectMenuComponents.add(animationComponent as ComponentLifeCycleMixin);
    }
  }
}
