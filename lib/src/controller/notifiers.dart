import 'package:flutter/foundation.dart';
import 'package:selection_menu/selection_menu.dart';

/// A [ChangeNotifier] for [SelectionMenu.itemsList].
///
/// Updated value is not passed to the Change Notifier. It is just a notification.
/// [SelectionMenu.itemsList] is a reference to the data. This notifier just tells
/// that there has been a change in the [SelectionMenu.itemsList].
class ItemsListUpdateNotifier extends ChangeNotifier {
  /// Notifies all the listeners.
  void notifyListUpdated() {
    notifyListeners();
  }
}

/// A [ChangeNotifier] that triggers the [SelectionMenu].
///
/// Using this, you can programmatically trigger the menu.
class TriggerNotifier extends ChangeNotifier {
  /// Notifies all the listeners, potentially causing them to trigger.
  void trigger() {
    notifyListeners();
  }
}
