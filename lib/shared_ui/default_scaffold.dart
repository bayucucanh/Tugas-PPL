import 'package:bottom_inset_observer/bottom_inset_observer.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:velocity_x/velocity_x.dart';

enum KeyboardStatus {
  idle,
  increase,
  decrease,
}

class DefaultScaffold extends StatefulWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? body;
  final bool? centerTitle;
  final PreferredSize? bottom;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final List<Widget>? persistentFooterButtons;
  final Color? backgroundColor;
  final Widget? bottomSheet;
  final bool? showAppBar;
  final bool? resizeToAvoidBottomInset;

  const DefaultScaffold({
    Key? key,
    this.title,
    this.backgroundColor = Colors.white,
    this.leading,
    this.body,
    this.actions,
    this.centerTitle,
    this.bottom,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.persistentFooterButtons,
    this.bottomSheet,
    this.showAppBar = true,
    this.resizeToAvoidBottomInset = true,
  }) : super(key: key);

  @override
  State<DefaultScaffold> createState() => _DefaultScaffoldState();
}

class _DefaultScaffoldState extends State<DefaultScaffold> {
  // KeyboardStatus _status = KeyboardStatus.idle;
  double _viewInset = 0.0;
  // bool _isVisible = false;
  late BottomInsetObserver _insetObserver;

  @override
  void initState() {
    super.initState();
    _insetObserver = BottomInsetObserver()..addListener(_keyboardHandle);
  }

  @override
  void dispose() {
    /// Unregisters the observer observer and remove all listeners
    _insetObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      appBar: widget.showAppBar == false
          ? null
          : AppBar(
              centerTitle: widget.centerTitle,
              title: widget.title,
              actions: widget.actions,
              bottom: widget.bottom,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(appBarBackground),
                    fit: BoxFit.fill,
                  ),
                ),
              ).h(150),
              leading: widget.leading,
              elevation: 0,
            ),
      body: widget.resizeToAvoidBottomInset == false
          ? widget.body?.pOnly(bottom: _viewInset).safeArea(
                maintainBottomViewPadding: true,
                bottom: false,
              )
          : widget.body,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
      persistentFooterButtons: widget.persistentFooterButtons,
      bottomSheet: widget.bottomSheet,
    );
  }

  void _keyboardHandle(BottomInsetChanges change) {
    setState(() {
      /// getting current inset and check current status
      /// of keyboard visability
      // _isVisible = change.currentInset > 0;
      _viewInset = change.currentInset;

      /// get delta since last change and check current status of changes
      // if (change.delta == 0) _status = KeyboardStatus.idle;
      // if (change.delta > 0) _status = KeyboardStatus.increase;
      // if (change.delta < 0) _status = KeyboardStatus.decrease;
    });
  }
}
