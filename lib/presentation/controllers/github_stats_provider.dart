import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/github_stats_model.dart';
import '../../data/repositories/github_repository.dart';
import '../../data/services/github_service.dart';
import '../../core/constants/env.dart';

final _githubServiceProvider = Provider((ref) => GitHubService());

final _githubRepoProvider = Provider(
  (ref) => GitHubRepository(ref.watch(_githubServiceProvider)),
);

final githubStatsProvider = FutureProvider<GitHubStats>((ref) async {
  if (Env.githubToken.isEmpty) {
    return GitHubStats.mock();
  }
  return ref.watch(_githubRepoProvider).fetchStats();
});
