import 'package:flutter/widgets.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/src/widget_configurers/components/components.dart';
import 'package:selection_menu/src/widget_configurers/configurations/menu_configuration_classes.dart';

/// A base class that define the appearance of [SelectionMenu] and [ListViewMenu],
/// where type parameter T is the same as the type parameter of [SelectionMenu]
/// or [ListViewMenu].
///
/// A Component is a class with a builder method that returns a Widget,
/// or Position and Size information, or simply a class that contains data related
/// to layout.
///
/// This class can be subclassed. The subclass would assign values to the instance
/// variables.
/// The subclasses can then be passed to [SelectionMenu.componentsConfiguration].
///
/// Two predefined subclasses are:
/// * [DialogComponentsConfiguration] a dialog or popup style appearance.
/// * [DropdownComponentsConfiguration] a dropdown style appearance.
///
/// ## Terms to Know
/// In the context of this library the following visual component are described as:
///
/// * SearchField: Any [Widget] that allows text editing.
/// * SearchingIndicator: Any [Widget] that indicates that search is in progress.
/// * SearchBar: Any [Widget] that combines the SearchField and SearchingIndicator.
/// * ListView: Any [Widget] that incorporates a [ListView], the list of items.
/// * Menu or MenuContainer: Any [Widget] that lays out and/or wraps SearchBar and ListView.
/// * AnimatedContainer: Any [Widget] that provides implicit animation(s) for Menu.
/// * Button: Any [Widget] that, when pressed, opens or closes the Menu.
class ComponentsConfiguration<T> {
  /// Defines a builder that returns a [Widget] where a user can input text.
  ///
  /// See Also:
  /// * [SearchFieldComponent].
  /// * [SearchFieldBuilder].
  final SearchFieldComponent searchFieldComponent;

  /// Returns a [Widget] that wraps menu content (which are search field, searching indicator and
  /// listView).
  ///
  /// See [MenuContainerBuilder] for more details.
  final MenuComponent menuComponent;

  /// Returns a [Widget] that acts as a button to open/close menu.
  ///
  /// See [ButtonBuilder] for more details.
  final TriggerComponent triggerComponent;

  /// Returns a [Widget] that acts as a button to open/close menu, where the button
  /// reflects the currently selected item.
  ///
  /// See [ButtonFromItemBuilder] for more details.
  final TriggerFromItemComponent<T> triggerFromItemComponent;

  /// Returns a [MenuSizeAndPosition] after performing some calculation.
  ///
  /// See [MenuPositionAndSizeCalculator] for more details.
  final MenuPositionAndSizeComponent menuPositionAndSizeComponent;

  /// Returns a [Widget] that acts as an Indicator for when search is in progress.
  ///
  /// See [SearchingIndicatorBuilder] for more details.
  final SearchingIndicatorComponent searchingIndicatorComponent;

  /// Returns a [Widget] that supports implicit animations through itself
  /// or through its descendants.
  ///
  /// See [MenuAnimatedContainerBuilder] for more details.
  final AnimationComponent animationComponent;

  /// Returns a [ListView] using a constructor that takes a [IndexedWidgetBuilder].
  ///
  /// See [ListViewBuilder] for more details.
  final ListViewComponent listViewComponent;

  /// Returns a [Widget] that wraps a search field and and searching indicator.
  ///
  /// See [SearchBarBuilder] for more details.
  final SearchBarComponent searchBarComponent;

  /// Defines flex values for various view component_builders ([Widget]s).
  ///
  /// See [MenuFlexValues] for more details.
  final MenuFlexValues menuFlexValues;

  /// Defines the size and behaviour of size in various conditions.
  ///
  /// See [MenuSizeConfiguration] for more details.
  final MenuSizeConfiguration menuSizeConfiguration;

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
                menuSizeConfiguration != null,
            """
            All components and configurations are required. (except one 'triggerFromItemComponent'). 
            If you wish to customize only a few components, 
            pick a ComponentsConfiguration class like DefaultComponentsConfiguration 
            and provide those sepecific builders in the constructor. 
            Furthermore, if you wish to pick several components 
            from different Builder Classes, you may use the copyWith method.
            """);

  /// Returns a [ComponentsConfiguration] constructed from the values of this, overwritten
  /// by the non-null arguments passed to the method.
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
    );
  }

  void initSelectionMenuComponents() {
    if (triggerComponent is ComponentLifeCycleMixin) {
      (triggerComponent as ComponentLifeCycleMixin).init();
    }
    if (triggerFromItemComponent is ComponentLifeCycleMixin) {
      (triggerFromItemComponent as ComponentLifeCycleMixin).init();
    }
    if (animationComponent is ComponentLifeCycleMixin) {
      (animationComponent as ComponentLifeCycleMixin).init();
    }
  }

  void initListViewMenuComponents() {
    if (searchFieldComponent is ComponentLifeCycleMixin) {
      (searchFieldComponent as ComponentLifeCycleMixin).init();
    }
    if (menuComponent is ComponentLifeCycleMixin) {
      (menuComponent as ComponentLifeCycleMixin).init();
    }
    if (searchingIndicatorComponent is ComponentLifeCycleMixin) {
      (searchingIndicatorComponent as ComponentLifeCycleMixin).init();
    }
    if (listViewComponent is ComponentLifeCycleMixin) {
      (listViewComponent as ComponentLifeCycleMixin).init();
    }
    if (searchBarComponent is ComponentLifeCycleMixin) {
      (searchBarComponent as ComponentLifeCycleMixin).init();
    }
  }

  void disposeSelectionMenuComponents() {
    if (triggerComponent is ComponentLifeCycleMixin) {
      (triggerComponent as ComponentLifeCycleMixin).dispose();
    }
    if (triggerFromItemComponent is ComponentLifeCycleMixin) {
      (triggerFromItemComponent as ComponentLifeCycleMixin).dispose();
    }
    if (animationComponent is ComponentLifeCycleMixin) {
      (animationComponent as ComponentLifeCycleMixin).dispose();
    }
  }

  void disposeListViewMenuComponents() {
    if (searchFieldComponent is ComponentLifeCycleMixin) {
      (searchFieldComponent as ComponentLifeCycleMixin).dispose();
    }
    if (menuComponent is ComponentLifeCycleMixin) {
      (menuComponent as ComponentLifeCycleMixin).dispose();
    }
    if (searchingIndicatorComponent is ComponentLifeCycleMixin) {
      (searchingIndicatorComponent as ComponentLifeCycleMixin).dispose();
    }
    if (listViewComponent is ComponentLifeCycleMixin) {
      (listViewComponent as ComponentLifeCycleMixin).dispose();
    }
    if (searchBarComponent is ComponentLifeCycleMixin) {
      (searchBarComponent as ComponentLifeCycleMixin).dispose();
    }
  }
}
