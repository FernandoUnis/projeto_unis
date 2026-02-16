import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumen_caeli/core/constants/app_colors.dart';
import 'package:lumen_caeli/core/widgets/scaffold/status_bar_theme.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Brightness? statusBarBrightness;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final bool Function(ScrollNotification) notificationPredicate;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final bool useDefaultSemanticsOrder;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry? actionsPadding;
  final StatusBarTheme? statusBarTheme;

  const DefaultAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.useDefaultSemanticsOrder = true,
    this.clipBehavior,
    this.actionsPadding,
    this.statusBarBrightness,
    this.statusBarTheme,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    (toolbarHeight ?? 80.0) + (bottom?.preferredSize.height ?? 0.0),
  );

  @override
  Widget build(BuildContext context) {
    final whiteIconTheme = IconThemeData(color: AppColors.white);
    return AppBar(
      key: key,
      leading:
          leading ??
          (automaticallyImplyLeading
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.maybePop(context);
                  },
                )
              : null),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: gratientBackground(),
      bottom: bottom,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      notificationPredicate: notificationPredicate,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      foregroundColor: foregroundColor,
      backgroundColor: fallbackIfSecondary(
        backgroundColor,
        AppColors.primaryColor,
      ),
      iconTheme: fallbackIfSecondary(iconTheme, whiteIconTheme),
      actionsIconTheme: fallbackIfSecondary(actionsIconTheme, whiteIconTheme),
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: toolbarHeight ?? 80.0,
      leadingWidth: leadingWidth,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      useDefaultSemanticsOrder: useDefaultSemanticsOrder,
      clipBehavior: Clip.antiAlias,
      shape:
          shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
      actionsPadding: actionsPadding,
      systemOverlayStyle: systemOverlayStyle ?? _resolveOverlayStyle(),
    );
  }

  T? fallbackIfSecondary<T>(T? value, T fallback) {
    final isSecondary = statusBarTheme != StatusBarTheme.primary;
    return value ?? (isSecondary ? fallback : null);
  }

  SystemUiOverlayStyle _resolveOverlayStyle() {
    if (systemOverlayStyle != null) return systemOverlayStyle!;
    return statusBarTheme == null
        ? StatusBarTheme.primary.style()
        : statusBarTheme!.style();
  }

  Widget? gratientBackground() {
    if (flexibleSpace == null &&
        (statusBarTheme == null || statusBarTheme == StatusBarTheme.primary)) {
      return Container(
        decoration: BoxDecoration(gradient: AppColors.gradientPrimary),
      );
    }
    return flexibleSpace;
  }
}
