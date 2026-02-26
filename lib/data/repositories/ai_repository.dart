import '../services/claude_service.dart';

class AiRepository {
  final ClaudeService _service;

  AiRepository(this._service);

  Future<String> judgeProfile(List<String> commitMessages) async {
    return _service.analyzeCommits(commitMessages);
  }
}
