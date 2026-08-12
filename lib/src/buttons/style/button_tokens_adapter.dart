import 'package:flutter/material.dart';

import '../internal/button_constants.dart';
import 'm3e_button_enums.dart';

/// Material 3 Button Measurements
///
/// Represents the calculated dimensions and spacing for a button based on its size
/// and any custom overrides. Immutable value object that encapsulates all the
/// dimensional properties of a button.
///
/// ## Properties
///
/// - [height]: Total button height in logical pixels
/// - [hPadding]: Horizontal padding on each side in logical pixels
/// - [iconSize]: Icon size in logical pixels when present
/// - [iconGap]: Gap between icon and label in logical pixels
///
/// ## Usage
/// ```dart
/// final measurements = M3EButtonMeasurements(
///   height: 40,
///   hPadding: 16,
///   iconSize: 20,
///   iconGap: 8,
/// );
///
/// // Apply custom size overrides
/// final customMeasurements = measurements.applyCustomSize(
///   M3EButtonSize.custom(
///     height: 48,
///     hPadding: 24,
///   )
/// );
/// ```
@immutable
class M3EButtonMeasurements {
  const M3EButtonMeasurements({
    required this.height,
    required this.hPadding,
    required this.iconSize,
    required this.iconGap,
  });
  final double height;

  /// Horizontal padding
  final double hPadding;
  final double iconSize;
  final double iconGap;

  /// Returns a copy with any non-null fields from [custom] applied.
  ///
  /// This method allows for partial overrides of the measurements while
  /// preserving the original values for any null fields in the custom size.
  ///
  /// ## Parameters
  /// - [custom]: The size variant containing optional new values
  ///
  /// ## Returns
  /// A new [M3EButtonMeasurements] instance with overridden values applied
  M3EButtonMeasurements applyCustomSize(M3EButtonSize? custom) {
    if (custom == null) return this;
    return M3EButtonMeasurements(
      height: custom.height ?? height,
      hPadding: custom.hPadding ?? hPadding,
      iconSize: custom.iconSize ?? iconSize,
      iconGap: custom.iconGap ?? iconGap,
    );
  }
}

/// Material 3 Button Tokens Adapter
///
/// Provides access to Material 3 design tokens for button styling and layout.
/// This adapter bridges the gap between Material 3 design tokens and the
/// concrete button implementation, ensuring consistent theming across the
/// application.
///
/// ## Caching Contract
///
/// This adapter caches resolved `ColorScheme` lookups to eliminate redundant
/// calculations during builds. The cache is invalidated when `didChangeDependencies`
/// is called and the `ColorScheme` identity changes.
///
/// Subclasses that override `didChangeDependencies` **must** call `super.didChangeDependencies()`
/// to maintain proper caching behavior.
///
/// ## Stability notice
///
/// [M3EButtonTokensAdapter] is a **framework-internal** helper exported for
/// advanced use-cases (e.g. building custom button variants that need to share
/// token values). It holds a [BuildContext] and must not be stored across
/// widget lifecycles. Its API has **no stability guarantee** — methods may be
/// added, removed, or renamed in future versions without a deprecation period.
/// Prefer the public widget API ([M3EButton], [M3EToggleButton]) for all
/// normal usage.
///
/// ## Design Token Categories
///
/// ### Container Colors
/// - [container()]: Background color for different button styles
/// - [foreground()]: Text/icon color for different button styles
/// - [outline()]: Outline color for outlined buttons
///
/// ### Elevation
/// - [elevation()]: Elevation values based on button style and state
///
/// ### Shape
/// - [squareRadius()]: Corner radius for square buttons
/// - [pressedRadius()]: Corner radius when button is pressed
///
/// ### Measurements
/// - [measurements()]: Complete size and spacing configuration
class M3EButtonTokensAdapter {
  M3EButtonTokensAdapter(this.context) {
    _updateCache();
  }
  final BuildContext context;

  ColorScheme? _cachedColorScheme;
  TextTheme? _cachedTextTheme;

  Color? _cachedOutline;
  Color? _cachedFocusRingColor;
  double? _cachedFocusRingWidth;
  double? _cachedFocusRingGap;
  double? _cachedMinWidthFloor;
  double? _cachedDividerHeight;

