import 'package:flutter/material.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/src/widget_configurer/dialog_view_component_builders.dart';
import 'package:selection_menu/src/widget_configurer/view_component_builders.dart';

/// Returns a [Widget] that corresponds to the data [item] of type T.
typedef Widget ItemBuilder<T>(BuildContext context, T item);

/// Returns true if [item] of type T can be described using [searchString],
/// hence, should be included in search results.
/// Returns false otherwise.
typedef bool ItemSearchMatcher<T>(String searchString, T item);

/// A callback for when an item has been selected from the list in menu.
typedef void OnItemSelected<T>(T item);

/// A callback for when Empty space in the menu is pressed.
typedef void OnMenuEmptySpaceTap();

/// Creates a Menu Widget, that has a list and optionally a search bar.
/// Type parameter T describes the type of Items in the List [ListViewMenu.itemsList].
///
/// It uses [ViewComponentBuilders] to build various components.
class ListViewMenu<T> extends StatefulWidget {
  /// Method/Callback that converts data of type T into a [Widget].
  final ItemBuilder<T> itemBuilder;

  /// [List]<T> of [itemsList] to show in the menu.
  final List<T> itemsList;

  /// Method that matches a search string with an item from the list [itemsList].
  ///
  /// See [ItemSearchMatcher] for more details.
  final ItemSearchMatcher<T> itemSearchMatcher;

  /// A callback for when an item from the list is selected.
  final OnItemSelected<T> onItemSelected;

  /// The [ViewComponentBuilders] that will be used to create various components
  /// of this Widget.
  final ViewComponentBuilders<T> viewComponentBuilders;

  /// A callback for when empty space in the menu is tapped.
  final OnMenuEmptySpaceTap onMenuEmptySpaceTap;

  /// The delay before performing the search.
  /// This delay allows to avoid performing search for every rapidly changing
  /// search string.
  final Duration searchLatency;

  const ListViewMenu({
    Key key,
    @required this.itemBuilder,
    @required this.itemsList,
    @required this.onItemSelected,
    this.itemSearchMatcher,
    this.onMenuEmptySpaceTap,
    this.viewComponentBuilders,
    this.searchLatency = const Duration(milliseconds: 500),
  })  : assert(itemBuilder != null &&
            itemsList != null &&
            onItemSelected != null &&
            searchLatency != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ListViewMenuState<T>();
}

class _ListViewMenuState<T> extends State<ListViewMenu<T>> {
  /// List of items currently shown in the menu.
  ///
  /// This list stores filtered [widget.itemsList] from search result.
  List<T> _currentItemsList;

  bool _isSearching;
  String _searchString;

  TextEditingController _searchTextController = TextEditingController();

  ViewComponentBuilders _viewComponentBuilders;

  @override
  void initState() {
    super.initState();

    _searchString = "";
    _isSearching = false;
    _viewComponentBuilders =
        widget.viewComponentBuilders ?? DialogViewComponentBuilders<T>();

    _currentItemsList = widget.itemsList;

    _searchTextController.addListener(_onSearchStringChange);
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar, searchingIndicator;
    if (widget.itemSearchMatcher != null) {
      searchBar = _viewComponentBuilders.searchFieldBuilder(
          context, _searchTextController);
      searchingIndicator =
          _viewComponentBuilders.searchingIndicatorBuilder(context);
    }
    return _buildListViewMenu(searchBar, searchingIndicator);
  }

  Widget _buildListViewMenu(Widget searchBar, Widget searchingIndicator) {
    List<Widget> columnChildren = [];

    if (widget.itemSearchMatcher != null) {
      columnChildren.add(Expanded(
        flex: _viewComponentBuilders.menuFlexValues.searchBarContainer,
        child: _viewComponentBuilders.searchBarContainerBuilder(
            context,
            searchBar,
            searchingIndicator,
            _isSearching,
            _viewComponentBuilders.menuFlexValues),
      ));
    }
    Widget listView = _buildCurrentListListView();

    columnChildren.add(
      Expanded(
        flex: _viewComponentBuilders.menuFlexValues.listView,
        child: GestureDetector(
          onTap: widget.onMenuEmptySpaceTap,
          child: listView,
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      child: _viewComponentBuilders.menuContainerBuilder(
        context,
        ClipRect(
          child: Column(
            children: columnChildren,
          ),
        ),
      ),
    );
  }

  /// Builds a [Widget] that contains a [ListView] from the [_currentItemsList].
  Widget _buildCurrentListListView() {
    return _viewComponentBuilders.listViewBuilder(context,
        (BuildContext context, int index) {
      return GestureDetector(
        onTap: () => _onListItemTap(index),
        child: widget.itemBuilder(context, _currentItemsList[index]),
      );
    }, _currentItemsList.length);
  }

  /// Returns a [Future]<[List]<T>> after searching the list [widget.itemsList]
  /// for [_searchString] asynchronously using [widget.itemSearchMatcher].
  Future<List<T>> _searchList(String searchString) async {
    return _searchString.trim().isNotEmpty
        ? widget.itemsList
            .where((item) => widget.itemSearchMatcher(searchString, item))
            .toList()
        : widget.itemsList;
  }

  /// Callback that is called everything the search field with [_searchTextController]
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
      if (searchString != _searchString) {
        _performSearch(_searchString);
      }
      setState(() {
        _currentItemsList = result;
        _isSearching = false;
      });
    });
  }

  void _onListItemTap(int itemIndex) {
    widget.onItemSelected(_currentItemsList[itemIndex]);
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
}
