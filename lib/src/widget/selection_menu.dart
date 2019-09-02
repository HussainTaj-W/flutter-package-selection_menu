import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/src/widget_configurers/menu_configuration_classes.dart';

import 'listview_menu.dart';

/// A Widget that creates a menu, that opens/closes by the press of a Trigger(Widget).
///
/// A typical Trigger is a button, however this is not a limitation.
///
/// A typical menu has a ListView with items to select from.
///
/// The type parameter T describes the type of data each Item of the menu list is.
///
/// Internally makes use of [ListViewMenu].
///
/// There are various options to customize the appearance and behaviour of this
/// Widget.
///
/// The appearance can be almost completely customized by passing a
/// [ComponentsConfiguration] as [SelectionMenu.componentsConfiguration].
///
/// There are two predefined [ComponentsConfiguration] :
/// * [DialogComponentsConfiguration] a popup dialog style appearance.
/// * [DropdownComponentsConfiguration] a classic dropdown style appearance.
///
/// ## Basic Usage
///
/// ```dart
/// SelectionMenu<String>(
///   itemsList: ['A','B','C'],
///   onItemSelected: (String selectedItem)
///   {
///     print(selectedItem);
///   },
///   itemBuilder: (BuildContext context, String item)
///   {
///     return Text(item);
///   },
/// );
/// ```
///
/// ** How to use [ComponentsConfiguration]**
///
/// ```dart
/// SelectionMenu<String>(
///   itemsList: ['A','B','C'],
///   onItemSelected: (String selectedItem)
///   {
///     print(selectedItem);
///   },
///   itemBuilder: (BuildContext context, String item)
///   {
///     return Text(item);
///   },
///   componentsConfiguration: DropdownComponentsConfiguration<String>(),
/// );
/// ```
///
/// A series of examples/guides can be found here. // TODO: added link
///
/// See Also:
/// * [ListViewMenu].
/// * [ComponentsConfiguration].
class SelectionMenu<T> extends StatefulWidget {
  /// Returns a Widget that corresponds to an item from the [itemsList].
  ///
  /// **Example**
  /// *Assuming type parameter T is [String]*
  ///
  /// ```dart
  /// Widget itemBuilder(BuildContext context, String item)
  /// {
  ///   return Text(item);
  /// }
  /// ```
  ///
  /// Must not be null.
  ///
  /// See [ItemBuilder].
  final ItemBuilder<T> itemBuilder;

  ///
  final List<T> itemsList;

  /// Method that matches a search string with an item from the list [itemsList].
  /// Returns true for a successful match and false otherwise.
  ///
  /// null is a valid value, it means search is disabled.
  ///
  /// **Example**
  /// *Assume type parameter T is [String]*
  ///
  /// ```dart
  /// bool itemSearchMatcher(String searchString, String item)
  /// {
  ///   return item.contains(searchString);
  /// }
  /// ```
  ///
  /// See [ItemSearchMatcher].
  final ItemSearchMatcher<T> itemSearchMatcher;

  /// A callback for when an item from the list is selected.
  ///
  /// Must not be null.
  ///
  /// See [OnItemSelected].
  final OnItemSelected<T> onItemSelected;

  /// The item from [itemsList] that should be selected when the Widget is first created.
  /// null is a valid value, it is interpreted as no default selection.
  ///
  /// In such a case when [showSelectedItemAsTrigger] is true, and this option
  /// is null, [componentsConfiguration.triggerComponent] is used.
  ///
  /// If [showSelectedItemAsTrigger] is true and this value is not null,
  /// the Widget first tries to use [componentsConfiguration.triggerFromItemComponent],
  /// if [TriggerFromItemComponent] is not provided, the [itemBuilder] is used to
  /// created the trigger.
  ///
  /// See also:
  /// * [TriggerFromItemComponent].
  /// * [ComponentsConfiguration].
  final int initiallySelectedItemIndex;

  /// If true, this Widget shows selected Item as the trigger.
  ///
  /// If [initiallySelectedItemIndex] is null, then a default trigger is shown, which
  /// is build by [componentsConfiguration.triggerComponent].
  ///
  /// If this value is not null and [componentsConfiguration.triggerFromItemComponent]
  /// is not null, then it is used to show the current selected Item.
  ///
  /// Otherwise, [itemBuilder] is used.
  ///
  /// Defaults to false.
  final bool showSelectedItemAsTrigger;

  /// Defines if this Widget should close menu when user taps on space outside the
  /// visible container of the menu.
  ///
  /// Defaults to true.
  final bool closeMenuWhenTappedOutside;

