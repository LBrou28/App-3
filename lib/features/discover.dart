import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import 'preferences.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  @override
  State<DiscoverScreen> createState() => _DiscoverState();
}

class _DiscoverState extends State<DiscoverScreen> {
  bool all = false;
  @override
  Widget build(BuildContext c) {
    final s = ReelScope.of(c);
    final items = s.rankedMovies().where((x) => all || x.fitsEveryone).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Header(
          'YOUR CINEMATIC SWEET SPOT',
          'Discover your matches',
          'Recommendations balance all viewers equally.',
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show movies over runtime limits'),
          value: all,
          onChanged: (v) => setState(() => all = v),
        ),
        ...items.map((m) => MovieCard(match: m)),
      ],
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({required this.match, super.key});
  final MovieMatch match;
  @override
  Widget build(BuildContext c) {
    final s = ReelScope.of(c),
        m = match.movie,
        selected = s.shortlist.contains(m.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 135,
            color: Color(m.colorValue),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    m.symbol,
                    style: const TextStyle(fontSize: 76, color: Colors.white70),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Text('${m.year} • ${m.minutes} MIN'),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Chip(label: Text('${match.groupScore}% match')),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.title,
                  style: Theme.of(c).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 5,
                  children: m.genres
                      .map(
                        (g) => Chip(
                          label: Text(g),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
                Text(
                  m.description,
                  style: const TextStyle(color: Color(0xffa0afa4), height: 1.4),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  s.viewers.length,
                  (i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          s.viewers[i].name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${match.scores[i]}%',
                        style: const TextStyle(
                          color: Color(0xffcdeb8b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!match.fitsEveryone)
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Text(
                      'Exceeds at least one runtime limit',
                      style: TextStyle(color: Color(0xfff1c392)),
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: selected
                      ? OutlinedButton.icon(
                          onPressed: () => s.toggleShortlist(m.id),
                          icon: const Icon(Icons.check),
                          label: const Text('Shortlisted · Remove'),
                        )
                      : FilledButton.icon(
                          onPressed: () => s.toggleShortlist(m.id),
                          icon: const Icon(Icons.add),
                          label: const Text('Add to the vote'),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
