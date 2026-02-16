/// Modelo que representa uma leitura bíblica na liturgia
class LeituraLiturgica {
  final String referencia; // Ex: "Lucas 24:1-12"
  final String titulo; // Ex: "Evangelho"
  final String? texto; // Texto completo da leitura (opcional)
  final String? subtitulo; // Ex: "Deus consola o seu povo."
  final String? livro; // Ex: "Isaías", "Mateus"
  final String? fechamento; // Ex: "Palavra do Senhor.", "Palavra da Salvação."

  LeituraLiturgica({
    required this.referencia,
    required this.titulo,
    this.texto,
    this.subtitulo,
    this.livro,
    this.fechamento,
  });

  factory LeituraLiturgica.fromJson(Map<String, dynamic> json) {
    return LeituraLiturgica(
      referencia: json['referencia'] as String? ?? '',
      titulo: json['titulo'] as String? ?? '',
      texto: json['texto'] as String?,
      subtitulo: json['subtitulo'] as String?,
      livro: json['livro'] as String?,
      fechamento: json['fechamento'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referencia': referencia,
      'titulo': titulo,
      if (texto != null) 'texto': texto,
      if (subtitulo != null) 'subtitulo': subtitulo,
      if (livro != null) 'livro': livro,
      if (fechamento != null) 'fechamento': fechamento,
    };
  }
}

/// Modelo que representa a liturgia de um dia específico
class LiturgiaDiaria {
  final DateTime data;
  final String? corLiturgica; // Ex: "Verde", "Branco", "Vermelho", "Roxo"
  final String? tempoLiturgico; // Ex: "Tempo Comum", "Advento", "Quaresma"
  final String? solenidade; // Ex: "Natividade do Senhor"
  final String? festa; // Ex: "São Pedro e São Paulo"
  final String? memoria; // Ex: "São Francisco de Assis"
  final List<LeituraLiturgica> leituras;
  final String? salmo; // Referência do salmo
  final String? salmoTexto; // Texto do salmo responsorial
  final String? salmoRefrao; // Refrão do salmo
  final String?
  salmoRefraoReferencia; // Referência do refrão (ex: "R. Is 40,9-10")
  final String? aclamacao; // Versículo da aclamação ao Evangelho
  final String?
  aclamacaoRefrao; // Refrão da aclamação (ex: "Aleluia, Aleluia, Aleluia.")
  final String? oracao; // Oração do dia
  final String? santoDoDia; // Santo do dia

  LiturgiaDiaria({
    required this.data,
    this.corLiturgica,
    this.tempoLiturgico,
    this.solenidade,
    this.festa,
    this.memoria,
    required this.leituras,
    this.salmo,
    this.salmoTexto,
    this.salmoRefrao,
    this.salmoRefraoReferencia,
    this.aclamacao,
    this.aclamacaoRefrao,
    this.oracao,
    this.santoDoDia,
  });

  /// Retorna o tipo de celebração (prioridade: solenidade > festa > memória > tempo comum)
  String? get tipoCelebracao {
    if (solenidade != null) return 'Solenidade';
    if (festa != null) return 'Festa';
    if (memoria != null) return 'Memória';
    return null;
  }

  /// Retorna o nome da celebração
  String? get nomeCelebracao {
    return solenidade ?? festa ?? memoria;
  }

  /// Retorna a primeira leitura (geralmente do Antigo Testamento)
  LeituraLiturgica? get primeiraLeitura {
    return leituras.isNotEmpty ? leituras[0] : null;
  }

  /// Retorna o salmo responsorial
  LeituraLiturgica? get salmoResponsorial {
    return leituras.length > 1 ? leituras[1] : null;
  }

  /// Retorna o Evangelho
  LeituraLiturgica? get evangelho {
    // Busca pela última leitura que tem título "Evangelho"
    for (var i = leituras.length - 1; i >= 0; i--) {
      if (leituras[i].titulo.toLowerCase().contains('evangelho')) {
        return leituras[i];
      }
    }
    // Se não encontrar, retorna a última leitura
    return leituras.isNotEmpty ? leituras.last : null;
  }

