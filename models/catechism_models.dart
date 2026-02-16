class CatechismParagraph {
  final int number;
  final String text;

  CatechismParagraph({required this.number, required this.text});

  factory CatechismParagraph.fromJson(Map<String, dynamic> json) {
    return CatechismParagraph(
      number: json['number'] as int,
      text: json['text'] as String,
    );
  }
}

class CatechismChapter {
  final String title;
  final String url;
  final List<CatechismParagraph> paragraphs;

  CatechismChapter({
    required this.title,
    required this.url,
    required this.paragraphs,
  });

  factory CatechismChapter.fromJson(Map<String, dynamic> json) {
    return CatechismChapter(
      title: json['title'] as String,
      url: json['url'] as String,
      paragraphs: (json['paragraphs'] as List<dynamic>)
          .map((p) => CatechismParagraph.fromJson(p))
          .toList(),
    );
  }
}

class CatechismSection {
  final String title;
  final List<CatechismChapter> chapters;

  CatechismSection({required this.title, required this.chapters});

  factory CatechismSection.fromJson(Map<String, dynamic> json) {
    return CatechismSection(
      title: json['title'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((c) => CatechismChapter.fromJson(c))
          .toList(),
    );
  }
}

class CatechismPart {
  final String title;
  final List<CatechismSection> sections;
  final List<CatechismChapter> chapters;

  CatechismPart({
    required this.title,
    required this.sections,
    required this.chapters,
  });

  factory CatechismPart.fromJson(Map<String, dynamic> json) {
    return CatechismPart(
      title: json['title'] as String,
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((s) => CatechismSection.fromJson(s))
              .toList() ??
          [],
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((c) => CatechismChapter.fromJson(c))
              .toList() ??
          [],
    );
  }
}

class Catechism {
  final String title;
  final List<CatechismPart> parts;

  Catechism({required this.title, required this.parts});

  factory Catechism.fromJson(Map<String, dynamic> json) {
    return Catechism(
      title: json['title'] as String,
      parts: (json['parts'] as List<dynamic>)
          .map((p) => CatechismPart.fromJson(p))
          .toList(),
    );
  }
}
