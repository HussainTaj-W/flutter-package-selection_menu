import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

/// A callback [ListViewMenu] uses to get initially Selected item from
/// [SelectionMenu].
typedef T GetSelectedItem<T>();

/// A callback for when an item in the list/menu is tapped.
typedef void OnItemTapped();

/// Returns a Widget that corresponds to the data [item] of type T.
///
/// The Widget must call [onItemTapped] otherwise it will not be selected.
typedef Widget ItemBuilder<T>(
    BuildContext context, T item, OnItemTapped onItemTapped);

/// Returns true if [item] of type T can be described using [searchString],
/// false otherwise.
typedef bool ItemSearchMatcher<T>(String searchString, T item);

/// A callback for when an item has been selected from the list in menu.
typedef void OnItemSelected<T>(T item);

/// A callback for when Empty space in the menu is tapped.
typedef void OnMenuEmptySpaceTap();

/// A Menu [Widget], that has a list of items and optionally a search bar.
///
/// Type parameter T describes the type of Items in the List
/// [ListViewMenu.itemsList].
///
/// It uses [ComponentsConfiguration] from the *components_configurations*
/// library to build various [Widget]s used in the menu.
///
/// This Widget is used by [SelectionMenu].
///
/// See also:
/// * [ComponentsConfiguration].
/// * [SelectionMenu].
class ListViewMenu<T> extends StatefulWidget {
  /// Method/Callback that converts data of type T into a Widget.
  ///
  /// **Example**
  /// *Assuming type parameter T is [String]*
  ///
  /// ```dart
  /// Widget itemBuilder(BuildContext context, String item, OnItemTapped onItemTapped)
  /// {
  ///   return Material(
  ///     InkWell(
  ///       onTap: onItemTapped,
  ///       child: Text(item),
  ///     ),
  ///   );
  /// },
  /// ```
  ///
  /// Must not be null.
  ///
  /// See also:
  /// * [ItemBuilder].
  final ItemBuilder<T> itemBuilder;

  /// The items to show in the menu.
  ///
  /// Must not be null.
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

  /// Describes the appearance of [ListViewMenu].
  ///
  /// Defaults to [DialogComponentsConfiguration].
  ///
  /// See also:
  /// * [ComponentsConfiguration].
  /// * [DialogComponentsConfiguration].
  /// * [DropdownComponentsConfiguration].
  final ComponentsConfiguration<T> componentsConfiguration;

  /// A callback for when empty space in the menu is tapped.
  final OnMenuEmptySpaceTap onMenuEmptySpaceTap;

  /// This is the delay before the SelectionMenu actually starts searching.
  ///
  /// Since search is called for every character change in the search field,
  /// it acts as a buffering time and does not perform search for every
  /// character update during this time.
  ///
  /// Defaults to const Duration(milliseconds: 500).
  ///
  /// See also:
  /// * [SearchFieldComponent].
  final Duration searchLatency;

  /// If not null, uses this callback to set the initial selected value.
  final GetSelectedItem<T> getSelectedItem;

