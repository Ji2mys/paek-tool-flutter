import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// A widget that displays a Pokémon icon from the sprite sheet.
///
/// The sprite sheet is a grid of 64×64 px icons, 12 columns wide.
/// [iconIdx] is the flat index of the Pokémon in that grid (0-based).
///
/// Optional visual states:
///   - [level]     → shows a small level badge below-right of the icon.
///   - [hasFainted] → renders the icon in greyscale.
///   - [canEvolve]  → shows a spinning blue dotted border around the icon.
///   - [size]       → scales the whole widget (default 64 logical pixels).
class PokemonIcon extends StatefulWidget {
  const PokemonIcon({
    super.key,
    required this.iconIdx,
    this.level,
    this.canEvolve = false,
    this.hasFainted = false,
    this.size = 64.0,
  });

  final int iconIdx;
  final int? level;
  final bool canEvolve;
  final bool hasFainted;
  final double size;

  @override
  State<PokemonIcon> createState() => _PokemonIconState();
}

class _PokemonIconState extends State<PokemonIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

  // Each cell in the sprite sheet is exactly 64 px.
  static const double _cellSize = 64.0;
  static const int _columns = 12;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  /// Scale factor relative to the native 64-px cell size.
  double get _scale => widget.size / _cellSize;

  /// Pixel offset of the desired icon inside the sprite sheet.
  Offset get _spriteOffset {
    final col = widget.iconIdx % _columns;
    final row = widget.iconIdx ~/ _columns;
    return Offset(col * _cellSize, row * _cellSize);
  }

  @override
  Widget build(BuildContext context) {
    // Extra vertical space when a level badge is shown.
    final bool hasLevel = widget.level != null && widget.level! > 0;
    final double badgeOverhang = hasLevel ? 12.0 : 0.0;

    return SizedBox(
      width: widget.size,
      height: widget.size + badgeOverhang,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // ── Background circle (faint poke-ball watermark) ──────────────
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/poke.webp',
              width: widget.size,
              height: widget.size,
              fit: BoxFit.none,
              // Show only the first cell as a generic "back" placeholder.
              alignment: Alignment.topLeft,
            ),
          ),

          // ── Sprite sheet clip (the actual icon) ─────────────────────────
          Transform.translate(
            // Nudge up by 5 px (scaled) to match the CSS translateY(-5px).
            offset: Offset(0, -5 * _scale),
            child: Stack(
              children: [
                Transform.translate(
                  offset: Offset(2, 2 * _scale),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Opacity(opacity: 0.5, child: _buildIconFront()),
                  ),
                ),
                _buildIconFront(),
              ],
            ),
          ),

          // ── Can-evolve spinning border ──────────────────────────────────
          if (widget.canEvolve) _buildEvolveBorder(),

          // ── Level badge ─────────────────────────────────────────────────
          if (hasLevel) _buildLevelBadge(),
        ],
      ),
    );
  }

  Widget _buildIconFront() {
    final Widget sprite = SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topLeft,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: Transform.scale(
            scale: _scale,
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: -_spriteOffset,
              child: Image.asset(
                'assets/pokemon-icons.webp',
                filterQuality: widget.size < 64
                    ? FilterQuality.medium
                    : FilterQuality.none, // pixelated for large sizes
              ),
            ),
          ),
        ),
      ),
    );

    // Greyscale for a fainted Pokémon.
    if (widget.hasFainted) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: sprite,
      );
    }

    return sprite;
  }

  Widget _buildEvolveBorder() {
    return RotationTransition(
      turns: _spinController,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _DottedCirclePainter(
            color: const Color(0xFF2E95FF),
            strokeWidth: 5,
          ),
        ),
      ),
    );
  }

  Widget _buildLevelBadge() {
    final bool small = widget.size <= 48;
    return Positioned(
      bottom: 0,
      right: -8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF9DE0EA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Nvl. ${widget.level}',
          style: TextStyle(
            fontSize: small ? 10 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ─── Dotted circle painter ────────────────────────────────────────────────────

class _DottedCirclePainter extends CustomPainter {
  const _DottedCirclePainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;

    // Draw dashes along the circumference.
    const int dashCount = 20;
    const double dashFraction = 0.5; // half of each segment is filled

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (2 * math.pi / dashCount) * i - math.pi / 2;
      final sweepAngle = (2 * math.pi / dashCount) * dashFraction;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DottedCirclePainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}