  /// If this Widget should close menu if it is open, instead of popping when the
  /// back button is pressed.
  ///
  /// If true and menu is open, only the menu is closed.
  /// If false, the menu is closed and the current context is also popped.
  ///
  /// Defaults to true.
  final bool closeMenuInsteadOfPop;

  /// Defines if the menu should be closed when the user taps on an empty area inside the
  /// visible menu container.
  ///
  /// Defaults to false.
  final bool closeMenuOnEmptyMenuSpaceTap;

  /// Defines if menu should be closed after an item from it is selected.
  ///
  /// Defaults to true;
  final bool closeMenuOnItemSelected;

  /// Describes the appearance of [SelectionMenu].
  ///
  /// If this field is provided then [menuSizeConfiguration] must be null.
  /// Assign required size configuration to [componentsConfiguration.menuSizeConfiguration]
  /// instead.
  ///
  /// Defaults to [DialogComponentsConfiguration].
  ///
  /// See also:
  /// * [ComponentsConfiguration].
  /// * [DialogComponentsConfiguration].
  final ComponentsConfiguration<T> componentsConfiguration;

  /// This is the delay before the SelectionMenu actually starts searching.
  /// Since search is called for every character change in the search field,
  /// it acts as a buffering time and does not perform search for every
  /// character update during this time.
  ///
  /// Defaults to const Duration(milliseconds: 500).
  ///
  /// See also:
  /// * [SearchFieldComponent].
  final Duration searchLatency;

  /// Durations of opening and closing animations of the menu.
  ///
  /// Defaults to:
  /// ```dart
  /// const MenuAnimationDurations(
  ///        forward: Duration(milliseconds: 500),
  ///        reverse: Duration(milliseconds: 500),
  ///      );
  /// ```
  /// See [MenuAnimationDurations].
  final MenuAnimationDurations menuAnimationDurations;

  /// Size of the menu and its behaviors in various conditions.
  ///
  /// If [componentsConfiguration] is provided then this field must be null.
  /// Assign the value to [componentsConfiguration.menuSizeConfiguration] instead.
  ///
  /// See [MenuSizeConfiguration].
  final MenuSizeConfiguration menuSizeConfiguration;

  SelectionMenu({
    Key key,
    @required this.itemBuilder,
    @required this.itemsList,
    @required this.onItemSelected,
    this.initiallySelectedItemIndex,
    this.itemSearchMatcher,
    this.showSelectedItemAsTrigger = false,
    this.closeMenuWhenTappedOutside = true,
    this.closeMenuInsteadOfPop = true,
    this.closeMenuOnEmptyMenuSpaceTap = false,
    this.closeMenuOnItemSelected = true,
    this.componentsConfiguration,
    this.searchLatency = const Duration(milliseconds: 500),
    this.menuAnimationDurations = const MenuAnimationDurations(
      forward: Duration(milliseconds: 500),
      reverse: Duration(milliseconds: 500),
    ),
    this.menuSizeConfiguration,
  })  : assert(
            itemBuilder != null && itemsList != null && onItemSelected != null,
            "itemBuilder, itemsList, and OnItemSelected callback shounld not be null."),
        assert(
            initiallySelectedItemIndex == null ||
                initiallySelectedItemIndex >= 0 &&
                    initiallySelectedItemIndex < itemsList.length,
            '''initiallySelectedItemIndex must be >= 0 and <= itemsList.length.
            null is a valid value, it means search is disabled.'''),
        assert(menuSizeConfiguration == null || componentsConfiguration == null,
            '''menuSizeConfiguration already present in componentsConfiguration. 
  MenuSizeConfiguration can be assigned to the constructor of a ComponentsConfiguration.
  If a ComponentsConfiguration is assigned to this Widget (SelectionMenu), 
  then assign the MenuSizeConfiguration to SelectionMenu.componentsConfiguration.menuSizeConfiguration 
  instead of SelectionMenu.menuSizeConfiguration.'''),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionMenuState<T>();
}

