import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/env.dart';
import '../models/ai_judgement_model.dart';

class ClaudeService {
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _model = 'claude-haiku-4-5-20251001';

  Future<String> analyzeCommits(List<String> commitMessages) async {
    if (Env.useMock || Env.claudeKey.isEmpty) {
      // Simula delay de resposta real
      await Future.delayed(const Duration(seconds: 2));
      return AiJudgement.mock.text;
    }

    if (commitMessages.isEmpty) {
      return 'Nenhum commit encontrado para análise.';
    }

    final prompt = _buildPrompt(commitMessages);

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'x-api-key': Env.claudeKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 512,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API: ${response.statusCode} ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final content = body['content'] as List;
    return (content.first as Map)['text'] as String;
  }

  String _buildPrompt(List<String> commits) {
    final sample = commits.take(30).join('\n- ');
    return '''Analise os seguintes commits do desenvolvedor João Victor (jvcss) e forneça um julgamento profissional conciso em português (máximo 3 parágrafos) sobre:
1. Qualidade e clareza das mensagens de commit
2. Padrões de versionamento e disciplina técnica
3. Áreas de expertise identificadas

Commits analisados:
- $sample

Responda de forma direta e construtiva, como um avaliador técnico sênior.''';
  }
}
