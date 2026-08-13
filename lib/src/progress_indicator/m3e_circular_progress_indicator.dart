// ignore_for_file: unused_element_parameter

import 'dart:math' as math;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m3e_widgets/src/shapes/polygon/shapes.dart';

class _Defaults {
  static const defaultWavySize = 48.0;
  static const defaultSize = 40.0;
  static const minSize = 24.0;
  static const maxSize = 240.0;

  /// This value is for default size, it is scaled by default for bigger size
  static const defaultThickness = 4.0;

  /// This value is for default size, it is scaled by default for bigger size
  static const defaultGapSize = 4.0;

  /// This value is for default size, it is scaled by default for bigger size
  static const defaultWavelength = 15.0;

  static double Function(double progress) defaultAmplitude = (progress) {
    // Sets the amplitude to the max on 10%, and back to zero on 95% of the progress.
    if (progress <= 0.1 || progress >= 0.95) {
      return 0;
    } else {
      return 1;
    }
  };
  static const amplitudeAnimationDuration = Duration(milliseconds: 500);
  static const amplitudeAnimationIncreaseCurve = Easing.standard;
  static const amplitudeAnimationDecreaseCurve = Easing.emphasizedAccelerate;

  static const minCircularVertexCount =
      5; // from CircularWavyProgressModifiers.kt

  static const progresssAnimationDuration = Duration(milliseconds: 500);
  static const indeterminateAnimationDuration = Duration(milliseconds: 6000);
}

enum M3EProgressIndicatorShape { flat, wavy }

class M3ECircularProgressIndicator extends StatelessWidget {
  const M3ECircularProgressIndicator({
    super.key,
    this.value,
    this.activeColor,
    this.trackColor,
    this.gapSize,
    this.thickness,
    this.wavelength,
    this.waveSpeed,
    this.amplitude,
    this.size,
    this.shape = .wavy,
    this.animateProgres = true,
  }) : assert(
         (size ?? 24) >= _Defaults.minSize && (size ?? 24) <= _Defaults.maxSize,
       );

  /// The value of the progress (0 -> 1)
  final double? value;

  /// This function should return 0 or 1 based on the current progress, this will animate the amplitude of the wave
  ///
  /// For [M3EProgressIndicatorShape.flat] it is by default always 0
  final double Function(double progress)? amplitude;

  /// The thickness of the progress and track paths
  ///
  /// Default: `4.0` for default size
  final double? thickness;

  /// The wavelength of the waves - from this the number of points in the star is computed
  ///
  /// Default: `15.0` for default size
  final double? wavelength;

  /// By default the same as [wavelength] -> it takes 1 second to travel 1 wave
  ///
  /// Default: `15.0` for default size
  final double? waveSpeed;
  final double? size;

  /// The gap between progress and track paths
  ///
  /// Default: `4.0` for default size
  final double? gapSize;

  /// The color of the progress path
  final Color? activeColor;

  /// The color of the track path
  final Color? trackColor;

  /// Whether the progress should animate = won't jump the values but animate between them
  final bool animateProgres;
  final M3EProgressIndicatorShape shape;

  @override
  Widget build(BuildContext context) {
    final isWavy = shape == .wavy;
    final defaultSize = isWavy
        ? _Defaults.defaultWavySize
        : _Defaults.defaultSize;

    final finalSize = size ?? defaultSize;
    final finalAmplitude =
        amplitude ?? (isWavy ? _Defaults.defaultAmplitude : (_) => 0);
    final finalWavelength =
        wavelength ?? finalSize * (_Defaults.defaultWavelength / defaultSize);
    final finalWaveSpeed = waveSpeed ?? finalWavelength;
    final finalThickness =
        thickness ?? finalSize * (_Defaults.defaultThickness / defaultSize);
    final finalGapSize =
        gapSize ?? finalSize * (_Defaults.defaultGapSize / defaultSize);

    if (value != null) {
      return _CircularProgressIndicator(
        animateProgres: animateProgres,
        value: value!,
        wavelength: finalWavelength,
        waveSpeed: finalWaveSpeed,
        trackColor: trackColor,
        thickness: finalThickness,
        size: finalSize,
        gapSize: finalGapSize,
        amplitude: finalAmplitude,
        activeColor: activeColor,
      );
    } else {
      return _CircularLoadingIndicator(
        wavelength: finalWavelength,
        waveSpeed: finalWaveSpeed,
        trackColor: trackColor,
        thickness: finalThickness,
        size: finalSize,
        gapSize: finalGapSize,
        amplitude: finalAmplitude,
        activeColor: activeColor,
      );
    }
  }
}

