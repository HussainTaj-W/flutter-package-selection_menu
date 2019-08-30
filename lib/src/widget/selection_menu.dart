import 'package:flutter/material.dart';
import 'package:selection_menu/components.dart';
import 'package:selection_menu/selection_menu.dart';

import 'listview_menu.dart';

/// Creates a Menu with selection options that opens/closes when you press a
/// button/Widget.
/// The type parameter T describes the type of data each Item of the menu list is.
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
/// **Using [ComponentsConfiguration]**
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
class SelectionMenu<T> extends StatefulWidget {
  /// Returns a [Widget] that corresponds to an item from the [itemsList].
  ///
  /// See [ItemBuilder] for more details
  final ItemBuilder<T> itemBuilder;
  final List<T> itemsList;

  /// Method that matches a search string with an item from the list [itemsList].
  /// Returns true for a successful match and false otherwise.
  ///
  /// null is a valid value, it means search is disabled. In this case search bar
  /// is not shown.
  ///
  /// See [ItemSearchMatcher] for more details.
  final ItemSearchMatcher<T> itemSearchMatcher;

  /// A callback for when an item from the list is selected.
  final OnItemSelected<T> onItemSelected;

  /// The item from [itemsList] that should be selected when the Widget is first created.
  /// null is a valid value, it is interpreted as no default selection.
  final int initiallySelectedItemIndex;

  /// If true, this Widget shows selected Item as the button.
  ///
  /// If [initiallySelectedItemIndex] is null, then a default button is shown, which
  /// is build by [componentsConfiguration.triggerComponent].
  ///
  /// else If [componentsConfiguration.triggerFromItemComponent] is not null, then
  /// it is used to show the current selected Item.
  ///
  /// else [itemBuilder] is used.
  final bool showSelectedItemAsTrigger;

  /// If this Widget should close menu when user taps on space outside the
  /// visible container of the menu.
  final bool closeMenuWhenTappedOutside;

  /// If this Widget should close menu if it is open, instead of popping when the
  /// back button is pressed.
  ///
  /// If true and menu is open, only the menu is closed.
  /// If false, the menu is closed and the current context is also popped.
  final bool closeMenuInsteadOfPop;

  /// If the menu should be closed when the user taps on an empty area inside the
  /// visible menu container.
  final bool closeMenuOnEmptyMenuSpaceTap;

  /// Describes the appearance of the menu.
  ///
  /// See [ComponentsConfiguration] for details.
  ///
  /// If this field is provided then [menuSizeConfiguration] must be null.
  /// Assign required size configuration to [componentsConfiguration.menuSizeConfiguration]
  /// instead.
  final ComponentsConfiguration<T> componentsConfiguration;

  /// The delay before performing the search.
  /// This delay allows to avoid performing search for every rapidly changing
  /// search string.
  final Duration searchLatency;

  /// See [MenuAnimationDurations] for more details.
  final MenuAnimationDurations menuAnimationDurations;

  /// Size of the menu and its behaviors in various conditions.
  ///
  /// See [MenuSizeConfiguration] for more details.
  ///
  /// If [componentsConfiguration] is provided then this field must be null.
  /// Assign the value to [componentsConfiguration.menuSizeConfiguration] instead.
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
    this.componentsConfiguration,
    this.searchLatency = const Duration(milliseconds: 500),
    this.menuAnimationDurations = const MenuAnimationDurations(
        forward: Duration(milliseconds: 500),
        reverse: Duration(milliseconds: 500)),
    this.menuSizeConfiguration,
  })  : assert(
            itemBuilder != null && itemsList != null && onItemSelected != null,
            "itemBuilder, itemsList, and OnItemSelected callback shounld not be null."),
        assert(
            initiallySelectedItemIndex == null ||
                initiallySelectedItemIndex >= 0 &&
                    initiallySelectedItemIndex < itemsList.length,
            "initiallySelectedItemIndex must be >= 0 and <= itemsList.length. null is a valid value."),
        assert(menuSizeConfiguration == null || componentsConfiguration == null,
            """menuSizeConfiguration already present in componentsConfiguration. 
  MenuSizeConfiguration can be assigned to the constructor of a ComponentsConfiguration.
  If a ComponentsConfiguration is assigned to this Widget, 
  then assign the MenuSizeConfiguration to this.componentsConfiguration.menuSizeConfiguration 
  instead of directly to this widget."""),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionMenuState<T>();
}

