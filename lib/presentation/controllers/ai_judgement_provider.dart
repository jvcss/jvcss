import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ai_judgement_model.dart';
import '../../data/repositories/ai_repository.dart';
import '../../data/services/claude_service.dart';

final _claudeServiceProvider = Provider((ref) => ClaudeService());

final _aiRepoProvider = Provider(
  (ref) => AiRepository(ref.watch(_claudeServiceProvider)),
);

class AiJudgementController extends StateNotifier<AiJudgement> {
  final AiRepository _repo;

  AiJudgementController(this._repo) : super(const AiJudgement());

  Future<void> analyze(List<String> commits) async {
    if (state.isLoading) return;
    state = const AiJudgement(isLoading: true);
    try {
      final text = await _repo.judgeProfile(commits);
      state = AiJudgement(text: text);
    } catch (e) {
      state = AiJudgement(error: e.toString());
    }
  }
}

final aiJudgementProvider =
    StateNotifierProvider<AiJudgementController, AiJudgement>(
  (ref) => AiJudgementController(ref.watch(_aiRepoProvider)),
);