  static final Map<M3EButtonSize, double> _squareRadiusTable =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 12.0,
        M3EButtonSize.sm: 12.0,
        M3EButtonSize.md: 16.0,
        M3EButtonSize.lg: 28.0,
        M3EButtonSize.xl: 28.0,
      });

  static final Map<M3EButtonSize, double> _pressedRadiusTable =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 8.0,
        M3EButtonSize.sm: 8.0,
        M3EButtonSize.md: 12.0,
        M3EButtonSize.lg: 16.0,
        M3EButtonSize.xl: 16.0,
      });

  // TODO hovered shouldnt morph shape
  static final Map<M3EButtonSize, double> _hoveredRadiusTable =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 10.0,
        M3EButtonSize.sm: 10.0,
        M3EButtonSize.md: 14.0,
        M3EButtonSize.lg: 22.0,
        M3EButtonSize.xl: 22.0,
      });

  // TODO where do these come from?
  static final Map<M3EButtonSize, double> _equalizedMinWidthTable =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 40.0,
        M3EButtonSize.sm: 56.0,
        M3EButtonSize.md: 72.0,
        M3EButtonSize.lg: 96.0,
        M3EButtonSize.xl: 120.0,
      });

  static final Map<M3EButtonSize, M3EButtonMeasurements> _measurementsTable =
      Map<M3EButtonSize, M3EButtonMeasurements>.unmodifiable({
        M3EButtonSize.xs: const M3EButtonMeasurements(
          height: 32,
          hPadding: 12,
          iconSize: 20,
          iconGap: 4,
        ),
        M3EButtonSize.sm: const M3EButtonMeasurements(
          height: 40,
          hPadding: 16,
          iconSize: 20,
          iconGap: 8,
        ),
        M3EButtonSize.md: const M3EButtonMeasurements(
          height: 56,
          hPadding: 24,
          iconSize: 24,
          iconGap: 8,
        ),
        M3EButtonSize.lg: const M3EButtonMeasurements(
          height: 96,
          hPadding: 48,
          iconSize: 32,
          iconGap: 12,
        ),
        M3EButtonSize.xl: const M3EButtonMeasurements(
          height: 136,
          hPadding: 64,
          iconSize: 40,
          iconGap: 16,
        ),
      });

  static final Map<M3EIconButtonWidth, Map<M3EButtonSize, double>>
  _iconButtonWidthTable =
      Map<M3EIconButtonWidth, Map<M3EButtonSize, double>>.unmodifiable({
        M3EIconButtonWidth.narrow: {
          M3EButtonSize.xs: 28.0,
          M3EButtonSize.sm: 32.0,
          M3EButtonSize.md: 48.0,
          M3EButtonSize.lg: 64.0,
          M3EButtonSize.xl: 104.0,
        },
        M3EIconButtonWidth.standard: {
          M3EButtonSize.xs: 32.0,
          M3EButtonSize.sm: 40.0,
          M3EButtonSize.md: 56.0,
          M3EButtonSize.lg: 96.0,
          M3EButtonSize.xl: 136.0,
        },
        M3EIconButtonWidth.wide: {
          M3EButtonSize.xs: 40.0,
          M3EButtonSize.sm: 52.0,
          M3EButtonSize.md: 72.0,
          M3EButtonSize.lg: 128.0,
          M3EButtonSize.xl: 184.0,
        },
      });

  bool _shouldRecache() {
    final theme = Theme.of(context);
    final currentColorScheme = theme.colorScheme;
    final currentTextTheme = theme.textTheme;
    return !identical(_cachedColorScheme, currentColorScheme) ||
        !identical(_cachedTextTheme, currentTextTheme);
  }

  void _updateCache() {
    final theme = Theme.of(context);
    _cachedColorScheme = theme.colorScheme;
    _cachedTextTheme = theme.textTheme;

    _cachedOutline = _cachedColorScheme!.outlineVariant;
    _cachedFocusRingColor = _cachedColorScheme!.secondary;
    _cachedFocusRingWidth = 2.0;
    _cachedFocusRingGap = ButtonConstants.kFocusRingGap;
    _cachedMinWidthFloor = 48.0;
    _cachedDividerHeight = 24.0;
  }

  /// Updates cached values when dependencies change.
  ///
  /// Subclasses that override this method **must** call `super.didChangeDependencies()`
  /// to maintain proper caching behavior.
  @mustCallSuper
  void didChangeDependencies() {
    if (_shouldRecache()) {
      _updateCache();
    }
  }

  ThemeData get _t => Theme.of(context);
  ColorScheme get c => _cachedColorScheme ?? _t.colorScheme;

  /// Gets the container (background) color for the specified button style.
  Color container(M3EButtonStyle style) {
    switch (style) {
      case M3EButtonStyle.filled:
        return c.primary;
      case M3EButtonStyle.tonal:
        return c.secondaryContainer;
      case M3EButtonStyle.elevated:
        return c.surfaceContainerLow;
      case M3EButtonStyle.outlined:
      case M3EButtonStyle.text:
      case M3EButtonStyle.standard:
        return Colors.transparent;
    }
  }

  /// Gets the foreground (text/icon) color for the specified button style.
  Color foreground(M3EButtonStyle style) {
    switch (style) {
      case M3EButtonStyle.filled:
        return c.onPrimary;
      case M3EButtonStyle.tonal:
        return c.onSecondaryContainer;
      case M3EButtonStyle.outlined:
      case M3EButtonStyle.standard:
        return c.onSurfaceVariant;
      case M3EButtonStyle.elevated:
      case M3EButtonStyle.text:
        return c.primary;
    }
  }

  /// Gets the outline color for outlined buttons.
  Color outline() => _cachedOutline ?? c.outlineVariant;

  /// Gets the outline width for outlined buttons.
  double outlineWidth(M3EButtonSize size) {
    switch (size) {
      case .xs:
      case .sm:
      case .md:
        return 1;
      case .lg:
      case .xl:
        return 2;
      default:
        return 1;
    }
  }

  /// Gets the color for the Material 3 Expressive focus ring.
  Color focusRingColor() => _cachedFocusRingColor ?? c.secondary;

  /// Gets the width of the focus ring border.
  double focusRingWidth() => _cachedFocusRingWidth ?? 2.0;

  /// Gets the gap between the component and the focus ring.
  double focusRingGap() => _cachedFocusRingGap ?? 4.0;

  /// Gets the elevation value for the specified button style and state.
  double elevation(M3EButtonStyle style, Set<WidgetState> states) {
    final hovered = states.contains(WidgetState.hovered);
    final pressed = states.contains(WidgetState.pressed);
    final disabled = states.contains(WidgetState.disabled);
    if (disabled) return 0;
    switch (style) {
      case M3EButtonStyle.elevated:
        return pressed
            ? 1
            : hovered
            ? 3
            : 1;
      case M3EButtonStyle.filled:
      case M3EButtonStyle.tonal:
        return hovered ? 1 : 0;
      case M3EButtonStyle.outlined:
      case M3EButtonStyle.standard:
      case M3EButtonStyle.text:
        return 0;
    }
  }

  /// Gets the square corner radius for the specified button size.
  double squareRadius(M3EButtonSize size) => _squareRadiusTable[size] ?? 12;

  /// Gets the pressed corner radius for the specified button size.
  double pressedRadius(M3EButtonSize size) => _pressedRadiusTable[size] ?? 12.0;

  /// Gets the hovered corner radius for the specified button size.
  double hoveredRadius(M3EButtonSize size) => _hoveredRadiusTable[size] ?? 16.0;

  /// Default inner corner radius for connected buttons.
  double connectedInnerRadius() => 8.0;

  /// Default pressed inner corner radius for connected buttons.
  double connectedPressedInnerRadius() => 4.0;

  /// Default hovered inner corner radius for connected buttons.

  /// Minimum touch target height for standard buttons.
  double minWidthFloor() => _cachedMinWidthFloor ?? 48.0;

  /// Gets the minimum width for equalized buttons in a group.
  double equalizedMinWidth(M3EButtonSize size) =>
      _equalizedMinWidthTable[size] ?? 72.0;

  /// Gets the height (or width for vertical) of a divider.
  double dividerHeight() => _cachedDividerHeight ?? 24.0;

  /// Gets the complete measurements for the specified button size with optional custom overrides.
  M3EButtonMeasurements measurements(
    M3EButtonSize size, {
    M3EButtonSize? override,
  }) {
    final base = _tokenMeasurements(size);
    if (override == null) {
      if (size.name == 'custom') {
        return base.applyCustomSize(size);
      }
      return base;
    }

    // If the override is a standard size (e.g. M3EButtonSize.sm),
    // we use its token dimensions as the new base.
    final overrideBase = _tokenMeasurements(override);
    return overrideBase.applyCustomSize(override);
  }

  /// Gets the base token measurements for the specified button size.
  ///
  /// Token measurements per size:
  ///
  /// | Size | height | hPadding | iconSize | iconGap |
  /// |------|--------|----------|----------|---------|
  /// | xs   | 32 dp  |  16 dp   |   20 dp  |   8 dp  |
  /// | sm   | 40 dp  |  16 dp   |   20 dp  |   8 dp  |
  /// | md   | 56 dp  |  24 dp   |   24 dp  |   8 dp  |
  /// | lg   | 96 dp  |  48 dp   |   32 dp  |  12 dp  |
  /// | xl   | 136 dp |  64 dp   |   40 dp  |  16 dp  |
  M3EButtonMeasurements _tokenMeasurements(M3EButtonSize size) {
    for (final variant in _measurementsTable.keys) {
      if (variant.name == size.name) return _measurementsTable[variant]!;
    }
    return _measurementsTable[M3EButtonSize.md]!;
  }

  /// Gets the square corner radius for the specified button size.
  double iconButtonWidth(M3EButtonSize size, M3EIconButtonWidth width) =>
      _iconButtonWidthTable[width]?[size] ?? 40;

  TextStyle getLabelStyle(M3EButtonSize size) {
    final tt = _cachedTextTheme ?? Theme.of(context).textTheme;
    final base = switch (size.name) {
      'xs' => tt.labelLarge ?? const TextStyle(fontSize: 14),
      'sm' => tt.labelLarge ?? const TextStyle(fontSize: 14),
      'md' => tt.titleMedium ?? const TextStyle(fontSize: 16),
      'lg' => tt.headlineSmall ?? const TextStyle(fontSize: 24),
      'xl' => tt.headlineLarge ?? const TextStyle(fontSize: 32),
      _ => tt.labelLarge ?? const TextStyle(fontSize: 14),
    };
    return base.copyWith(overflow: TextOverflow.ellipsis);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Split Button Tokens
  // ═══════════════════════════════════════════════════════════════════════

  static final Map<M3EButtonSize, double> _splitButtonHeight =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 32.0,
        M3EButtonSize.sm: 40.0,
        M3EButtonSize.md: 56.0,
        M3EButtonSize.lg: 96.0,
        M3EButtonSize.xl: 136.0,
      });

  static final Map<M3EButtonSize, double> _splitInnerCornerRadius =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 4.0,
        M3EButtonSize.sm: 4.0,
        M3EButtonSize.md: 4.0,
        M3EButtonSize.lg: 8.0,
        M3EButtonSize.xl: 12.0,
      });

  static final Map<M3EButtonSize, double> _splitHoveredInnerCornerRadius =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 8.0,
        M3EButtonSize.sm: 12.0,
        M3EButtonSize.md: 12.0,
        M3EButtonSize.lg: 20.0,
        M3EButtonSize.xl: 20.0,
      });

  static final Map<M3EButtonSize, double> _splitMenuIconOffset =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: -1.0,
        M3EButtonSize.sm: -1.0,
        M3EButtonSize.md: -2.0,
        M3EButtonSize.lg: -3.0,
        M3EButtonSize.xl: -6.0,
      });

  static final Map<M3EButtonSize, double> _splitLeadingButtonIconSize =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 20.0,
        M3EButtonSize.sm: 20.0,
        M3EButtonSize.md: 24.0,
        M3EButtonSize.lg: 32.0,
        M3EButtonSize.xl: 40.0,
      });

  static final Map<M3EButtonSize, double> _splitTrailingButtonIconSize =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 22.0,
        M3EButtonSize.sm: 22.0,
        M3EButtonSize.md: 26.0,
        M3EButtonSize.lg: 38.0,
        M3EButtonSize.xl: 50.0,
      });

  // Pressed inner corner radius.
  //
  //
  // | Size | innerResting | pressedRadius |
  // |------|--------------|---------------|
  // | xs   |      4       |       8       |
  // | sm   |      4       |      12       |
  // | md   |      4       |      12       |
  // | lg   |      8       |      20       |
  // | xl   |     12       |      20       |
  static final Map<M3EButtonSize, double> _splitPressedRadius =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 8.0,
        M3EButtonSize.sm: 12.0,
        M3EButtonSize.md: 12.0,
        M3EButtonSize.lg: 20.0,
        M3EButtonSize.xl: 20.0,
      });

  static final Map<M3EButtonSize, double> _splitLeadingButtonLeadingSpace =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 12.0,
        M3EButtonSize.sm: 16.0,
        M3EButtonSize.md: 24.0,
        M3EButtonSize.lg: 48.0,
        M3EButtonSize.xl: 64.0,
      });

  static final Map<M3EButtonSize, double> _splitIconLabelGap =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 4.0,
        M3EButtonSize.sm: 8.0,
        M3EButtonSize.md: 8.0,
        M3EButtonSize.lg: 12.0,
        M3EButtonSize.xl: 16.0,
      });

  static final Map<M3EButtonSize, double> _splitLabelRightPadding =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 10.0,
        M3EButtonSize.sm: 12.0,
        M3EButtonSize.md: 24.0,
        M3EButtonSize.lg: 48.0,
        M3EButtonSize.xl: 64.0,
      });

  static final Map<M3EButtonSize, double> _splitTrailingButtonPadding =
      Map<M3EButtonSize, double>.unmodifiable({
        M3EButtonSize.xs: 13.0,
        M3EButtonSize.sm: 13.0,
        M3EButtonSize.md: 15.0,
        M3EButtonSize.lg: 29.0,
        M3EButtonSize.xl: 43.0,
      });

  /// Split button total height (same as standard button height).
  double splitHeight(M3EButtonSize size) => _splitButtonHeight[size] ?? 56.0;

  /// Inner corner radius for both segments (resting state).
  double splitInnerCornerRadius(M3EButtonSize size) =>
      _splitInnerCornerRadius[size] ?? 4.0;

  /// Inner corner radius for hovered segments.
  double splitHoveredInnerCornerRadius(M3EButtonSize size) =>
      _splitHoveredInnerCornerRadius[size] ?? 12.0;

  /// Menu chevron optical offset (negative = shift left) for unselected state.
  double splitMenuIconOffset(M3EButtonSize size) =>
      _splitMenuIconOffset[size] ?? -2.0;

  /// Icon size for both segments.
  double splitLeadingIconSize(M3EButtonSize size) =>
      _splitLeadingButtonIconSize[size] ?? 24.0;

  /// Inner corner radius when a segment is pressed.
  double splitPressedRadius(M3EButtonSize size) =>
      _splitPressedRadius[size] ?? 12.0;

  /// Gap between icon and label.
  double splitIconLabelGap(M3EButtonSize size) =>
      _splitIconLabelGap[size] ?? 8.0;

  /// Symmetrical padding when trailing is selected.
  double splitTrailingButtonPadding(M3EButtonSize size) =>
      _splitTrailingButtonPadding[size] ?? 13.0;

  /// Minimum touch target height for each segment.
  double get splitMinTapTarget => 48.0;

  /// Gap between leading and trailing segments.
  double get splitInnerGap => 2.0;

  /// Chevron rotation turns when menu is open (180 degrees).
  double get splitChevronOpenTurns => 0.5;

  /// Compose-aligned token: leading segment start space.
  double splitLeadingButtonLeadingSpace(M3EButtonSize size) =>
      _splitLeadingButtonLeadingSpace[size] ?? 24.0;

  /// Compose-aligned token: leading segment end space.
  double splitLeadingButtonTrailingSpace(M3EButtonSize size) =>
      _splitLabelRightPadding[size] ?? 24.0;

  /// Compose-aligned token: trailing button icon size.
  double splitTrailingButtonIconSize(M3EButtonSize size) =>
      _splitTrailingButtonIconSize[size] ?? 22.0;

  /// Compose-aligned token: selected trailing inner corner percent.
  double get splitTrailingInnerSelectedCornerPercent => 50.0;
}
