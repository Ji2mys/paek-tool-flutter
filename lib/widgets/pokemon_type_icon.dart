import 'package:flutter/material.dart';

/// A widget that displays a Pokémon **type** icon from the type-icons sprite
/// sheet (`assets/type-icons.webp`).
///
/// The sprite sheet is a 6-column grid of circular type icons, each cell being
/// a square. The sprite sheet image height covers 3 rows; the cell size is
/// therefore `imageHeight / 3`.
///
/// [iconIdx] is the flat, 0-based index of the desired type icon in the grid:
///
/// ```
/// 0  Normal   1  Fighting  2  Flying   3  Poison   4  Ground   5  Rock
/// 6  Bug      7  Ghost     8  Steel    9  Fire     10 Water    11 Grass
/// 12 Electric 13 Psychic   14 Ice      15 Dragon   16 Dark     17 Fairy
/// ```
///
/// [size] controls the rendered width **and** height of the clipped cell
/// (default 70 logical pixels, matching the Angular component's default).
class PokemonTypeIcon extends StatelessWidget {
  const PokemonTypeIcon({super.key, required this.iconIdx, this.size = 70.0});

  final int iconIdx;
  final double size;

  static const int _columns = 6;

  @override
  Widget build(BuildContext context) {
    final int col = iconIdx % _columns;
    final int row = iconIdx ~/ _columns;
    final double xOffset = -(col * size);
    final double yOffset = -(row * size);

    return SizedBox(
      width: size,
      height: size,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topLeft,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: Transform.translate(
            offset: Offset(xOffset, yOffset),
            child: Image.asset(
              'assets/type-icons.webp',
              height: size * 3,
              fit: BoxFit.fitHeight,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
      ),
    );
  }
}
