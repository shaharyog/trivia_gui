import 'package:flutter/material.dart';

const double _kDisableSearchBarOpacity = 0.38;

/// A Material Design search bar.
///
/// A [SearchBarCustom] looks like a [TextField]. Tapping a SearchBar typically shows a
/// "search view" route: a route with the search bar at the top and a list of
/// suggested completions for the search bar's text below. [SearchBarCustom]s are
/// usually created by a [SearchAnchor.builder]. The builder provides a
/// [SearchController] that's used by the search bar's [SearchBarCustom.onTap] or
/// [SearchBarCustom.onChanged] callbacks to show the search view and to hide it
/// when the user selects a suggestion.
///
/// For [TextDirection.ltr], the [leading] widget is on the left side of the bar.
/// It should contain either a navigational action (such as a menu or up-arrow)
/// or a non-functional search icon.
///
/// The [trailing] is an optional list that appears at the other end of
/// the search bar. Typically only one or two action icons are included.
/// These actions can represent additional modes of searching (like voice search),
/// a separate high-level action (such as current location) or an overflow menu.
///
/// {@tool dartpad}
/// This example demonstrates how to use a [SearchBarCustom] as the return value of the
/// [SearchAnchor.builder] property. The [SearchBarCustom] also includes a leading search
/// icon and a trailing action to toggle the brightness.
///
/// ** See code in examples/api/lib/material/search_anchor/search_bar.0.dart **
/// {@end-tool}
///
/// See also:
///
/// * [SearchAnchor], a widget that typically uses an [IconButton] or a [SearchBarCustom]
/// to manage a "search view" route.
/// * [SearchBarTheme], a widget that overrides the default configuration of a search bar.
/// * [SearchViewTheme], a widget that overrides the default configuration of a search view.
class SearchBarCustom extends StatefulWidget {
  /// Creates a Material Design search bar.
  const SearchBarCustom({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.leading,
    this.trailing,
    this.onTap,
    this.onTapOutside,
    this.onChanged,
    this.onSubmitted,
    this.constraints,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.textCapitalization,
    this.enabled = true,
    this.autoFocus = false,
    this.textInputAction,
    this.keyboardType,
  });

  /// Controls the text being edited in the search bar's text field.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed at the same location on the screen where text may be entered
  /// when the input is empty.
  ///
  /// Defaults to null.
  final String? hintText;

  /// A widget to display before the text input field.
  ///
  /// Typically the [leading] widget is an [Icon] or an [IconButton].
  final Widget? leading;

  /// A list of Widgets to display in a row after the text field.
  ///
  /// Typically these actions can represent additional modes of searching
  /// (like voice search), an avatar, a separate high-level action (such as
  /// current location) or an overflow menu. There should not be more than
  /// two trailing actions.
  final Iterable<Widget>? trailing;

  /// Called when the user taps this search bar.
  final GestureTapCallback? onTap;

  /// Called when the user taps outside the search bar.
  final TapRegionCallback? onTapOutside;

  /// Invoked upon user input.
  final ValueChanged<String>? onChanged;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  final ValueChanged<String>? onSubmitted;

  /// Optional size constraints for the search bar.
  ///
  /// If null, the value of [SearchBarThemeData.constraints] will be used. If
  /// this is also null, then the constraints defaults to:
  /// ```dart
  /// const BoxConstraints(minWidth: 360.0, maxWidth: 800.0, minHeight: 56.0)
  /// ```
  final BoxConstraints? constraints;

  /// The elevation of the search bar's [Material].
  ///
  /// If null, the value of [SearchBarThemeData.elevation] will be used. If this
  /// is also null, then default value is 6.0.
  final WidgetStateProperty<double?>? elevation;

  /// The search bar's background fill color.
  ///
  /// If null, the value of [SearchBarThemeData.backgroundColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.surfaceContainerHigh].
  final WidgetStateProperty<Color?>? backgroundColor;

  /// The shadow color of the search bar's [Material].
  ///
  /// If null, the value of [SearchBarThemeData.shadowColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.shadow].
  final WidgetStateProperty<Color?>? shadowColor;

  /// The surface tint color of the search bar's [Material].
  ///
  /// This is not recommended for use. [Material 3 spec](https://m3.material.io/styles/color/the-color-system/color-roles)
  /// introduced a set of tone-based surfaces and surface containers in its [ColorScheme],
  /// which provide more flexibility. The intention is to eventually remove surface tint color from
  /// the framework.
  ///
  /// If null, the value of [SearchBarThemeData.surfaceTintColor] will be used.
  /// If this is also null, then the default value is [Colors.transparent].
  final WidgetStateProperty<Color?>? surfaceTintColor;

