import 'package:flutter/material.dart';

class ColorPalette {
  final String name;
  final Color primaryColor;
  final Color primaryLight;
  final Color primaryDark;

  const ColorPalette({
    required this.name,
    required this.primaryColor,
    required this.primaryLight,
    required this.primaryDark,
  });

  static const List<ColorPalette> palettes = [
    // Paleta 1: Dourado Pálido
    ColorPalette(
      name: 'Dourado Pálido',
      primaryColor: Color(0xFFD4A574),
      primaryLight: Color(0xFFE8D4B8),
      primaryDark: Color(0xFFB8956A),
    ),
    // Paleta 2: Dourado Clássico
    ColorPalette(
      name: 'Dourado Clássico',
      primaryColor: Color(0xFFB8860B),
      primaryLight: Color(0xFFD4AF37),
      primaryDark: Color(0xFF8B6914),
    ),
    // Paleta 3: Dourado Suave
    ColorPalette(
      name: 'Dourado Suave',
      primaryColor: Color(0xFFC9A961),
      primaryLight: Color(0xFFE5D4A1),
      primaryDark: Color(0xFFA68B4F),
    ),
    // Paleta 4: Dourado Rico
    ColorPalette(
      name: 'Dourado Rico',
      primaryColor: Color(0xFFCD853F),
      primaryLight: Color(0xFFE6C79A),
      primaryDark: Color(0xFFA0522D),
    ),
    // Paleta 5: Bronze Antigo
    ColorPalette(
      name: 'Bronze Antigo',
      primaryColor: Color(0xFF8B7355),
      primaryLight: Color(0xFFB89F7F),
      primaryDark: Color(0xFF6B5638),
    ),
    // Paleta 6: Cobre Envelhecido
    ColorPalette(
      name: 'Cobre Envelhecido',
      primaryColor: Color(0xFFB87333),
      primaryLight: Color(0xFFD4A574),
      primaryDark: Color(0xFF8B5A2B),
    ),
    // Paleta 7: Prata Clássico
    ColorPalette(
      name: 'Prata Clássico',
      primaryColor: Color(0xFFC0C0C0),
      primaryLight: Color(0xFFE8E8E8),
      primaryDark: Color(0xFF808080),
    ),
    // Paleta 8: Prata Suave
    ColorPalette(
      name: 'Prata Suave',
      primaryColor: Color(0xFFB8B8B8),
      primaryLight: Color(0xFFD4D4D4),
      primaryDark: Color(0xFF9B9B9B),
    ),
    // Paleta 9: Prata Antigo
    ColorPalette(
      name: 'Prata Antigo',
      primaryColor: Color(0xFFA8A8A8),
      primaryLight: Color(0xFFC9C9C9),
      primaryDark: Color(0xFF8B8B8B),
    ),
    // Paleta 10: Prata Brilhante
    ColorPalette(
      name: 'Prata Brilhante',
      primaryColor: Color(0xFFD3D3D3),
      primaryLight: Color(0xFFE5E5E5),
      primaryDark: Color(0xFFB0B0B0),
    ),
  ];
}
