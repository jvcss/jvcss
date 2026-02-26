class GitHubStats {
  final int totalCommits;
  final int totalRepos;
  final Map<String, double> languagePercents;
  final List<String> recentCommitMessages;

  const GitHubStats({
    required this.totalCommits,
    required this.totalRepos,
    required this.languagePercents,
    required this.recentCommitMessages,
  });

  static GitHubStats mock() => const GitHubStats(
        totalCommits: 342,
        totalRepos: 18,
        languagePercents: {
          'Dart': 58.4,
          'Python': 18.2,
          'JavaScript': 11.7,
          'TypeScript': 7.3,
          'Shell': 4.4,
        },
        recentCommitMessages: [
          'feat: add animated sphere widget with radial gradient',
          'fix: correct --base-href for GitHub Pages deployment',
          'feat: migrate portfolio from MkDocs to Flutter Web',
          'chore: setup GitHub Actions CI/CD workflow',
          'feat: implement riverpod state management',
          'fix: responsive breakpoints for mobile layout',
          'refactor: extract skill card into separate widget',
          'feat: add glassmorphism effect to skill cards',
          'docs: update README with setup instructions',
          'feat: implement dark theme with custom color palette',
        ],
      );
}