  /// The highlight color that's typically used to indicate that
  /// the search bar is focused, hovered, or pressed.
  final WidgetStateProperty<Color?>? overlayColor;

  /// The color and weight of the search bar's outline.
  ///
  /// This value is combined with [shape] to create a shape decorated
  /// with an outline.
  ///
  /// If null, the value of [SearchBarThemeData.side] will be used. If this is
  /// also null, the search bar doesn't have a side by default.
  final WidgetStateProperty<BorderSide?>? side;

  /// The shape of the search bar's underlying [Material].
  ///
  /// This shape is combined with [side] to create a shape decorated
  /// with an outline.
  ///
  /// If null, the value of [SearchBarThemeData.shape] will be used.
  /// If this is also null, defaults to [StadiumBorder].
  final WidgetStateProperty<OutlinedBorder?>? shape;

  /// The padding between the search bar's boundary and its contents.
  ///
  /// If null, the value of [SearchBarThemeData.padding] will be used.
  /// If this is also null, then the default value is 16.0 horizontally.
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  /// The style to use for the text being edited.
  ///
  /// If null, defaults to the `bodyLarge` text style from the current [Theme].
  /// The default text color is [ColorScheme.onSurface].
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// The style to use for the [hintText].
  ///
  /// If null, the value of [SearchBarThemeData.hintStyle] will be used. If this
  /// is also null, the value of [textStyle] will be used. If this is also null,
  /// defaults to the `bodyLarge` text style from the current [Theme].
  /// The default text color is [ColorScheme.onSurfaceVariant].
  final WidgetStateProperty<TextStyle?>? hintStyle;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization? textCapitalization;

  /// If false the text field is "disabled" so the SearchBar will ignore taps.
  final bool enabled;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autoFocus;

  /// {@macro flutter.widgets.TextField.textInputAction}
  final TextInputAction? textInputAction;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to the default value specified in [TextField].
  final TextInputType? keyboardType;

  @override
  State<SearchBarCustom> createState() => _SearchBarCustomState();
}

class _SearchBarCustomState extends State<SearchBarCustom> {
  late final WidgetStatesController _internalStatesController;
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _internalStatesController = WidgetStatesController();
    _internalStatesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _internalStatesController.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final IconThemeData iconTheme = IconTheme.of(context);
    final SearchBarThemeData searchBarTheme = SearchBarTheme.of(context);
    final SearchBarThemeData defaults = _SearchBarDefaultsM3(context);

    T? resolve<T>(
      WidgetStateProperty<T>? widgetValue,
      WidgetStateProperty<T>? themeValue,
      WidgetStateProperty<T>? defaultValue,
    ) {
      final Set<WidgetState> states = _internalStatesController.value;
      return widgetValue?.resolve(states) ??
          themeValue?.resolve(states) ??
          defaultValue?.resolve(states);
    }

    final TextStyle? effectiveTextStyle = resolve<TextStyle?>(
        widget.textStyle, searchBarTheme.textStyle, defaults.textStyle);
    final double? effectiveElevation = resolve<double?>(
        widget.elevation, searchBarTheme.elevation, defaults.elevation);
    final Color? effectiveShadowColor = resolve<Color?>(
        widget.shadowColor, searchBarTheme.shadowColor, defaults.shadowColor);
    final Color? effectiveBackgroundColor = resolve<Color?>(
        widget.backgroundColor,
        searchBarTheme.backgroundColor,
        defaults.backgroundColor);
    final Color? effectiveSurfaceTintColor = resolve<Color?>(
        widget.surfaceTintColor,
        searchBarTheme.surfaceTintColor,
        defaults.surfaceTintColor);
    final OutlinedBorder? effectiveShape = resolve<OutlinedBorder?>(
        widget.shape, searchBarTheme.shape, defaults.shape);
    final BorderSide? effectiveSide =
        resolve<BorderSide?>(widget.side, searchBarTheme.side, defaults.side);
    final EdgeInsetsGeometry? effectivePadding = resolve<EdgeInsetsGeometry?>(
        widget.padding, searchBarTheme.padding, defaults.padding);
    final WidgetStateProperty<Color?>? effectiveOverlayColor =
        widget.overlayColor ??
            searchBarTheme.overlayColor ??
            defaults.overlayColor;
    final TextCapitalization effectiveTextCapitalization =
        widget.textCapitalization ??
            searchBarTheme.textCapitalization ??
            defaults.textCapitalization!;

