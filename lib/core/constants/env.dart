abstract class Env {
  static const githubToken = String.fromEnvironment('GHS_KEY');
  static const claudeKey = String.fromEnvironment('CLAUDE_KEY');
  static const useMock = bool.fromEnvironment('USE_MOCK');
  static const githubUser = 'jvcss';
}
