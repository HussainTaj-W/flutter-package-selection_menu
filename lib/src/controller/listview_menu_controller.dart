import 'package:selection_menu/selection_menu.dart';

import 'notifiers.dart';

/// A Controller class for [ListViewMenu].
class ListViewMenuController {
  /// A [ChangeNotifier] for [SelectionMenu.itemsList].
  ///
  /// Updated value is not passed to the Change Notifier. It is just a notification.
  /// [SelectionMenu.itemsList] is a reference to the data. This notifier just tells
  /// that there has been a change in the [SelectionMenu.itemsList].
  final ItemsListUpdateNotifier itemsListUpdateNotifier =
      ItemsListUpdateNotifier();

  /// Notifies all the listeners of [itemsListUpdateNotifier] that
  /// [SelectionMenu.itemsList] has been updated.
  void notifyListUpdated() {
    itemsListUpdateNotifier.notifyListUpdated();
  }
}
