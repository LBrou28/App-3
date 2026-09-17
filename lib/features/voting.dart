import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import 'preferences.dart';

class VotingScreen extends StatelessWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ReelScope.of(context);
    final candidates = state.shortlist
        .map(state.movieById)
        .whereType<Movie>()
        .toList();
    final counts = {
      for (final movie in candidates)
        movie.id: state.votes.where((vote) => vote == movie.id).length,
    };
    final cast = state.votes.whereType<String>().length;
    final highest = counts.values.fold<int>(
      0,
      (best, value) => value > best ? value : best,
    );
    final leaders = candidates
        .where((movie) => counts[movie.id] == highest && highest > 0)
        .toList();
    final String result;
    if (cast == 0) {
      result = 'The big decision awaits.';
    } else if (cast < 3) {
      result = '$cast of 3 votes are in.';
    } else if (leaders.length == 1) {
      result = 'Tonight’s pick: ${leaders.first.title}';
    } else {
      result = 'It’s a tie! Change a vote to break it.';
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Header(
          'THE FINAL CUT',
          'Make it movie night',
          'Each viewer gets one vote and can change it at any time.',
        ),
        if (candidates.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'Your ballot is empty. Add movies from Discover, then return here to vote.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        else ...[
          ...List.generate(
            3,
            (index) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: DropdownButtonFormField<String?>(
                  initialValue: state.votes[index],
                  decoration: InputDecoration(
                    labelText: '${state.viewers[index].name}’s pick',
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Not voted yet'),
                    ),
                    ...candidates.map(
                      (movie) => DropdownMenuItem<String?>(
                        value: movie.id,
                        child: Text(movie.title),
                      ),
                    ),
                  ],
                  onChanged: (value) => state.castVote(index, value),
                ),
              ),
            ),
          ),
          Card(
            color: const Color(0xff263020),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LIVE TALLY',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: Color(0xffacc28e),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    result,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xffcdeb8b),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...candidates.map(
                    (movie) => Padding(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(movie.title)),
                              Text('${counts[movie.id] ?? 0} / 3'),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: (counts[movie.id] ?? 0) / 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
