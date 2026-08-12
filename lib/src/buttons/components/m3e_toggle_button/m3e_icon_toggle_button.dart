import 'package:flutter/material.dart';
import 'package:m3e_widgets/m3e_widgets.dart';

// just copied and edited from m3e_toggle_button.dart

const bool _kDefaultEnableFeedback = true;

class M3EToggleIconButton extends StatelessWidget {
  const M3EToggleIconButton({
    this.width = .standard,
    super.key,
    this.onCheckedChange,
    required this.icon,
    this.checkedIcon,
    this.checked,
    this.style = M3EButtonStyle.standard,
    this.size = M3EButtonSize.sm,
    this.enabled = true,
    this.isGroupConnected = false,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
    this.decoration,
    this.mouseCursor,
    this.statesController,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.tooltip,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
    this.isStandalone = true,
  }) : assert(
         style != M3EButtonStyle.text,
         'M3EToggleIconButton does not support M3EButtonStyle.text.',
       ),
       assert(
         style != M3EButtonStyle.elevated,
         'M3EToggleIconButton does not support M3EButtonStyle.elevated.',
       );

  /// Will be false when in a group, this ensures that the button will have the minimum width
  final bool isStandalone;

  /// Icon displayed in the unchecked state.
  final Widget icon;

  /// Icon displayed in the checked state. Falls back to [icon] when null.
  final Widget? checkedIcon;

  /// Current checked state. Null for internal state management.
  final bool? checked;

  /// Callback fired when the checked state changes.
  final ValueChanged<bool>? onCheckedChange;

  /// Visual style of the toggle button.
  ///
  /// See [M3EButtonStyle] for available styles (filled, outlined, tonal, etc.).
  final M3EButtonStyle style;

  /// Size variant of the toggle button.
  ///
  /// See [M3EButtonSize] for available sizes (xs, sm, md, lg, xl).
  final M3EButtonSize size;

  /// Width variant of the toggle button.
  ///
  /// See [M3EIconButtonWidth] for available sizes (narrow, standard, wide).
  final M3EIconButtonWidth width;

  /// Whether the toggle button is enabled.
  final bool enabled;

  /// Whether this button is part of a connected button group.
  ///
  /// When true, the button shares its inner corners with adjacent buttons.
  final bool isGroupConnected;

  /// Whether this is the first button in a connected group.
  ///
  /// Controls the outer corner radius on the leading edge.
  final bool isFirstInGroup;

  /// Whether this is the last button in a connected group.
  ///
  /// Controls the outer corner radius on the trailing edge.
  final bool isLastInGroup;

  /// Optional decoration that bundles styling properties together.
  ///
  /// When provided, decoration values take precedence over individual flat
  /// parameters (e.g. [backgroundColor], [foregroundColor], etc.).
  final M3EToggleButtonDecoration? decoration;

  /// Optional mouse cursor to show when hovering over the button.
  final MouseCursor? mouseCursor;

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
  double? get decorationBorderRadius => decoration?.borderRadius;
  double? get decorationCheckedRadius => decoration?.checkedRadius;
  double? get decorationUncheckedRadius => decoration?.uncheckedRadius;
  double? get decorationPressedRadius => decoration?.pressedRadius;
  double? get decorationConnectedInnerRadius =>
      decoration?.connectedInnerRadius;
  WidgetStateProperty<Color?>? get decorationOverlayColor =>
      decoration?.overlayColor;
  WidgetStateProperty<Color?>? get decorationSurfaceTintColor =>
      decoration?.surfaceTintColor;

  /// Optional controller for managing widget states externally.
  ///
  /// Allows programmatic control of pressed, hovered, focused states.
  final WidgetStatesController? statesController;

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

  @override
  Widget build(BuildContext context) {
    final tokens = M3EButtonTokensAdapter(context);
    final dec = decoration ?? M3EToggleButtonDecoration();

    return SizedBox(
      width: tokens.iconButtonWidth(size, width),
      child: M3EToggleButton(
        size: size,
        semanticLabel: semanticLabel,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        mouseCursor: mouseCursor,
        label: null,
        icon: icon,
        key: key,
        isLastInGroup: isLastInGroup,
        isGroupConnected: isGroupConnected,
        isFirstInGroup: isFirstInGroup,
        focusNode: focusNode,
        enabled: enabled,
        enableFeedback: enableFeedback,
        checkedLabel: null,
        autofocus: autofocus,
        checkedIcon: checkedIcon,
        checked: checked,
        decoration: dec.copyWith(padding: EdgeInsets.all(0)),
        tooltip: tooltip,
        style: style,
        statesController: statesController,
        onCheckedChange: onCheckedChange,
        splashFactory: splashFactory,
      ),
    );
  }
}