import 'package:selection_menu/selection_menu.dart';

import 'notifiers.dart';

/// A Controller class for [SelectionMenu].
class SelectionMenuController {
  /// It's a [ChangeNotifier] that triggers the [SelectionMenu].
  ///
  /// Using this, you can programmatically trigger the menu.
  final TriggerNotifier triggerNotifier = TriggerNotifier();

  /// It's a [ChangeNotifier] for [SelectionMenu.itemsList].
  ///
  /// Updated value is not passed to the Change Notifier. It is just a notification.
  /// [SelectionMenu.itemsList] is a reference to the data. This notifier just tells
  /// that there has been a change in the [SelectionMenu.itemsList].
  final ItemsListUpdateNotifier itemsListUpdateNotifier =
      ItemsListUpdateNotifier();

  /// A wrapper over [triggerNotifier.trigger].
  void trigger() {
    triggerNotifier.trigger();
  }

  /// A wrapper over [itemsListUpdateNotifier.notifyListUpdated].
  void notifyListUpdated() {
    itemsListUpdateNotifier.notifyListUpdated();
  }
}
