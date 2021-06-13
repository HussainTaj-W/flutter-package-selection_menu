import 'dart:math';

import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/src/widget_configurers/components/components.dart';

import '../components_configuration.dart';

/// Defines the appearance of [SelectionMenu] as a typical dropdown menu.
///
/// ![How the style looks](https://i.imgur.com/X0clpJD.gif)
///
/// A series of examples/guides can be found
/// [here](https://github.com/HussainTaj-W/flutter-package-selection_menu-example).
///
/// See [ComponentsConfiguration].
class DropdownComponentsConfiguration<T> extends ComponentsConfiguration<T> {
  DropdownComponentsConfiguration({
    SearchFieldComponent? searchFieldComponent,
    TriggerComponent? triggerComponent,
    MenuComponent? menuComponent,
    MenuPositionAndSizeComponent? menuPositionAndSizeComponent,
    SearchingIndicatorComponent? searchingIndicatorComponent,
    AnimationComponent? animationComponent,
    ListViewComponent? listViewComponent,
    SearchBarComponent? searchBarComponent,
    //
    TriggerFromItemComponent<T>? triggerFromItemComponent,
    //
    MenuFlexValues? menuFlexValues,
    MenuSizeConfiguration? menuSizeConfiguration,
    MenuAnimationDurations? menuAnimationDurations,
    MenuAnimationCurves? menuAnimationCurves,
  }) : super(
          searchFieldComponent:
              searchFieldComponent ?? DropdownSearchFieldComponent(),
          //
          searchingIndicatorComponent: searchingIndicatorComponent ??
              DropdownSearchingIndicatorComponent(),
          //
          animationComponent:
              animationComponent ?? DropdownAnimationComponent(),
          //
          menuPositionAndSizeComponent: menuPositionAndSizeComponent ??
              DropdownMenuPositionAndSizeComponent(),
          //
          triggerComponent: triggerComponent ?? DropdownTriggerComponent(),
          //
          menuComponent: menuComponent ?? DropdownMenuComponent(),
          //
          listViewComponent: listViewComponent ?? DropdownListViewComponent(),
          //
          searchBarComponent:
              searchBarComponent ?? DropdownSearchBarComponent(),
          //
          triggerFromItemComponent: triggerFromItemComponent,
          //
          menuFlexValues: menuFlexValues ?? defaultMenuFlexValues,
          //
          menuSizeConfiguration:
              menuSizeConfiguration ?? defaultMenuSizeConfiguration,
          //
          menuAnimationDurations:
              menuAnimationDurations ?? defaultMenuAnimationDurations,
          //
          menuAnimationCurves:
              menuAnimationCurves ?? defaultMenuAnimationCurves,
        );

  static MenuFlexValues defaultMenuFlexValues = MenuFlexValues(
    listView: 9,
    searchField: 2,
    searchBar: 0,
    searchingIndicator: 2,
  );

  static MenuSizeConfiguration defaultMenuSizeConfiguration =
      MenuSizeConfiguration(
    minHeightFraction: 0.3,
    minWidthFraction: 0.3,
    maxHeightFraction: 0.8,
    maxWidthFraction: 0.7,
  );

  static MenuAnimationDurations defaultMenuAnimationDurations =
      const MenuAnimationDurations(
    forward: Duration(milliseconds: 500),
    reverse: Duration(milliseconds: 500),
  );

  static MenuAnimationCurves defaultMenuAnimationCurves =
      const MenuAnimationCurves(
    forward: Curves.easeOut,
    reverse: Curves.easeOut,
  );
}