class _SelectionMenuState<T> extends State<SelectionMenu<T>>
    with TickerProviderStateMixin {
  T _currentSelectedItem;

  /// The menu that is displayed as an overlay.
  OverlayEntry _menuOverlay;

  ListViewMenu<T> _listViewMenu;

  TriggerPositionAndSize _triggerPositionAndSize;

  Orientation _orientation;

  /// To allow menu to follow the trigger.
  LayerLink _triggerAndMenuLayerLink = LayerLink();

  /// See [ComponentsConfiguration].
  ComponentsConfiguration<T> _componentsConfiguration;

  BoxConstraints _menuConstraints;

  MenuAnimationState _menuAnimationState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _listViewMenu = ListViewMenu<T>(
      itemSearchMatcher: widget.itemSearchMatcher,
      itemBuilder: widget.itemBuilder,
      onItemSelected: _onMenuItemSelected,
      itemsList: widget.itemsList,
      componentsConfiguration: _componentsConfiguration,
      onMenuEmptySpaceTap: _onMenuEmptySpaceTap,
      searchLatency: widget.searchLatency,
    );
  }

  @override
  void initState() {
    super.initState();

    // Initialize Component Builders
    if (widget.menuSizeConfiguration != null) {
      _componentsConfiguration = widget.componentsConfiguration ??
          DialogComponentsConfiguration<T>()
              .copyWith(menuSizeConfiguration: widget.menuSizeConfiguration);
    } else {
      _componentsConfiguration =
          widget.componentsConfiguration ?? DialogComponentsConfiguration<T>();
    }
    _componentsConfiguration.initSelectionMenuComponents();

    // Initialize ListViewMenu
    _listViewMenu = ListViewMenu<T>(
      itemSearchMatcher: widget.itemSearchMatcher,
      itemBuilder: widget.itemBuilder,
      onItemSelected: _onMenuItemSelected,
      itemsList: widget.itemsList,
      componentsConfiguration: _componentsConfiguration,
      onMenuEmptySpaceTap: _onMenuEmptySpaceTap,
      searchLatency: widget.searchLatency,
    );

    // Initialize Current Selected Item
    _currentSelectedItem = null;
    if (widget.initiallySelectedItemIndex != null) {
      _currentSelectedItem =
          widget.itemsList[widget.initiallySelectedItemIndex];
    }

    // Initialize Animation State for the Menu
    _menuAnimationState = MenuAnimationState.Closed;

    _triggerPositionAndSize =
        new TriggerPositionAndSize(size: Size(0, 0), position: Offset(0, 0));
  }

  @override
  Widget build(BuildContext context) {
    if (_menuOverlay == null) {
      _menuOverlay = _buildMenuOverlayEntry();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateTriggerPositionAndSize();
        _menuConstraints = widget.menuSizeConfiguration.getConstraints(
            _triggerPositionAndSize.size, MediaQuery.of(context).size);
//        _menuConstraints = _calculateConstraintsFromSizeConfiguration(context);
        _menuOverlay.markNeedsBuild();
      });
      _orientation = MediaQuery.of(context).orientation;
    }

    return CompositedTransformTarget(
      link: _triggerAndMenuLayerLink,
      child: WillPopScope(
        onWillPop: _handleOnWillPop,
        child: _buildTrigger(),
      ),
    );
  }

  /// Calculate the trigger's position and size on the screen.
  ///
  /// The position an [Offset] from the top-left of the **visible** screen.
  void _calculateTriggerPositionAndSize() {
    RenderBox box = context.findRenderObject();
    _triggerPositionAndSize.position = box.localToGlobal(Offset.zero);
    _triggerPositionAndSize.size = box.size;
  }

  OverlayEntry _buildMenuOverlayEntry() {
    return OverlayEntry(builder: (BuildContext context) {
      if (_didOrientationChange(context)) {
        _handleOrientationChange(context);

        // Return an empty container because the orientation change has occurred.
        // This has caused the trigger to change size and position which needs to
        // be handled.
        return Container(
          height: 0,
          width: 0,
        );
      }

      _calculateTriggerPositionAndSize();

      List<Widget> children = [];

      if (widget.closeMenuWhenTappedOutside) {
        Widget back = GestureDetector(
          onTap: _closeOverlayMenu,
          child: Container(
            color: Colors.transparent,
            //constraints: BoxConstraints.loose(MediaQuery.of(context).size),
          ),
        );
        children.add(back);
      }

      MenuPositionAndSize menuPositionAndSize = _componentsConfiguration
          .menuPositionAndSizeComponent
          .build(MenuPositionAndSizeComponentData(
        context: context,
        constraints: _menuConstraints,
        menuSizeConfiguration: _componentsConfiguration.menuSizeConfiguration,
        triggerPositionAndSize: _triggerPositionAndSize,
        selectedItem: _currentSelectedItem,
      ));

      Widget front = CompositedTransformFollower(
        link: _triggerAndMenuLayerLink,
        child: Container(
          child: _componentsConfiguration.animationComponent
              .build(AnimationComponentData(
            context: context,
            constraints: menuPositionAndSize.constraints,
            child: _listViewMenu,
            menuAnimationState: _menuAnimationState,
            menuAnimationDurations: widget.menuAnimationDurations,
            tickerProvider: this,
            selectedItem: _currentSelectedItem,
          )),
          width: menuPositionAndSize?.size?.width,
          height: menuPositionAndSize?.size?.height,
          constraints: menuPositionAndSize.constraints,
        ),
        offset: menuPositionAndSize.positionOffset,
      );

      children.add(front);

      _handleAnimationState();

      return Stack(
        children: children,
      );
    });
  }

  /// Whenever orientation changes, Widgets are rebuilt.
  /// Since the trigger was probably rebuilt, its size and position might've
  /// changed as well.
  /// We need to make appropriate calculations, which is handled by this method.
  void _handleOrientationChange(BuildContext context) {
    _orientation = MediaQuery.of(context).orientation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTriggerPositionAndSize();
      _menuOverlay.markNeedsBuild();
      _menuConstraints = widget.menuSizeConfiguration.getConstraints(
          _triggerPositionAndSize.size, MediaQuery.of(context).size);
//          _calculateConstraintsFromSizeConfiguration(context);
    });
  }

  /// Returns true if orientation has changed since the last time the Widget was
  /// built.
  bool _didOrientationChange(BuildContext context) {
    return MediaQuery.of(context).orientation != _orientation;
  }

  /// OverlayEntry - the menu - should build if there is appropriate
  /// [_menuAnimationState] change.
  ///
  /// This function handles the transition of states from
  /// [MenuAnimationState.OpeningStart] to [MenuAnimationState.Opened] and
  /// from [MenuAnimationState.ClosingStart] to [MenuAnimationState.Closed].
  ///
  /// Uses [widget.menuAnimationDurations] to schedule when some states should change.
  ///
  /// [MenuAnimationState.OpeningStart] is initiated by [_showOverlayMenu()]
  /// [MenuAnimationState.ClosingStart] is initiated by [_closeOverlayMenu()]
  ///
  /// See also:
  /// * [MenuAnimationState]
  void _handleAnimationState() {
    switch (_menuAnimationState) {
      case MenuAnimationState.OpeningStart:
        _menuAnimationState = MenuAnimationState.OpeningEnd;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _menuOverlay.markNeedsBuild();
        });
        break;
      case MenuAnimationState.OpeningEnd:
        _menuAnimationState = MenuAnimationState.Opened;
        break;
      case MenuAnimationState.ClosingStart:
        _menuAnimationState = MenuAnimationState.ClosingEnd;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _menuOverlay.markNeedsBuild();
        });
        break;
      case MenuAnimationState.ClosingEnd:
        Future.delayed(widget.menuAnimationDurations.reverse, () {}).then((_) {
          _closeOverlayMenu();
        });
        break;
      case MenuAnimationState.Opened:
        break;
      case MenuAnimationState.Closed:
        break;
    }
  }

