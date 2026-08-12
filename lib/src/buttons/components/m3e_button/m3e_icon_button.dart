import 'package:flutter/material.dart';
import 'package:m3e_widgets/m3e_widgets.dart';

// just copied and edited from m3e_toggle_button.dart

const bool _kDefaultEnableFeedback = true;

class M3EIconButton extends StatelessWidget {
  const M3EIconButton({
    this.width = .standard,
    super.key,
    required this.onPressed,
    required this.icon,
    this.style = M3EButtonStyle.standard,
    this.size = M3EButtonSize.sm,
    this.shape = M3EButtonShape.round,
    this.enabled = true,
    this.statesController,
    this.decoration,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.tooltip,
    this.mouseCursor = SystemMouseCursors.click,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
  }) : assert(
         style != M3EButtonStyle.text,
         'M3EIconButton does not support M3EButtonStyle.text.',
       ),
       assert(
         style != M3EButtonStyle.elevated,
         'M3EIconButton does not support M3EButtonStyle.elevated.',
       );

  /// Callback invoked when the button is pressed. Null disables the button.
  final VoidCallback? onPressed;

  /// The Icon button
  final Widget icon;

  /// Visual style of the button.
  ///
  /// See [M3EIconButtonStyle] for available styles (filled, outlined, tonal, etc.).
  final M3EButtonStyle style;

  /// Size variant of the button.
  ///
  /// See [M3EButtonSize] for available sizes (xs, sm, md, lg, xl).
  final M3EButtonSize size;

  /// Width variant of the toggle button.
  ///
  /// See [M3EIconButtonWidth] for available sizes (narrow, standard, wide).
  final M3EIconButtonWidth width;

  /// Corner radius strategy for the button.
  ///
  /// See [M3EButtonShape] for available shapes (round, square).
  final M3EButtonShape shape;

  /// Whether the button is enabled. Defaults to true.
  final bool enabled;

  /// Optional controller for managing widget states externally.
  ///
  /// Allows programmatic control of pressed, hovered, focused states.
  final WidgetStatesController? statesController;

  /// Optional decoration that bundles styling properties together.
  ///
  /// When provided, decoration values take precedence over individual flat
  /// parameters (e.g. [backgroundColor], [foregroundColor], etc.).
  final M3EButtonDecoration? decoration;

  /// External focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Whether this button should focus itself on mount.
  final bool autofocus;

  /// Callback fired when focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Accessibility label. Merged on top of the button's own semantics.
  final String? semanticLabel;

  /// Tooltip text.
  final String? tooltip;

  /// Custom mouse cursor.
  final MouseCursor mouseCursor;

  /// Callback invoked when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// Callback invoked when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Whether to show a ripple/splash effect and haptic feedback on press.
  ///
  /// Defaults to true.
  final bool enableFeedback;

  /// The splash factory for the ink ripple effect.
  ///
  /// See [InteractiveInkFeatureFactory] for available options.
  final InteractiveInkFeatureFactory? splashFactory;

  // ── Decoration property helpers ───────────────────────────────────────────

  WidgetStateProperty<Color?>? get decorationBackgroundColor =>
      decoration?.backgroundColor;
  WidgetStateProperty<Color?>? get decorationForegroundColor =>
      decoration?.foregroundColor;
  WidgetStateProperty<BorderSide?>? get decorationBorderSide =>
      decoration?.side;
  M3EMotion? get decorationMotion => decoration?.motion;
  M3EHapticFeedback get decorationHaptic =>
      decoration?.haptic ?? M3EHapticFeedback.none;
  WidgetStateProperty<MouseCursor?>? get decorationMouseCursor =>
      decoration?.mouseCursor;
  double? get decorationPressedRadius => decoration?.pressedRadius;
  double? get decorationBorderRadius => decoration?.borderRadius;
  WidgetStateProperty<Color?>? get decorationOverlayColor =>
      decoration?.overlayColor;
  WidgetStateProperty<Color?>? get decorationSurfaceTintColor =>
      decoration?.surfaceTintColor;

  @override
  Widget build(BuildContext context) {
    final tokens = M3EButtonTokensAdapter(context);
    final measurements = tokens.measurements(size);
    final dec = decoration ?? M3EButtonDecoration();

    return M3EButton(
      shape: shape,
      onPressed: onPressed,
      size: size,
      semanticLabel: semanticLabel,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      mouseCursor: mouseCursor,
      key: key,
      focusNode: focusNode,
      enabled: enabled,
      enableFeedback: enableFeedback,
      autofocus: autofocus,
      decoration: dec.copyWith(
        alignment: .center,
        padding: EdgeInsets.all(0),
        maximumSize: Size(
          tokens.iconButtonWidth(size, width),
          measurements.height,
        ),
        minimumSize: Size(
          tokens.iconButtonWidth(size, width),
          measurements.height,
        ),
      ),
      tooltip: tooltip,
      style: style,
      statesController: statesController,
      splashFactory: splashFactory,
      child: RepaintBoundary(
        child: IconTheme.merge(
          data: IconThemeData(size: measurements.iconSize),
          child: icon,
        ),
      ),
    );
  }
}

/// A filled-style M3EIconButton.
class M3EFilledIconButton extends M3EIconButton {
  const M3EFilledIconButton({
    super.key,
    required super.onPressed,
    required super.icon,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
    super.width,
  }) : super(style: M3EButtonStyle.filled);

  const M3EFilledIconButton.tonal({
    super.key,
    required super.onPressed,
    required super.icon,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
    super.width,
  }) : super(style: M3EButtonStyle.tonal);
}

/// A outlined-style M3EIconButton.
class M3EOutlinedIconButton extends M3EIconButton {
  const M3EOutlinedIconButton({
    super.key,
    required super.onPressed,
    required super.icon,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
    super.width,
  }) : super(style: M3EButtonStyle.outlined);
}