/// Indeterminate loading indicator that can display progress as a wave
class _CircularLoadingIndicator extends StatefulWidget {
  const _CircularLoadingIndicator({
    super.key,
    required this.activeColor,
    required this.trackColor,
    required this.gapSize,
    required this.thickness,
    required this.wavelength,
    required this.waveSpeed,
    required this.amplitude,
    required this.size,
  });

  final double Function(double progress) amplitude;
  final double thickness;
  final double wavelength;
  final double waveSpeed;
  final double size;
  final double gapSize;
  final Color? activeColor;
  final Color? trackColor;

  @override
  State<_CircularLoadingIndicator> createState() =>
      _CircularLoadingIndicatorState();
}

class _CircularLoadingIndicatorState extends State<_CircularLoadingIndicator>
    with TickerProviderStateMixin {
  late final _globalController = AnimationController(
    vsync: this,
    duration: _Defaults.indeterminateAnimationDuration,
  );

  // the jetpack compose implementation uses some deccelerate curve, but it doesnt look right here
  late final _additionalAnimation = TweenSequence<double>([
    TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0.25), weight: 300),
    TweenSequenceItem(tween: ConstantTween(0.25), weight: 1200),
    TweenSequenceItem(tween: Tween<double>(begin: 0.25, end: 0.5), weight: 300),
    TweenSequenceItem(tween: ConstantTween(0.5), weight: 1200),
    TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 0.75), weight: 300),
    TweenSequenceItem(tween: ConstantTween(0.75), weight: 1200),
    TweenSequenceItem(tween: Tween<double>(begin: 0.75, end: 1), weight: 300),
    TweenSequenceItem(tween: ConstantTween(1), weight: 1200),
  ]).animate(_globalController);

  final sweepCurve = Easing.standard;
  final sweepMin = 0.1;
  final sweepMax = 0.87;
  late final _progressSweepAnimation = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: sweepMin, end: sweepMax),
      weight: 3000,
    ),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: sweepMax,
        end: sweepMin,
      ).chain(CurveTween(curve: sweepCurve)),
      weight: 3000,
    ),
  ]).animate(_globalController);

  @override
  void initState() {
    super.initState();
    _globalController.repeat();
  }

  @override
  void dispose() {
    _globalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _globalController,
      builder: (context, _) {
        return Transform.rotate(
          angle:
              (0.25 +
                  _globalController.value * 3 +
                  _additionalAnimation.value) *
              2 *
              pi,
          child: _CircularProgressIndicator(
            value: _progressSweepAnimation.value,
            gapSize: widget.gapSize,
            amplitude: widget.amplitude,
            wavelength: widget.wavelength,
            thickness: widget.thickness,
            size: widget.size,
            waveSpeed: widget.waveSpeed,
            animateProgres: false,
            activeColor:
                widget.activeColor ?? Theme.of(context).colorScheme.primary,
            trackColor:
                widget.trackColor ??
                Theme.of(context).colorScheme.secondaryContainer,
          ),
        );
      },
    );
  }
}

class _CircularProgressIndicator extends StatefulWidget {
  const _CircularProgressIndicator({
    super.key,
    required this.value,
    required this.activeColor,
    required this.trackColor,
    required this.gapSize,
    required this.thickness,
    required this.wavelength,
    required this.waveSpeed,
    required this.amplitude,
    required this.size,
    required this.animateProgres,
  });