class _SelectionMenuState<T> extends State<SelectionMenu<T>>
    with TickerProviderStateMixin {
  T _currentSelectedItem;
  OverlayEntry _dropDownListOverlay;

  ListViewMenu<T> _listViewMenu;

  TriggerPositionAndSize _triggerPositionAndSize;

  Orientation _orientation;

  LayerLink _buttonAndMenuLayerLink = LayerLink();

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
    if (widget.initiallySelectedItemIndex != null) {
      _currentSelectedItem =
          widget.itemsList[widget.initiallySelectedItemIndex];
    }

    // Initialize Animation State for the Menu
    _menuAnimationState = MenuAnimationState.Closed;

    _triggerPositionAndSize =
        new TriggerPositionAndSize(size: Size(0, 0), position: Offset(0, 0));

    _componentsConfiguration.initSelectionMenuComponents();
  }

  @override
  Widget build(BuildContext context) {
    if (_dropDownListOverlay == null) {
      _dropDownListOverlay = _buildOverlayEntry();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _menuConstraints = _calculateConstraintsFromSizeConfiguration(context);
        _calculateTriggerPositionAndSize();
        _dropDownListOverlay.markNeedsBuild();
      });
      _orientation = MediaQuery.of(context).orientation;
    }

    return CompositedTransformTarget(
      link: _buttonAndMenuLayerLink,
      child: Material(
        child: WillPopScope(
          onWillPop: _handleOnWillPop,
          child: _buildButton(),
        ),
      ),
    );
  }

  void _scheduleDimensionCalculationAndOverlayRebuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTriggerPositionAndSize();

      if (_dropDownListOverlay != null) _dropDownListOverlay.markNeedsBuild();
    });
  }

  void _calculateTriggerPositionAndSize() {
    RenderBox box = context.findRenderObject();
    _triggerPositionAndSize.position = box.localToGlobal(Offset.zero);
    _triggerPositionAndSize.size = box.size;
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(builder: (BuildContext context) {
      _handleOrientationChange(context);

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
      ));

      Widget front = CompositedTransformFollower(
        link: _buttonAndMenuLayerLink,
        child: _componentsConfiguration.animationComponent
            .build(AnimationComponentData(
          context: context,
          constraints: menuPositionAndSize.constraints,
          child: _listViewMenu,
          menuAnimationState: _menuAnimationState,
          menuAnimationDurations: widget.menuAnimationDurations,
          tickerProvider: this,
        )),
        offset: menuPositionAndSize.positionOffset,
      );

      children.add(front);

      _handleAnimationState();

      return Stack(
        children: children,
      );
    });
  }

  /// Returns null when there is no change in orientation.
  /// Returns an empty Container when there is an orientation change and calculation
  /// of constraints and size is scheduled.
  void _handleOrientationChange(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation != _orientation) {
      _orientation = orientation;
      _calculateTriggerPositionAndSize();
      _menuConstraints = _calculateConstraintsFromSizeConfiguration(context);
    }
  }

  /// OverlayEntry - the menu - is build every time there is [_menuAnimationState] change.
  /// This function handles the transition of states from
  /// [MenuAnimationState.OpeningStart] to [MenuAnimationState.Opened] and
  /// from [MenuAnimationState.ClosingStart] to [MenuAnimationState.Closed].
  ///
  /// Uses [widget.menuAnimationDurations] to schedule when the state should change.
  ///
  /// [MenuAnimationState.OpeningStart] is initiated by [_showOverlayMenu()]
  /// [MenuAnimationState.ClosingStart] is initiated by [_closeOverlayMenu()]
  ///
  /// See Also: [MenuAnimationState]
  void _handleAnimationState() {
    switch (_menuAnimationState) {
      case MenuAnimationState.OpeningStart:
        _menuAnimationState = MenuAnimationState.OpeningEnd;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _dropDownListOverlay.markNeedsBuild();
        });
        break;
      case MenuAnimationState.OpeningEnd:
        _menuAnimationState = MenuAnimationState.Opened;
