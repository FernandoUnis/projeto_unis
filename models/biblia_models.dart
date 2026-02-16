class Versiculo {
  final int numero;
  final String texto;

  Versiculo({required this.numero, required this.texto});

  factory Versiculo.fromJson(Map<String, dynamic> json) {
    return Versiculo(
      numero: json['numero'] as int,
      texto: json['texto'] as String,
    );
  }
}

class Capitulo {
  final int numero;
  final List<Versiculo> versiculos;

  Capitulo({required this.numero, required this.versiculos});

  factory Capitulo.fromJson(Map<String, dynamic> json) {
    return Capitulo(
      numero: json['numero'] as int,
      versiculos:
          (json['versiculos'] as List<dynamic>?)
              ?.map((v) => Versiculo.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Livro {
  final int id;
  final String nome;
  final String abreviacao;
  final List<Capitulo> capitulos;

  Livro({
    required this.id,
    required this.nome,
    required this.abreviacao,
    required this.capitulos,
  });

  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      id: json['id'] as int,
      nome: json['nome'] as String,
      abreviacao: json['abreviacao'] as String,
      capitulos:
          (json['capitulos'] as List<dynamic>?)
              ?.map((c) => Capitulo.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Modelo que representa uma categoria de livros (ex: Pentateuco, Evangelhos)
class CategoriaLivros {
  final String nome;
  final List<Livro> livros;

  CategoriaLivros({required this.nome, required this.livros});

  factory CategoriaLivros.fromJson(String nome, List<dynamic> json) {
    return CategoriaLivros(
      nome: nome,
      livros: json
          .map((l) => Livro.fromJson(l as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converte para formato antigo (Map) para compatibilidade
  MapEntry<String, List<Livro>> toMapEntry() {
    return MapEntry(nome, livros);
  }
}

/// Classe base abstrata para Testamentos
abstract class TestamentoBase {
  List<CategoriaLivros> get categorias;
  Map<String, List<Livro>> toMap();
  List<Livro> get todosLivros;
  CategoriaLivros? getCategoria(String nome);
  List<String> get nomesCategorias;
}

/// Modelo que representa o Antigo Testamento
class AntigoTestamento implements TestamentoBase {
  @override
  final List<CategoriaLivros> categorias;

  AntigoTestamento({required this.categorias});

  factory AntigoTestamento.fromJson(Map<String, dynamic> json) {
    final categorias = <CategoriaLivros>[];
    json.forEach((key, value) {
      if (value is List) {
        categorias.add(CategoriaLivros.fromJson(key, value));
      }
    });
    return AntigoTestamento(categorias: categorias);
  }

  /// Converte para formato antigo (Map) para compatibilidade
  @override
  Map<String, List<Livro>> toMap() {
    final map = <String, List<Livro>>{};
    for (var categoria in categorias) {
      map[categoria.nome] = categoria.livros;
    }
    return map;
  }

  /// Retorna todos os livros do Antigo Testamento
  @override
  List<Livro> get todosLivros {
    final livros = <Livro>[];
    for (var categoria in categorias) {
      livros.addAll(categoria.livros);
    }
    return livros;
  }

  /// Busca uma categoria pelo nome
  @override
  CategoriaLivros? getCategoria(String nome) {
    try {
      return categorias.firstWhere((c) => c.nome == nome);
    } catch (e) {
      return null;
    }
  }

  /// Retorna todas as categorias como lista de nomes
  @override
  List<String> get nomesCategorias => categorias.map((c) => c.nome).toList();
}

/// Modelo que representa o Novo Testamento
class NovoTestamento implements TestamentoBase {
  @override
  final List<CategoriaLivros> categorias;

  NovoTestamento({required this.categorias});

  factory NovoTestamento.fromJson(Map<String, dynamic> json) {
    final categorias = <CategoriaLivros>[];
    json.forEach((key, value) {
      if (value is List) {
        categorias.add(CategoriaLivros.fromJson(key, value));
      }
    });
    return NovoTestamento(categorias: categorias);
  }

  /// Converte para formato antigo (Map) para compatibilidade
  @override
  Map<String, List<Livro>> toMap() {
    final map = <String, List<Livro>>{};
    for (var categoria in categorias) {
      map[categoria.nome] = categoria.livros;
    }
    return map;
  }

  /// Retorna todos os livros do Novo Testamento
  @override
  List<Livro> get todosLivros {
    final livros = <Livro>[];
    for (var categoria in categorias) {
      livros.addAll(categoria.livros);
    }
    return livros;
  }

  /// Busca uma categoria pelo nome
  @override
  CategoriaLivros? getCategoria(String nome) {
    try {
      return categorias.firstWhere((c) => c.nome == nome);
    } catch (e) {
      return null;
    }
  }

  /// Retorna todas as categorias como lista de nomes
  @override
  List<String> get nomesCategorias => categorias.map((c) => c.nome).toList();
}

class Biblia {
  final String nome;
  final String versao;
  final AntigoTestamento antigoTestamento;
  final NovoTestamento novoTestamento;

  Biblia({
    required this.nome,
    required this.versao,
    required this.antigoTestamento,
    required this.novoTestamento,
  });

  factory Biblia.fromJson(Map<String, dynamic> json) {
    final bibliaData = json['biblia'] as Map<String, dynamic>;

    final antigoTestamento = AntigoTestamento.fromJson(
      bibliaData['antigoTestamento'] as Map<String, dynamic>? ?? {},
    );

    final novoTestamento = NovoTestamento.fromJson(
      bibliaData['novoTestamento'] as Map<String, dynamic>? ?? {},
    );

    return Biblia(
      nome: bibliaData['nome'] as String? ?? 'Bíblia Católica',
      versao: bibliaData['versao'] as String? ?? '',
      antigoTestamento: antigoTestamento,
      novoTestamento: novoTestamento,
    );
  }

  /// Retorna todos os livros da Bíblia
  List<Livro> get todosLivros {
    final livros = <Livro>[];
    livros.addAll(antigoTestamento.todosLivros);
    livros.addAll(novoTestamento.todosLivros);
    return livros;
  }

  /// Métodos de compatibilidade para manter o código antigo funcionando
  /// @deprecated Use antigoTestamento.toMap() diretamente
  Map<String, List<Livro>> get antigoTestamentoMap => antigoTestamento.toMap();

  /// Métodos de compatibilidade para manter o código antigo funcionando
  /// @deprecated Use novoTestamento.toMap() diretamente
  Map<String, List<Livro>> get novoTestamentoMap => novoTestamento.toMap();
}
