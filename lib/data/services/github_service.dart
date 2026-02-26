import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/env.dart';

class GitHubService {
  static const _base = 'https://api.github.com';

  Map<String, String> get _headers => {
        'Authorization': 'token ${Env.githubToken}',
        'Accept': 'application/vnd.github.v3+json',
      };

  Future<List<Map<String, dynamic>>> fetchRepos() async {
    final uri = Uri.parse('$_base/users/${Env.githubUser}/repos?per_page=100&type=owner');
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('GitHub repos: ${response.statusCode}');
    }
    return List<Map<String, dynamic>>.from(jsonDecode(response.body) as List);
  }

  Future<Map<String, int>> fetchLanguages(String repoName) async {
    final uri = Uri.parse('$_base/repos/${Env.githubUser}/$repoName/languages');
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode != 200) return {};
    return Map<String, int>.from(jsonDecode(response.body) as Map);
  }

  Future<List<String>> fetchCommitMessages(String repoName) async {
    final uri = Uri.parse(
      '$_base/repos/${Env.githubUser}/$repoName/commits?author=${Env.githubUser}&per_page=20',
    );
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode != 200) return [];
    final commits = List<Map<String, dynamic>>.from(jsonDecode(response.body) as List);
    return commits
        .map((c) => (c['commit'] as Map)['message'] as String? ?? '')
        .where((m) => m.isNotEmpty)
        .toList();
  }

  /// Retorna contagem total de commits estimada via Search API.
  Future<int> fetchTotalCommits() async {
    final uri = Uri.parse(
      '$_base/search/commits?q=author:${Env.githubUser}&per_page=1',
    );
    final searchHeaders = {
      ..._headers,
      'Accept': 'application/vnd.github.cloak-preview+json',
    };
    final response = await http.get(uri, headers: searchHeaders);
    if (response.statusCode != 200) return 0;
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['total_count'] as int?) ?? 0;
  }
}