//        Future.delayed(widget.menuAnimationDurations.forward, () {}).then((_) {
//          WidgetsBinding.instance.addPostFrameCallback((_) {
//            _dropDownListOverlay.markNeedsBuild();
//          });
//        });
        break;
      case MenuAnimationState.ClosingStart:
        _menuAnimationState = MenuAnimationState.ClosingEnd;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _dropDownListOverlay.markNeedsBuild();
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

  BoxConstraints _calculateConstraintsFromSizeConfiguration(
      BuildContext context) {
    MediaQueryData mqData = MediaQuery.of(context);

    MenuSizeConfiguration config =
        _componentsConfiguration.menuSizeConfiguration;
    double minWidth = (config.enforceMinWidthToMatchButton
        ? _triggerPositionAndSize.size.width
        : config.minWidth ?? config.minWidthFraction * mqData.size.width);
    double maxWidth = (config.enforceMaxWidthToMatchButton
        ? _triggerPositionAndSize.size.width
        : config.maxWidth ?? mqData.size.width * config.maxWidthFraction);

    double maxHeight =
        config.maxHeight ?? mqData.size.height * config.maxHeightFraction;
    double minHeight =
        config.minHeight ?? config.minHeightFraction * mqData.size.height;

    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    ).normalize();
  }

  Future<bool> _handleOnWillPop() async {
    if (_menuAnimationState == MenuAnimationState.Opened ||
        _menuAnimationState == MenuAnimationState.OpeningEnd ||
        _menuAnimationState == MenuAnimationState.OpeningStart) {
      _closeOverlayMenu();
      return !widget.closeMenuInsteadOfPop;
    }
    return true;
  }

  void _showOverlayMenu() {
    if (_menuAnimationState == MenuAnimationState.Closed) {
      _calculateTriggerPositionAndSize();

      Overlay.of(context).insert(_dropDownListOverlay);

      _dropDownListOverlay.markNeedsBuild();

      setState(() {
        _menuAnimationState = MenuAnimationState.OpeningStart;
      });
    }
  }

  void _closeOverlayMenu() {
    if (_menuAnimationState == MenuAnimationState.Opened ||
        _menuAnimationState == MenuAnimationState.OpeningStart ||
        _menuAnimationState == MenuAnimationState.OpeningEnd) {
      _menuAnimationState = MenuAnimationState.ClosingStart;
      _dropDownListOverlay.markNeedsBuild();
    } else if (_menuAnimationState == MenuAnimationState.ClosingEnd) {
      _dropDownListOverlay.remove();
      _menuAnimationState = MenuAnimationState.Closed;
    }
  }

  void _onButtonTap() {
    if (_menuAnimationState == MenuAnimationState.Opened ||
        _menuAnimationState == MenuAnimationState.OpeningStart ||
        _menuAnimationState == MenuAnimationState.OpeningEnd)
      _closeOverlayMenu();
    else
      _showOverlayMenu();
  }

  Widget _buildButton() {
    if (widget.showSelectedItemAsTrigger && _currentSelectedItem != null) {
      if (_componentsConfiguration.triggerFromItemComponent != null) {
        return _componentsConfiguration.triggerFromItemComponent.build(
            TriggerFromItemComponentData(
                context: context,
                toggleMenu: _onButtonTap,
                item: _currentSelectedItem));
      }
      return GestureDetector(
        onTap: _onButtonTap,
        child: widget.itemBuilder(context, _currentSelectedItem),
      );
    }

    return _componentsConfiguration.triggerComponent.build(TriggerComponentData(
      context: context,
      toggleMenu: _onButtonTap,
    ));
  }

  void _onMenuItemSelected(T item) {
    setState(() {
      _currentSelectedItem = item;
    });
    _closeOverlayMenu();
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
