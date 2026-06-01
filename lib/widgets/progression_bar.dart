import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:paek_game_tool_flutter/l10n/app_localizations.dart';

enum ProgressionBarType { pkmnLevel, trainerLevel }

class ProgressionBar extends StatefulWidget {
  final ProgressionBarType type;
  final int barLevel;
  final int maxValue;
  final int currentValue;
  final int dividers;
  final String innerLabel;
  final ValueChanged<int>? onLevelChange;

  const ProgressionBar({
    super.key,
    this.type = ProgressionBarType.pkmnLevel,
    this.barLevel = 0,
    this.maxValue = 100,
    this.currentValue = 0,
    this.dividers = 0,
    this.innerLabel = '',
    this.onLevelChange,
  });

  @override
  State<ProgressionBar> createState() => _ProgressionBarState();
}

class _ProgressionBarState extends State<ProgressionBar>
    with TickerProviderStateMixin {
  late int _currentLevel;
  late int _currentValue;

  bool _isLevelingUp = false;

  late AnimationController _maskController;
  late AnimationController _phase1BlurController;
  late AnimationController _phase2FilterController;

  Timer? _levelUpTimer;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.barLevel;
    _currentValue = widget.currentValue;

    // 1.0 means fully masked (empty bar), 0.0 means fully revealed (full bar)
    _maskController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      value: 1.0,
    );

    _phase1BlurController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _phase2FilterController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Initial animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _animateToValue(_currentValue);
      }
    });
  }

  @override
  void didUpdateWidget(ProgressionBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentValue != widget.currentValue) {
      if (!_isLevelingUp) {
        _currentValue = widget.currentValue;
        _animateToValue(_currentValue);
      }
    }
    if (oldWidget.barLevel != widget.barLevel && !_isLevelingUp) {
      _currentLevel = widget.barLevel;
    }
  }

  @override
  void dispose() {
    _levelUpTimer?.cancel();
    _maskController.dispose();
    _phase1BlurController.dispose();
    _phase2FilterController.dispose();
    super.dispose();
  }

  void _animateToValue(int value) {
    _levelUpTimer?.cancel();

    double targetFactor = 1.0 - (value / widget.maxValue).clamp(0.0, 1.0);
    _maskController.animateTo(targetFactor, curve: Curves.easeInOut);

    if (value >= widget.maxValue) {
      _scheduleLevelUp();
    }
  }

  void _scheduleLevelUp() {
    _levelUpTimer?.cancel();
    _levelUpTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _triggerLevelUpSequence();
      }
    });
  }

  Future<void> _triggerLevelUpSequence() async {
    _isLevelingUp = true;

    // Transition: full => beforeIncrease
    // Mask resets to 100% (empty) over 2s
    _maskController.animateTo(
      1.0,
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
    // Container blur to 0.5px, brightness to 1.1 over 1s
    _phase1BlurController.forward(from: 0.0);

    // Wait for the longest animation (mask takes 2s)
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Update internal state and notify parent BEFORE starting phase 2
    setState(() {
      _currentValue = 0;
      _currentLevel += 1;
    });
    widget.onLevelChange?.call(_currentLevel);

    // Transition: beforeIncrease => afterIncrease
    _phase1BlurController.reset();
    _phase2FilterController.forward(from: 0.0);

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    _isLevelingUp = false;
    _phase2FilterController.reset();

    // If parent provided a new value while we were animating, animate to it
    if (_currentValue != widget.currentValue) {
      _currentValue = widget.currentValue;
      _animateToValue(_currentValue);
    }
  }

  static ColorFilter _brightnessFilter(double brightness) {
    return ColorFilter.matrix(<double>[
      brightness,
      0,
      0,
      0,
      0,
      0,
      brightness,
      0,
      0,
      0,
      0,
      0,
      brightness,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _phase1BlurController,
        _phase2FilterController,
      ]),
      builder: (context, child) {
        double blurX = 0;
        double brightness = 1.0;

        if (_phase1BlurController.isAnimating ||
            _phase1BlurController.isCompleted) {
          blurX = 0.5 * _phase1BlurController.value;
          brightness = 1.0 + (0.1 * _phase1BlurController.value);
        } else if (_phase2FilterController.isAnimating) {
          blurX = 1.0 * (1.0 - _phase2FilterController.value); // 1.0 -> 0.0
          brightness =
              1.0 + (0.1 * (1.0 - _phase2FilterController.value)); // 1.1 -> 1.0
        }

        Widget result = child!;

        if (blurX > 0) {
          result = ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurX),
            child: result,
          );
        }
        if (brightness != 1.0) {
          result = ColorFiltered(
            colorFilter: _brightnessFilter(brightness),
            child: result,
          );
        }
        return result;
      },
      child: _buildMainContainer(),
    );
  }

  Widget _buildMainContainer() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLevelDisplay(),
          const SizedBox(width: 5),
          Expanded(child: _buildProgressBar()),
        ],
      ),
    );
  }

  Widget _buildLevelDisplay() {
    return AnimatedBuilder(
      animation: _phase2FilterController,
      builder: (context, child) {
        double badgeBrightness = 1.0;
        if (_phase2FilterController.isAnimating) {
          badgeBrightness =
              1.0 + (1.0 * (1.0 - _phase2FilterController.value)); // 2.0 -> 1.0
        }

        Widget badge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF508DFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            widget.type == ProgressionBarType.pkmnLevel
                ? AppLocalizations.of(context)!.lvl(_currentLevel)
                : AppLocalizations.of(context)!.trainerLevel(_currentLevel),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

        if (badgeBrightness != 1.0) {
          badge = ColorFiltered(
            colorFilter: _brightnessFilter(badgeBrightness),
            child: badge,
          );
        }
        return badge;
      },
    );
  }

  Widget _buildProgressBar() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFFD7F5FF), Color(0xFFB9FFB9), Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _maskController,
          builder: (context, child) {
            return Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: _maskController.value,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Markers
        if (widget.dividers > 0)
          Row(
            children: List.generate(
              widget.dividers,
              (index) => Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: index < widget.dividers - 1
                        ? const Border(
                            right: BorderSide(
                              color: Color(0xFF508DFF),
                              width: 1,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),

        // Inner Label
        if (widget.innerLabel.isNotEmpty)
          Center(
            child: Text(
              widget.innerLabel,
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF508DFF), width: 2),
          ),
        ),
      ],
    );
  }
}
