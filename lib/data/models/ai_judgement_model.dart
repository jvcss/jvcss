class AiJudgement {
  final String text;
  final bool isLoading;
  final String? error;

  const AiJudgement({
    this.text = '',
    this.isLoading = false,
    this.error,
  });

  AiJudgement copyWith({
    String? text,
    bool? isLoading,
    String? error,
  }) =>
      AiJudgement(
        text: text ?? this.text,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );

  static const mock = AiJudgement(
    text:
        '"Este profissional demonstra grandes qualidades em termos de paixão" — Claude\n\n'
        'Análise dos commits revela um desenvolvedor com padrões consistentes de versionamento '
        'e clareza nas mensagens. A progressão técnica é evidente: de setup inicial para '
        'funcionalidades complexas como animações 3D e glassmorphism. '
        'As mensagens seguem convenções de Conventional Commits (feat:, fix:, chore:), '
        'indicando maturidade em colaboração de equipe. '
        'Áreas de expertise identificadas: Flutter/Dart, CI/CD, e arquitetura limpa.',
  );
}
