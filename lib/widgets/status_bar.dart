import 'package:flutter/material.dart';

/// A colour threshold entry used by [StatusBar].
///
/// The bar will be coloured with the [color] belonging to the *lowest* [max]
/// threshold that is still >= the current fill percentage, mirroring the
/// Angular component's behaviour.
class StatusBarColor {
  final double max; // percentage (0–100)
  final Color color;

  const StatusBarColor({required this.max, required this.color});
}

/// A horizontal status bar widget that mirrors the Angular `StatusBarComponent`.
///
/// The fill is shown as a gradient [Container] that transitions from a
/// semi-transparent tint of [barColor] on the left to [barColor] on the right.
/// An animated white mask slides in from the right to reveal the correct fill
/// fraction, producing the same smooth 1 s ease-in-out animation as the
/// Angular `@statusBar` trigger.
///
/// Usage:
/// ```dart
/// StatusBar(
///   label: 'HP',
///   currentValue: 45,
///   maxValue: 100,
///   colors: [
///     StatusBarColor(max: 100, color: Color(0xFF4CAF50)),
///     StatusBarColor(max: 50,  color: Color(0xFFFF9800)),
///     StatusBarColor(max: 25,  color: Color(0xFFF44336)),
///   ],
/// )
/// ```
class StatusBar extends StatefulWidget {
  final String label;
  final double currentValue;
  final double maxValue;

  /// Colour thresholds. The bar adopts the colour of the entry with the
  /// smallest [StatusBarColor.max] that is >= the current fill percentage.
  /// Defaults to a red/orange/green traffic-light scale.
  final List<StatusBarColor> colors;

  const StatusBar({
    super.key,
    this.label = '',
    this.currentValue = 0,
    this.maxValue = 10,
    this.colors = const [
      StatusBarColor(max: 100, color: Color(0xFF80FF84)), // green
      StatusBarColor(max: 60, color: Color(0xFFFFBE5E)), // orange
      StatusBarColor(max: 25, color: Color(0xFFFF9890)), // red
    ],
  });

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _maskAnimation;

  /// Fraction of the bar that is *hidden* (1.0 = fully hidden, 0.0 = fully
  /// visible). Mirroring [ProgressionBar]'s mask approach keeps the gradient
  /// technique consistent across the project.
  double _hiddenFraction = 1.0;

  Color _barColor = const Color(0xFF999999);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _maskAnimation = _controller;

    _barColor = _resolveColor(_fillPercent(widget.currentValue));

    // Animate from fully hidden → correct fill on first frame
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _animateTo(widget.currentValue, animate: true);
    });
  }

  @override
  void didUpdateWidget(StatusBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    final valueChanged = oldWidget.currentValue != widget.currentValue;
    final maxChanged = oldWidget.maxValue != widget.maxValue;

    if (valueChanged || maxChanged) {
      // Snap the start of the animation to the previous fill position so that
      // the mask slides smoothly from where it currently sits.
      final prevPercent = _fillPercent(
        oldWidget.currentValue,
        max: oldWidget.maxValue,
      );
      _hiddenFraction = 1.0 - (prevPercent / 100).clamp(0.0, 1.0);

      _animateTo(widget.currentValue, animate: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _fillPercent(double value, {double? max}) {
    final m = max ?? widget.maxValue;
    if (m <= 0) return 0;
    return (value / m * 100).clamp(0.0, 100.0);
  }

  Color _resolveColor(double percent) {
    if (widget.colors.isEmpty) return const Color(0xFF999999);
    final eligible = widget.colors.where((e) => e.max >= percent).toList()
      ..sort((a, b) => a.max.compareTo(b.max));
    return eligible.isNotEmpty
        ? eligible.first.color
        : widget.colors.last.color;
  }

  void _animateTo(double value, {bool animate = true}) {
    final percent = _fillPercent(value);
    final targetHidden = 1.0 - (percent / 100).clamp(0.0, 1.0);

    setState(() => _barColor = _resolveColor(percent));

    if (!animate) {
      _controller.stop();
      _hiddenFraction = targetHidden;
      return;
    }

    // Drive the mask from its current logical position to the new target.
    _maskAnimation = Tween<double>(
      begin: _hiddenFraction,
      end: targetHidden,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward(from: 0.0).whenComplete(() {
      if (mounted) setState(() => _hiddenFraction = targetHidden);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.label.isNotEmpty) ...[
            _buildLabel(),
            const SizedBox(width: 5),
          ],
          Expanded(child: _buildBar()),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF508DFF),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        widget.label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildBar() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Gradient fill ────────────────────────────────────────────────────
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [_barColor.withValues(alpha: 0.45), _barColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            );
          },
        ),

        // ── White mask (slides in from the right to hide the unfilled part) ──
        AnimatedBuilder(
          animation: _maskAnimation,
          builder: (context, _) {
            final fraction = _maskAnimation.value.clamp(0.0, 1.0);
            return Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: fraction,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // ── Inner label (value / max) ─────────────────────────────────────────
        Center(
          child: Text(
            '${_formatValue(widget.currentValue)} / ${_formatValue(widget.maxValue)}',
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // ── Border ───────────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF508DFF), width: 2),
          ),
        ),
      ],
    );
  }

  /// Formats the value: shows it as an integer when it has no fractional part.
  String _formatValue(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
}