  factory LiturgiaDiaria.fromJson(Map<String, dynamic> json) {
    final dataStr = json['data'] as String;
    final data = DateTime.parse(dataStr);

    final leiturasJson = json['leituras'] as List<dynamic>? ?? [];
    final leituras = leiturasJson
        .map((l) => LeituraLiturgica.fromJson(l as Map<String, dynamic>))
        .toList();

    return LiturgiaDiaria(
      data: data,
      corLiturgica: json['corLiturgica'] as String?,
      tempoLiturgico: json['tempoLiturgico'] as String?,
      solenidade: json['solenidade'] as String?,
      festa: json['festa'] as String?,
      memoria: json['memoria'] as String?,
      leituras: leituras,
      salmo: json['salmo'] as String?,
      salmoTexto: json['salmoTexto'] as String?,
      salmoRefrao: json['salmoRefrao'] as String?,
      salmoRefraoReferencia: json['salmoRefraoReferencia'] as String?,
      aclamacao: json['aclamacao'] as String?,
      aclamacaoRefrao: json['aclamacaoRefrao'] as String?,
      oracao: json['oracao'] as String?,
      santoDoDia: json['santoDoDia'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toIso8601String(),
      if (corLiturgica != null) 'corLiturgica': corLiturgica,
      if (tempoLiturgico != null) 'tempoLiturgico': tempoLiturgico,
      if (solenidade != null) 'solenidade': solenidade,
      if (festa != null) 'festa': festa,
      if (memoria != null) 'memoria': memoria,
      'leituras': leituras.map((l) => l.toJson()).toList(),
      if (salmo != null) 'salmo': salmo,
      if (salmoTexto != null) 'salmoTexto': salmoTexto,
      if (salmoRefrao != null) 'salmoRefrao': salmoRefrao,
      if (salmoRefraoReferencia != null)
        'salmoRefraoReferencia': salmoRefraoReferencia,
      if (aclamacao != null) 'aclamacao': aclamacao,
      if (aclamacaoRefrao != null) 'aclamacaoRefrao': aclamacaoRefrao,
      if (oracao != null) 'oracao': oracao,
      if (santoDoDia != null) 'santoDoDia': santoDoDia,
    };
  }
}

/// Modelo que representa o calendário litúrgico completo
class CalendarioLiturgico {
  final int anoInicio;
  final int anoFim;
  final Map<String, LiturgiaDiaria>
  liturgias; // Chave: data em formato ISO (YYYY-MM-DD)

  CalendarioLiturgico({
    required this.anoInicio,
    required this.anoFim,
    required this.liturgias,
  });

  /// Retorna a liturgia de uma data específica
  LiturgiaDiaria? getLiturgia(DateTime data) {
    final key = _formatarData(data);
    return liturgias[key];
  }

  /// Retorna a liturgia de hoje
  LiturgiaDiaria? get liturgiaHoje => getLiturgia(DateTime.now());

  /// Retorna todas as liturgias de um mês específico
  List<LiturgiaDiaria> getLiturgiasDoMes(int ano, int mes) {
    final liturgiasDoMes = <LiturgiaDiaria>[];
    final primeiroDia = DateTime(ano, mes, 1);
    final ultimoDia = DateTime(ano, mes + 1, 0);

    for (var dia = primeiroDia.day; dia <= ultimoDia.day; dia++) {
      final data = DateTime(ano, mes, dia);
      final liturgia = getLiturgia(data);
      if (liturgia != null) {
        liturgiasDoMes.add(liturgia);
      }
    }

    return liturgiasDoMes;
  }

  /// Retorna todas as liturgias de um ano específico
  List<LiturgiaDiaria> getLiturgiasDoAno(int ano) {
    final liturgiasDoAno = <LiturgiaDiaria>[];
    for (var mes = 1; mes <= 12; mes++) {
      liturgiasDoAno.addAll(getLiturgiasDoMes(ano, mes));
    }
    return liturgiasDoAno;
  }

  /// Formata data para chave (YYYY-MM-DD)
  String _formatarData(DateTime data) {
    return '${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}';
  }

  factory CalendarioLiturgico.fromJson(Map<String, dynamic> json) {
    final liturgiasJson = json['liturgias'] as Map<String, dynamic>;
    final liturgias = <String, LiturgiaDiaria>{};

    liturgiasJson.forEach((key, value) {
      liturgias[key] = LiturgiaDiaria.fromJson(value as Map<String, dynamic>);
    });

    return CalendarioLiturgico(
      anoInicio: json['anoInicio'] as int,
      anoFim: json['anoFim'] as int,
      liturgias: liturgias,
    );
  }

  Map<String, dynamic> toJson() {
    final liturgiasJson = <String, dynamic>{};
    liturgias.forEach((key, value) {
      liturgiasJson[key] = value.toJson();
    });

    return {
      'anoInicio': anoInicio,
      'anoFim': anoFim,
      'liturgias': liturgiasJson,
    };
  }
}
