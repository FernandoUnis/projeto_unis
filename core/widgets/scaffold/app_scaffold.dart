import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumen_caeli/core/constants/app_colors.dart';
import 'package:lumen_caeli/core/widgets/scaffold/default_app_bar.dart';
import 'package:lumen_caeli/core/widgets/scaffold/status_bar_theme.dart';

class AppScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final bool isVisibleAppBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final Widget? drawer;
  final ValueChanged<bool>? onDrawerChanged;
  final Widget? endDrawer;
  final ValueChanged<bool>? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final StatusBarTheme statusBarTheme;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const AppScaffold({
    super.key,
    this.isVisibleAppBar = false,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor = AppColors.white,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.statusBarTheme = StatusBarTheme.primary,
    this.systemOverlayStyle,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: widget.systemOverlayStyle ?? widget.statusBarTheme.style(),
      child: Scaffold(
        appBar:
            widget.appBar ??
            (widget.isVisibleAppBar
                ? DefaultAppBar(statusBarTheme: widget.statusBarTheme)
                : null),
        body: widget.body,
        // Platform.isIOS &&
        //     widget.appBar == null &&
        //     !widget.isVisibleAppBar &&
        //     !widget.extendBodyBehindAppBar
        // ? StatusBarContainer(
        //     statusBarColor: widget.statusBarTheme.style().statusBarColor,
        //     child: widget.body ?? SizedBox(),
        //   )
        // : widget.body,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        persistentFooterButtons: widget.persistentFooterButtons,
        persistentFooterAlignment: widget.persistentFooterAlignment,
        drawer: widget.drawer,
        onDrawerChanged: widget.onDrawerChanged,
        endDrawer: widget.endDrawer,
        onEndDrawerChanged: widget.onEndDrawerChanged,
        bottomNavigationBar: widget.bottomNavigationBar,
        bottomSheet: widget.bottomSheet,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        primary: widget.primary,
        drawerDragStartBehavior: widget.drawerDragStartBehavior,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        drawerScrimColor: widget.drawerScrimColor,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        restorationId: widget.restorationId,
      ),
    );
  }
}

class StatusBarContainer extends StatelessWidget {
  final Color? statusBarColor;
  final Widget child;

  const StatusBarContainer({
    super.key,
    required this.child,
    this.statusBarColor,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        Container(
          height: statusBarHeight,
          color: statusBarColor ?? AppColors.onPrimaryColor,
        ),
        Padding(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: child,
        ),
      ],
    );
  }
}