  final double value;
  final double Function(double progress) amplitude;
  final double thickness;
  final double wavelength;
  final double waveSpeed;
  final double size;
  final double gapSize;
  final Color? activeColor;
  final Color? trackColor;
  final bool animateProgres;

  @override
  State<_CircularProgressIndicator> createState() =>
      _CircularProgressIndicatorState();
}

class _CircularProgressIndicatorState extends State<_CircularProgressIndicator>
    with TickerProviderStateMixin {
  /// The faze controller controlls how long it takes to rotate by one wave
  AnimationController? _fazeController;
  late final _amplitudeController = AnimationController(
    value: widget.amplitude(widget.value),
    vsync: this,
    duration: _Defaults.amplitudeAnimationDuration,
  );
  late final _progressController = AnimationController(
    vsync: this,
    value: widget.value,
    duration: _Defaults.progresssAnimationDuration,
  );

  late double oldProgress = widget.value;

  @override
  void initState() {
    super.initState();
    updateFazeController();
  }

  void updateFazeController() {
    // * 2 because we have two waves - (repeatPath: true)
    late var fazeDuration = ((widget.wavelength / widget.waveSpeed) * 1000 * 2)
        .clamp(50, double.infinity)
        .round();

    _fazeController?.dispose();
    _fazeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: fazeDuration),
    );

    _fazeController?.repeat();
  }

  @override
  void didUpdateWidget(covariant _CircularProgressIndicator oldWidget) {
    if (oldWidget.waveSpeed != widget.waveSpeed ||
        oldWidget.wavelength != widget.wavelength) {
      updateFazeController();
    }

    if (oldWidget.amplitude != widget.amplitude) {
      updateAmplitude();
    }
    if (oldWidget.value != widget.value) {
      updateProgress();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _fazeController?.dispose();
    _progressController.dispose();
    _amplitudeController.dispose();
    super.dispose();
  }

  void updateProgress() {
    if (widget.animateProgres) {
      _progressController.animateTo(widget.value);
    } else {
      _progressController.value = widget.value;
    }
  }

  void updateAmplitude() {
    if (widget.amplitude(_progressController.value) == 0) {
      if (_amplitudeController.status != .reverse &&
          _amplitudeController.value != 0) {
        _amplitudeController.animateBack(
          0,
          curve: _Defaults.amplitudeAnimationDecreaseCurve,
        );
      }
    } else {
      if (_amplitudeController.status != .forward &&
          _amplitudeController.value != 1) {
        _amplitudeController.animateTo(
          1,
          curve: _Defaults.amplitudeAnimationIncreaseCurve,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _fazeController,
        _progressController,
        _amplitudeController,
      ]),
      builder: (context, _) {
        if (oldProgress != _progressController.value) {
          updateAmplitude();
        }
        oldProgress = _progressController.value;

        return CustomPaint(
          // TODO overflows from this square, check gap size
          size: Size.square(widget.size),
          painter: _WavyCircularProgressIndicatorPainter(
            gapSize: widget.gapSize,
            amplitude: _amplitudeController.value,
            wavelength: widget.wavelength,
            strokeWidth: widget.thickness,
            activeColor:
                widget.activeColor ?? Theme.of(context).colorScheme.primary,
            trackColor:
                widget.trackColor ??
                Theme.of(context).colorScheme.secondaryContainer,
            faze: _fazeController!.value,
            progress: _progressController.value,
          ),
        );
      },
    );
  }
}

class _WavyCircularProgressIndicatorPainter extends CustomPainter {
  final Color activeColor;
  final Color trackColor;
  final double strokeWidth;
  final double amplitude;
  final double wavelength;
  final double progress;
  final double faze;
  final double gapSize;

