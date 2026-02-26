import '../models/github_stats_model.dart';
import '../services/github_service.dart';

class GitHubRepository {
  final GitHubService _service;

  GitHubRepository(this._service);

  Future<GitHubStats> fetchStats() async {
    final repos = await _service.fetchRepos();
    final repoNames = repos.map((r) => r['name'] as String).toList();

    // Busca linguagens e commits de todos os repos em paralelo
    final languageFutures = repoNames.map(_service.fetchLanguages);
    final commitFutures = repoNames.take(5).map(_service.fetchCommitMessages);
    final totalCommitsFuture = _service.fetchTotalCommits();

    final allLanguages = await Future.wait(languageFutures);
    final allCommits = await Future.wait(commitFutures);
    final totalCommits = await totalCommitsFuture;

    // Agrega bytes por linguagem
    final totalBytes = <String, int>{};
    for (final langMap in allLanguages) {
      langMap.forEach((lang, bytes) {
        totalBytes[lang] = (totalBytes[lang] ?? 0) + bytes;
      });
    }

    // Calcula percentuais (top 6 linguagens)
    final grandTotal = totalBytes.values.fold(0, (a, b) => a + b);
    final sorted = totalBytes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(6).toList();

    final percents = <String, double>{};
    for (final entry in top) {
      percents[entry.key] =
          grandTotal > 0 ? (entry.value / grandTotal * 100) : 0;
    }

    // Coleta mensagens recentes
    final messages = allCommits.expand((list) => list).take(30).toList();

    return GitHubStats(
      totalCommits: totalCommits,
      totalRepos: repos.length,
      languagePercents: percents,
      recentCommitMessages: messages,
    );
  }
}
