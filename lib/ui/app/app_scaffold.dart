import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/redux/dashboard/dashboard_actions.dart';
import 'package:invoiceninja_flutter/redux/ui/ui_state.dart';
import 'package:invoiceninja_flutter/ui/app/app_bottom_bar.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';

import 'app_drawer_vm.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {@required this.appBarTitle,
      @required this.body,
      this.appBarActions,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.isChecked,
      this.onCheckboxChanged,
      this.showCheckbox = false,
      this.hideHamburgerButton = false});

  final Widget body;
  final AppBottomBar bottomNavigationBar;
  final FloatingActionButton floatingActionButton;
  final Widget appBarTitle;
  final List<Widget> appBarActions;
  final bool hideHamburgerButton;
  final bool showCheckbox;
  final Function(bool) onCheckboxChanged;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final showMenuIcon =
        !showCheckbox && !isMobile(context) && !hideHamburgerButton;

    return WillPopScope(
        onWillPop: () async {
          store.dispatch(ViewDashboard(context: context));
          return false;
        },
        child: Scaffold(
          drawer: isMobile(context) ? AppDrawerBuilder() : null,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: showCheckbox
                ? Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: onCheckboxChanged,
                    activeColor: Theme.of(context).accentColor,
                    value: isChecked)
                : showMenuIcon
                    ? IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () =>
                            store.dispatch(UpdateSidebar(AppSidebar.menu)),
                      )
                    : null,
            title: appBarTitle,
            actions: appBarActions,
          ),
          body: body,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ));
  }
}
