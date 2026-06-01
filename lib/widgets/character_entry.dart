import 'package:flutter/material.dart';
import 'package:paek_game_tool_flutter/models/character.dart';
import 'package:paek_game_tool_flutter/widgets/pokemon_icon.dart';

/// Flutter equivalent of the Angular [CharacterEntryComponent].
///
/// Displays a tappable list tile with the character's portrait, name, and
/// a compact row of [PokemonIcon] widgets for the first few team members.
class CharacterEntry extends StatelessWidget {
  const CharacterEntry({super.key, required this.character, this.onTap});

  final ListCharacter character;

  /// Called when the entry is tapped (navigate to the character sheet).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // ── Portrait thumbnail ─────────────────────────────────────────
              _buildPortrait(context),
              const SizedBox(width: 14),

              // ── Character name ─────────────────────────────────────────────
              Expanded(
                child: Text(
                  character.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ── Pokémon team icons ─────────────────────────────────────────
              if (character.pokemon.isNotEmpty)
                _buildPokemonTeamSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    const double thumbSize = 56.0;

    // Try to load the portrait from the network; fall back to a placeholder.
    final bool isUrl = character.portrait.startsWith('http');

    final ImageProvider imageProvider = isUrl
        ? NetworkImage(character.portrait)
        : const AssetImage('assets/placeholder_portrait.webp') as ImageProvider;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image(
        image: imageProvider,
        width: thumbSize,
        height: thumbSize,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: thumbSize,
          height: thumbSize,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.person, size: 32),
        ),
      ),
    );
  }

  Widget _buildPokemonTeamSection(BuildContext context) {
    const double iconSize = 40.0;

    return Row(
      spacing: 4,
      children: character.pokemon
          // The Angular component uses the raw Pokédex index (1-based),
          // while PokemonIcon expects a 0-based flat sprite-sheet index.
          .map((idx) => PokemonIcon(iconIdx: idx, size: iconSize))
          .toList(),
    );
  }
}