  const ListViewMenu({
    Key key,
    @required this.itemBuilder,
    @required this.itemsList,
    @required this.onItemSelected,
    this.getSelectedItem,
    this.itemSearchMatcher,
    this.onMenuEmptySpaceTap,
    this.componentsConfiguration,
    this.searchLatency = const Duration(milliseconds: 500),
  })  : assert(itemBuilder != null &&
            itemsList != null &&
            onItemSelected != null &&
            searchLatency != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ListViewMenuState<T>();
}

class _ListViewMenuState<T> extends State<ListViewMenu<T>>
    with TickerProviderStateMixin {
  /// List of items currently shown in the menu.
  ///
  /// This list stores filtered [widget.itemsList] from search result.
  List<T> _currentItemsList;

  bool _isSearching;
  String _searchString;

  /// The controller used to detect changes in [SearchFieldComponent].
  ///
  /// See also:
  /// * [SearchFieldComponent].
  /// * [ComponentsConfiguration].
  TextEditingController _searchTextController = TextEditingController();

  ComponentsConfiguration _componentsConfiguration;

  T _currentSelectedItem;

  @override
  void initState() {
    super.initState();

    _searchString = "";
    _isSearching = false;
    _componentsConfiguration =
        widget.componentsConfiguration ?? DialogComponentsConfiguration<T>();

    _currentItemsList = widget.itemsList;

    _searchTextController.addListener(_onSearchStringChange);

    _componentsConfiguration.initListViewMenuComponents();

    if (widget.getSelectedItem != null)
      _currentSelectedItem = widget.getSelectedItem();
    else
      _currentSelectedItem = null;
  }

  @override
  Widget build(BuildContext context) {
    final Widget searchField = _componentsConfiguration.searchFieldComponent
        .build(SearchFieldComponentData(
      context: context,
      searchTextController: _searchTextController,
      tickerProvider: this,
      selectedItem: _currentSelectedItem,
    ));

    final Widget searchingIndicator = _componentsConfiguration
        .searchingIndicatorComponent
        .build(SearchingIndicatorComponentData(
      context: context,
      isSearching: _isSearching,
      tickerProvider: this,
      selectedItem: _currentSelectedItem,
    ));

    final Widget searchBar = _componentsConfiguration.searchBarComponent
        .build(SearchBarComponentData(
      menuFlexValues: _componentsConfiguration.menuFlexValues,
      context: context,
      isSearching: _isSearching,
      searchingIndicator: searchingIndicator,
      searchField: searchField,
      tickerProvider: this,
      selectedItem: _currentSelectedItem,
    ));

    return _buildListViewMenu(searchBar);
  }

  Widget _buildListViewMenu(final Widget searchBar) {
    Widget listView = GestureDetector(
      onTap: widget.onMenuEmptySpaceTap,
      child: _buildCurrentListMenu(),
    );

    return _componentsConfiguration.menuComponent.build(MenuComponentData(
      context: context,
      menuFlexValues: _componentsConfiguration.menuFlexValues,
      listView: listView,
      searchBar: searchBar,
      isSearchEnabled: widget.itemSearchMatcher != null,
      tickerProvider: this,
      selectedItem: _currentSelectedItem,
    ));
  }

  /// Builds a Widget that contains a a scrollable list from the [_currentItemsList].
  Widget _buildCurrentListMenu() {
    return _componentsConfiguration.listViewComponent
        .build(ListViewComponentData(
      context: context,
      itemBuilder: (BuildContext context, int index) {
        return widget.itemBuilder(context, _currentItemsList[index], () {
          _onListItemTap(index);
        });
      },
      itemCount: _currentItemsList.length,
      tickerProvider: this,
      selectedItem: _currentSelectedItem,
    ));
  }

  /// Returns a [Future]<[List]<T>> after searching the list [widget.itemsList]
  /// for [_searchString] asynchronously using [widget.itemSearchMatcher].
  Future<List<T>> _searchList(String searchString) async {
    assert(widget.itemSearchMatcher != null, "No search macther provided.");
    return _searchString.trim().isNotEmpty
        ? widget.itemsList
            .where((item) => widget.itemSearchMatcher(searchString, item))
            .toList()
        : widget.itemsList;
  }

  /// Callback that is called every time the search field with [_searchTextController]
  /// changes.
  void _onSearchStringChange() async {
    _searchString = _searchTextController.text;
    if (!_isSearching) {
      setState(() {
        _isSearching = true;
      });
      Future.delayed(widget.searchLatency, () {
        _performSearch(_searchString);
      });
    }
  }

  void _performSearch(String searchString) {
    _searchList(searchString).then((List<T> result) {
      if (searchString != _searchString && mounted) {
        _performSearch(_searchString);
      }
      if (mounted) {
        setState(() {
          _currentItemsList = result;
          _isSearching = false;
        });
      }
    });
  }

  void _onListItemTap(int itemIndex) {
    setState(() {
      _currentSelectedItem = _currentItemsList[itemIndex];
    });
    widget.onItemSelected(_currentSelectedItem);
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _componentsConfiguration.disposeListViewMenuComponents();
    super.dispose();
  }
}