/// A [AnimationComponent] used by [DropdownComponentsConfiguration].
class DropdownAnimationComponent extends AnimationComponent
    with ComponentLifeCycleMixin {
  AnimationController? _animationController;
  late Animation<double> _animation;
  MenuState? _state;
  final double padding;

  DropdownAnimationComponent({this.padding = 8.0}) {
    super.builder = _builder;
  }

  Widget _builder(AnimationComponentData data) {
    if (_animationController == null) {
      _animationController = AnimationController(
        vsync: data.tickerProvider,
        duration: data.menuAnimationDurations.forward,
        reverseDuration: data.menuAnimationDurations.reverse,
      );

      _animationController!.addStatusListener((status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = MenuState.Opened;
            break;
          case AnimationStatus.reverse:
            _state = MenuState.Closed;
            break;
          case AnimationStatus.dismissed:
            continue completed;

          completed:
          case AnimationStatus.completed:
            if (_state == MenuState.Opened)
              data.opened();
            else
              data.closed();
            break;
        }
      });
      _animation = CurvedAnimation(
        parent: _animationController!,
        curve: data.menuAnimationCurves.forward,
        reverseCurve: data.menuAnimationCurves.reverse,
      );
    }
    if (data.menuState == MenuState.OpeningEnd) {
      _animationController!.forward();
    }

    if (data.menuState == MenuState.ClosingEnd) {
      Duration duration = Duration(
          microseconds: (data.menuAnimationDurations.reverse.inMicroseconds *
                  _animation.value)
              .round());
      if (duration < const Duration(milliseconds: 10)) {
        data.closed();
      } else {
        _animationController!.reverseDuration = duration;
        _animationController!.reverse();
      }
    }

    return Material(
      color: Colors.transparent,
      child: Card(
        margin: EdgeInsets.only(top: 2),
        shape: ContinuousRectangleBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(padding),
          child: SizeTransition(
            axisAlignment: -1.0,
            sizeFactor: _animation,
            child: data.child,
          ),
          constraints: BoxConstraints.loose(data.constraints!.biggest),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
  }

  @override
  void init() {
    _animationController = null;
  }
}

/// A [SearchFieldComponent] used by [DropdownComponentsConfiguration].
class DropdownSearchFieldComponent extends SearchFieldComponent {
  DropdownSearchFieldComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchFieldComponentData data) {
    Color accentColor = Theme.of(data.context).accentColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: accentColor.withAlpha(100),
          ),
        ),
      ),
      child: Center(
        child: TextField(
          cursorColor: accentColor,
          controller: data.searchTextController,
          style: Theme.of(data.context).textTheme.bodyText2,
          expands: false,
          maxLines: 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search...",
            contentPadding: const EdgeInsets.all(10.0),
          ),
        ),
      ),
    );
  }
}

/// A [SearchingIndicatorComponent] used by [DropdownComponentsConfiguration].
class DropdownSearchingIndicatorComponent extends SearchingIndicatorComponent {
  DropdownSearchingIndicatorComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchingIndicatorComponentData data) {
    double size = Theme.of(data.context).iconTheme.size ??
        Theme.of(data.context).textTheme.bodyText2!.fontSize ??
        15;
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: size / 5,
        ),
        width: size,
        height: size,
      ),
    );
  }
}

/// A [SearchBarComponent] used by [DropdownComponentsConfiguration].
class DropdownSearchBarComponent extends SearchBarComponent {
  DropdownSearchBarComponent() {
    super.builder = _builder;
  }

  Widget _builder(SearchBarComponentData data) {
    List<Widget> columnChildren = [];

    columnChildren.add(Flexible(
      flex: data.menuFlexValues.searchField!,
      child: data.searchField,
    ));

    if (data.isSearching!) {
      columnChildren.add(Flexible(
        flex: data.menuFlexValues.searchingIndicator!,
        child: data.searchingIndicator,
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: columnChildren,
    );
  }
}

/// A [ListViewComponent] used by [DropdownComponentsConfiguration].
class DropdownListViewComponent extends ListViewComponent {
  DropdownListViewComponent() {
    super.builder = _builder;
  }

  Widget _builder(ListViewComponentData data) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.0),
      itemBuilder: data.itemBuilder,
      itemCount: data.itemCount,
    );
  }
}

/// A [MenuComponent] used by [DropdownComponentsConfiguration].
class DropdownMenuComponent extends MenuComponent {
  DropdownMenuComponent() {
    super.builder = _builder;
  }

  Widget _builder(MenuComponentData data) {
    List<Widget> columnChildren = [];

    if (data.isSearchEnabled) {
      columnChildren.add(
        Expanded(
          flex: data.menuFlexValues.searchBar!,
          child: data.searchBar,
        ),
      );
    }

    columnChildren.add(
      Expanded(
        flex: data.menuFlexValues.listView!,
        child: data.listView,
      ),
    );

    return ClipRect(
      child: Column(
        children: columnChildren,
      ),
    );
  }
}