//  /// Processes [widget.menuSizeConfiguration] and converts them to appropriate
//  /// [BoxConstraints].
//  ///
//  /// These box constraints can be later modified by [MenuPositionAndSizeComponent].
//  /// The BoxConstraints returned by [_componentsConfiguration.menuSizeConfiguration]
//  /// are considered the actual constraints of the Menu.
//  ///
//  /// Ensuring that these constraints are honored are the responsibility of
//  /// [_componentsConfiguration.animationComponent].
//  ///
//  /// See also:
//  /// * [MenuSizeConfiguration].
//  /// * [MenuPositionAndSizeComponent].
//  /// * [AnimationComponent].
//  BoxConstraints _calculateConstraintsFromSizeConfiguration(
//      BuildContext context) {
//    MediaQueryData mqData = MediaQuery.of(context);
//
//    MenuSizeConfiguration config =
//        _componentsConfiguration.menuSizeConfiguration;
//    double minWidth = (config.enforceMinWidthToMatchTrigger
//        ? _triggerPositionAndSize.size.width
//        : config.minWidth ?? config.minWidthFraction * mqData.size.width);
//    double maxWidth = (config.enforceMaxWidthToMatchTrigger
//        ? _triggerPositionAndSize.size.width
//        : config.maxWidth ?? mqData.size.width * config.maxWidthFraction);
//
//    double maxHeight =
//        config.maxHeight ?? mqData.size.height * config.maxHeightFraction;
//    double minHeight =
//        config.minHeight ?? config.minHeightFraction * mqData.size.height;
//
//    return BoxConstraints(
//      minWidth: minWidth,
//      maxWidth: maxWidth,
//      minHeight: minHeight,
//      maxHeight: maxHeight,
//    ).normalize();
//  }

  /// Returns whether the context should pop.
  /// Closes the menu if opened.
  Future<bool> _handleOnWillPop() async {
    if (_menuAnimationState == MenuAnimationState.Opened ||
        _menuAnimationState == MenuAnimationState.OpeningEnd ||
        _menuAnimationState == MenuAnimationState.OpeningStart) {
      _closeOverlayMenu();
      return !widget.closeMenuInsteadOfPop;
    }
    return true;
  }

  /// If [_menuAnimationState] is [MenuAnimationState.Closed] only then:
  /// Inserts the [_menuOverlay].
  /// Sets [_menuAnimationState] to [MenuAnimationState.OpeningStart].
  ///
  /// See also:
  /// * [MenuAnimationState].
  void _showOverlayMenu() {
    if (_menuAnimationState == MenuAnimationState.Closed) {
      Overlay.of(context).insert(_menuOverlay);
      _menuOverlay.markNeedsBuild();

      setState(() {
        _menuAnimationState = MenuAnimationState.OpeningStart;
      });
    }
  }

  /// Sets [_menuAnimationState] to [MenuAnimationState.ClosingStart] if
  /// [_menuAnimationState] is not one of the opening ones.
  /// Sets [_menuAnimationState] to [MenuAnimationState.Closed] if
  /// [_menuAnimationState] is [MenuAnimationState.ClosingEnd] and also removes
  /// [_menuOverlay].
  ///
  /// See also;
  /// * [MenuAnimationState].
  void _closeOverlayMenu() {
    if (_menuAnimationState == MenuAnimationState.Opened ||
        _menuAnimationState == MenuAnimationState.OpeningStart ||
        _menuAnimationState == MenuAnimationState.OpeningEnd) {
      _menuAnimationState = MenuAnimationState.ClosingStart;
      _menuOverlay.markNeedsBuild();
    } else if (_menuAnimationState == MenuAnimationState.ClosingEnd) {
      _menuOverlay.remove();
      _menuAnimationState = MenuAnimationState.Closed;
    }
  }

  /// Toggles the menu.
  void _onTriggered() {
    if (_menuAnimationState == MenuAnimationState.Opened ||
        _menuAnimationState == MenuAnimationState.OpeningStart ||
        _menuAnimationState == MenuAnimationState.OpeningEnd)
      _closeOverlayMenu();
    else
      _showOverlayMenu();
  }

  /// Builds the trigger component.
  ///
  /// If [widget.showSelectedItemAsTrigger] is true and [widget.initiallySelectedItemIndex]
  /// is not null, then first tries to use [_componentsConfiguration.triggerFromItemComponent],
  /// otherwise uses [widget.itemBuilder].
  ///
  /// If [widget.showSelectedItemAsTrigger] is false or [widget.initiallySelectedItemIndex]
  /// is null then uses [_componentsConfiguration.triggerComponent].
  ///
  /// See also:
  /// * [TriggerFromItemComponent].
  /// * [TriggerComponent].
  /// * [ComponentsConfiguration].
  Widget _buildTrigger() {
    if (widget.showSelectedItemAsTrigger && _currentSelectedItem != null) {
      if (_componentsConfiguration.triggerFromItemComponent != null) {
        return _componentsConfiguration.triggerFromItemComponent
            .build(TriggerFromItemComponentData(
          context: context,
          toggleMenu: _onTriggered,
          item: _currentSelectedItem,
          tickerProvider: this,
          selectedItem: _currentSelectedItem,
        ));
      }
      return GestureDetector(
        onTap: _onTriggered,
        child: widget.itemBuilder(context, _currentSelectedItem),
      );
    }

    return _componentsConfiguration.triggerComponent.build(TriggerComponentData(
      context: context,
      toggleMenu: _onTriggered,
      tickerProvider: this,
      selectedItem: _currentSelectedItem,
    ));
  }

  void _onMenuItemSelected(T item) {
    setState(() {
      _currentSelectedItem = item;
    });
    if (widget.closeMenuOnItemSelected) {
      _closeOverlayMenu();
    }
    widget.onItemSelected(_currentSelectedItem);
  }

  void _onMenuEmptySpaceTap() {
    if (widget.closeMenuOnEmptyMenuSpaceTap) _closeOverlayMenu();
  }

  @override
  void dispose() {
    _componentsConfiguration.disposeSelectionMenuComponents();
    super.dispose();
  }
}
