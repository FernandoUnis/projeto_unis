class FontOption {
  final String name;
  final String fontFamily;

  const FontOption({
    required this.name,
    required this.fontFamily,
  });

  static const List<FontOption> fonts = [
    FontOption(
      name: 'Serif',
      fontFamily: 'serif',
    ),
    FontOption(
      name: 'Garamond',
      fontFamily: 'Garamond',
    ),
    FontOption(
      name: 'Times New Roman',
      fontFamily: 'Times New Roman',
    ),
  ];
}

