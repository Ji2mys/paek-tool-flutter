import 'package:flutter/material.dart';
import 'package:paek_game_tool_flutter/data/pokemon_types.dart';
import 'package:paek_game_tool_flutter/l10n/app_localizations.dart';
import 'package:paek_game_tool_flutter/widgets/pokemon_type_icon.dart';

class PokemonTypeBadge extends StatelessWidget {
  const PokemonTypeBadge({super.key, this.type = 'NOR'});

  final String type;

  @override
  Widget build(BuildContext context) {
    final info = typesInfo[type] ?? typesInfo['NOR']!;

    return Container(
      padding: const EdgeInsets.only(left: 5, right: 13, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: info.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PokemonTypeIcon(iconIdx: info.iconIdx, size: 24),
          const SizedBox(width: 3),
          Text(
            AppLocalizations.of(context)!.pokemonType(type),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