    final Set<WidgetState> states = _internalStatesController.value;
    final TextStyle? effectiveHintStyle = widget.hintStyle?.resolve(states) ??
        searchBarTheme.hintStyle?.resolve(states) ??
        widget.textStyle?.resolve(states) ??
        searchBarTheme.textStyle?.resolve(states) ??
        defaults.hintStyle?.resolve(states);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isIconThemeColorDefault(Color? color) {
      if (isDark) {
        return color == kDefaultIconLightColor;
      }
      return color == kDefaultIconDarkColor;
    }

    Widget? leading;
    if (widget.leading != null) {
      leading = IconTheme.merge(
        data: isIconThemeColorDefault(iconTheme.color)
            ? IconThemeData(color: colorScheme.onSurface)
            : iconTheme,
        child: widget.leading!,
      );
    }

    List<Widget>? trailing;
    if (widget.trailing != null) {
      trailing = widget.trailing
          ?.map((Widget trailing) => IconTheme.merge(
                data: isIconThemeColorDefault(iconTheme.color)
                    ? IconThemeData(color: colorScheme.onSurfaceVariant)
                    : iconTheme,
                child: trailing,
              ))
          .toList();
    }

    return ConstrainedBox(
      constraints: widget.constraints ??
          searchBarTheme.constraints ??
          defaults.constraints!,
      child: Opacity(
        opacity: widget.enabled ? 1 : _kDisableSearchBarOpacity,
        child: Material(
          elevation: effectiveElevation!,
          shadowColor: effectiveShadowColor,
          color: effectiveBackgroundColor,
          surfaceTintColor: effectiveSurfaceTintColor,
          shape: effectiveShape?.copyWith(side: effectiveSide),
          child: IgnorePointer(
            ignoring: !widget.enabled,
            child: InkWell(
              mouseCursor: MouseCursor.defer,
              onTap: () {
                widget.onTap?.call();
                if (!_focusNode.hasFocus) {
                  _focusNode.requestFocus();
                }
              },
              overlayColor: effectiveOverlayColor,
              customBorder: effectiveShape?.copyWith(side: effectiveSide),
              statesController: _internalStatesController,
              child: Padding(
                padding: effectivePadding!,
                child: Row(
                  textDirection: textDirection,
                  children: <Widget>[
                    if (leading != null) leading,
                    Expanded(
                      child: Padding(
                        padding: effectivePadding,
                        child: TextField(
                          autofocus: widget.autoFocus,
                          onTap: widget.onTap,
                          onTapAlwaysCalled: true,
                          onTapOutside: widget.onTapOutside,
                          focusNode: _focusNode,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          controller: widget.controller,
                          style: effectiveTextStyle,
                          enabled: widget.enabled,
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                          ).applyDefaults(
                            InputDecorationTheme(
                              hintStyle: effectiveHintStyle,
                              // The configuration below is to make sure that the text field
                              // in `SearchBar` will not be overridden by the overall `InputDecorationTheme`
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              // Setting `isDense` to true to allow the text field height to be
                              // smaller than 48.0
                              isDense: true,
                            ),
                          ),
                          textCapitalization: effectiveTextCapitalization,
                          textInputAction: widget.textInputAction,
                          keyboardType: widget.keyboardType,
                        ),
                      ),
                    ),
                    if (trailing != null) ...trailing,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBarDefaultsM3 extends SearchBarThemeData {
  _SearchBarDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  WidgetStateProperty<Color?>? get backgroundColor =>
      WidgetStatePropertyAll<Color>(_colors.surfaceContainerHigh);

  @override
  WidgetStateProperty<double>? get elevation =>
      const WidgetStatePropertyAll<double>(6.0);

  @override
  WidgetStateProperty<Color>? get shadowColor =>
      WidgetStatePropertyAll<Color>(_colors.shadow);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor =>
      const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color?>? get overlayColor =>
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurface.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSurface.withOpacity(0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return Colors.transparent;
        }
        return Colors.transparent;
      });

  // No default side

  @override
  WidgetStateProperty<OutlinedBorder>? get shape =>
      const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding =>
      const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 8.0));

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
      WidgetStatePropertyAll<TextStyle?>(
          _textTheme.bodyLarge?.copyWith(color: _colors.onSurface));

  @override
  WidgetStateProperty<TextStyle?> get hintStyle =>
      WidgetStatePropertyAll<TextStyle?>(
          _textTheme.bodyLarge?.copyWith(color: _colors.onSurfaceVariant));

  @override
  BoxConstraints get constraints =>
      const BoxConstraints(minWidth: 360.0, maxWidth: 800.0, minHeight: 56.0);

  @override
  TextCapitalization get textCapitalization => TextCapitalization.none;
}