/// A [MenuPositionAndSizeComponent] used by [DropdownComponentsConfiguration].
class DropdownMenuPositionAndSizeComponent
    extends MenuPositionAndSizeComponent {
  DropdownMenuPositionAndSizeComponent() {
    super.builder = _builder;
  }

  MenuPositionAndSize _builder(MenuPositionAndSizeComponentData data) {
    MediaQueryData mqData = MediaQuery.of(data.context);

    final Offset buttonPosition = data.triggerPositionAndSize!.position;
    final Size buttonSize = data.triggerPositionAndSize!.size;
    BoxConstraints constraints = data.constraints!;

    // Height of visible screen area.
    double heightAvailable = constraints.maxHeight;

    // If constant height is requested.
    if (data.menuSizeConfiguration.requestConstantHeight) {
      Size? size = data.menuSizeConfiguration.getPreferredSize(mqData.size);
      constraints = BoxConstraints.tight(size ?? constraints.biggest);
    }
    if (data.menuSizeConfiguration.requestAvoidBottomInset) {
      heightAvailable = mqData.size.height -
          mqData.viewPadding.top -
          mqData.viewInsets.bottom;
    } else {
      heightAvailable = mqData.size.height - mqData.viewPadding.top;
    }

    // An offset that aligns button and menu to vertical center.
    double xOffset = -(constraints.maxWidth - buttonSize.width) / 2;

    // If offset makes the menu go out of screen bounds from left side.
    if (buttonPosition.dx + xOffset < 0) {
      xOffset = -buttonPosition.dx;
    } // If offset makes the menu go out of screen bounds from right side.
    else if (buttonPosition.dx + buttonSize.width - xOffset >
        mqData.size.width) {
      xOffset = -mqData.size.width +
          (buttonPosition.dx + constraints.maxWidth - xOffset);
    }

    constraints = constraints
        .copyWith(maxHeight: min(constraints.maxHeight, heightAvailable))
        .normalize();

    // An offset that pushes the menu down, so the button is visible.
    double yOffset = buttonSize.height;

    double midScreenY = heightAvailable / 2;

    // Is on upper half of available space
    if (buttonPosition.dy - mqData.viewPadding.top + buttonSize.height / 2 <
        midScreenY) {
      // How much size can the menu take below the trigger
      constraints = constraints
          .copyWith(
              maxHeight: min(
                  constraints.maxHeight,
                  heightAvailable -
                      buttonSize.height -
                      buttonPosition.dy +
                      mqData.viewPadding.top))
          .normalize();
      // if overflows below, this means minHeight was larger than maxHeight
      if (buttonPosition.dy -
              mqData.viewPadding.top +
              yOffset +
              constraints.maxHeight >
          heightAvailable) {
        // offset so that the bottom of menu matches with the bottom of the view
        yOffset = -buttonPosition.dy +
            heightAvailable +
            mqData.viewPadding.top -
            constraints.maxHeight;
        // if overflows from above, offset it down to the top of view
        if (yOffset + buttonPosition.dy < mqData.viewPadding.top)
          yOffset = -buttonPosition.dy + mqData.viewPadding.top;
      }
    } else {
      // is on the lower half of available space
      // How much space can it take above the trigger
      constraints = constraints
          .copyWith(
              maxHeight: min(constraints.maxHeight,
                  buttonPosition.dy - mqData.viewPadding.top))
          .normalize();

      // button is below view
      if (buttonPosition.dy - mqData.viewPadding.top > heightAvailable) {
        // Offset menu so that the menu bottom matches the view bottom
        yOffset = -buttonPosition.dy +
            mqData.viewPadding.top +
            heightAvailable -
            constraints.maxHeight;
      } else {
        // Offset menu so that the menu bottom matches the trigger top edge
        yOffset = -constraints.maxHeight;
      }
      if (buttonPosition.dy + yOffset < mqData.viewPadding.top) {
        yOffset = -buttonPosition.dy + mqData.viewPadding.top;
      }
    }

    return MenuPositionAndSize(
      constraints: constraints,
      positionOffset: Offset(xOffset, yOffset),
    );
  }
}

/// A [TriggerComponent] used by [DropdownComponentsConfiguration].
class DropdownTriggerComponent extends TriggerComponent {
  DropdownTriggerComponent() {
    super.builder = _builder;
  }

  Widget _builder(TriggerComponentData data) {
    return ElevatedButton(
      onPressed: data.triggerMenu,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text("Choose "),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