  _WavyCircularProgressIndicatorPainter({
    required this.amplitude,
    required this.wavelength,
    required this.activeColor,
    required this.trackColor,
    required this.strokeWidth,
    required this.progress,
    required this.faze,
    required this.gapSize,
  });

  Float64List _getTransform(
    double scale,
    double angleRadians,
    double xCenter,
    double yCenter,
  ) {
    final double cosA = math.cos(angleRadians);
    final double sinA = math.sin(angleRadians);

    return Float64List.fromList([
      // Column 0
      scale * cosA,
      scale * sinA,
      0.0,
      0.0,

      // Column 1
      scale * -sinA,
      scale * cosA,
      0.0,
      0.0,

      // Column 2
      0.0,
      0.0,
      1.0,
      0.0,

      // Column 3 (Translation)
      xCenter, // Moves it to your desired X
      yCenter, // Moves it to your desired Y
      0.0,
      1.0,
    ]);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final yCenter = size.height / 2;
    final xCenter = size.width / 2;

    final r = size.width / 2 - strokeWidth / 2;
    final numVertices = max(
      _Defaults.minCircularVertexCount,
      (2 * pi * r / wavelength).round(),
    );

    final starPolygon =
        RoundedPolygon.star(
          numVerticesPerRadius: numVertices,
          innerRadius: 0.75,
          rounding: CornerRounding(radius: 0.35, smoothing: 0.4),
          innerRounding: CornerRounding(radius: 0.5),
        ).transformed(
          // make the star bigger - the size of [size]
          (x, y) => (x / 0.9, y / 0.9),
        );

    final circlePolygon = RoundedPolygon.circle(numVertices: numVertices);

    final activePath = Morph(circlePolygon, starPolygon).toPath(
      progress: amplitude,
      // if startAngle is left at 0, it rotates it (maybe flutter bug?)
      startAngle: 360,
      repeatPath: true,
    );

    final activePathMetrics = activePath
        .transform(
          _getTransform(
            r,
            (-pi / 2) - faze * (1 / numVertices * 2 * pi) * 2,
            xCenter,
            yCenter,
          ),
        )
        .computeMetrics();

    final cutActivePath = Path();
    for (PathMetric metric in activePathMetrics) {
      final double start = metric.length * faze / numVertices;
      final double end = metric.length * (progress / 2 + faze / numVertices);

      // Extract that specific portion and add it to our new path
      cutActivePath.addPath(metric.extractPath(start, end), Offset.zero);
    }

    // TRACK PATH

    final trackPath = circlePolygon.toPath();
    final trackPathMetrics = trackPath
        .transform(_getTransform(r, pi / -2, xCenter, yCenter))
        .computeMetrics();

    final cutTrackPath = Path();
    // At the start, show the full path, ignore any gaps
    final gapSizeRatio = clampDouble(progress * 20, 0, 1);
    final finalGap =
        (strokeWidth / 2 + gapSize * 1.5) *
        gapSizeRatio; // multiply gap by 1.5 to look like native
    for (PathMetric metric in trackPathMetrics) {
      final double start = metric.length * progress + finalGap;
      final double end = metric.length - finalGap;

      // Extract that specific portion and add it to our new path
      cutTrackPath.addPath(metric.extractPath(start, end), Offset.zero);
    }

    canvas.drawPath(cutTrackPath, trackPaint);
    if (progress != 0) {
      canvas.drawPath(cutActivePath, activePaint);
    }
  }

  @override
  bool shouldRepaint(_WavyCircularProgressIndicatorPainter oldDelegate) {
    if (oldDelegate.faze != faze) return true;
    if (oldDelegate.progress != progress) return true;
    if (oldDelegate.amplitude != amplitude) return true;
    if (oldDelegate.wavelength != wavelength) return true;
    if (oldDelegate.gapSize != gapSize) return true;
    if (oldDelegate.activeColor != activeColor) return true;
    if (oldDelegate.trackColor != trackColor) return true;
    if (oldDelegate.strokeWidth != strokeWidth) return true;

    return false;
  }
}
