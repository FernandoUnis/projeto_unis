import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Variáveis estáticas que podem ser alteradas baseado no logo
  static Color _primaryColor = const Color(
    0xFF1E3A5F,
  ); // Azul Eclesiástico Profundo
  static Color _primaryLight = const Color(0xFFF4E4BC); // Ouro Suave/Pergaminho
  static Color _primaryDark = const Color(0xFF0D1B2A); // Marinho Sagrado

  // Getters estáticos para as cores primárias
  static Color get primaryColor => _primaryColor;
  static Color get primaryLight => _primaryLight;
  static Color get primaryDark => _primaryDark;

  // Método estático para atualizar as cores primárias
  static void updatePrimaryColors({
    Color? primaryColor,
    Color? primaryLight,
    Color? primaryDark,
  }) {
    if (primaryColor != null) _primaryColor = primaryColor;
    if (primaryLight != null) _primaryLight = primaryLight;
    if (primaryDark != null) _primaryDark = primaryDark;
  }

  // Método copyWith para criar novas cores baseadas nas atuais
  static void copyWith({
    Color? primaryColor,
    Color? primaryLight,
    Color? primaryDark,
  }) {
    updatePrimaryColors(
      primaryColor: primaryColor ?? _primaryColor,
      primaryLight: primaryLight ?? _primaryLight,
      primaryDark: primaryDark ?? _primaryDark,
    );
  }

  // Cor para usar sobre a cor primária (texto/ícones)
  static Color get onPrimaryColor => white;

  // Background Colors
  static const Color backgroundDefault = Color(
    0xFFFFF9F2,
  ); // Tom de pergaminho quente
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // ⚫ Neutral Colors
  static const Color neutralBlack = Color(0xFF000000); // Text/Title
  static const Color neutralDark = Color(0xFF3D3D3D); // Subtitle/Secondary Text
  static const Color neutralGray = Color(0xFF949494); // Placeholder, Borders
  static const Color neutralLight = Color(0xFFE6E6E6); // Divider, Disabled BG
  static const Color neutralWhite = Color(0xFFF5F5F5); // Backgrounds

  // Accent Colors
  static const Color accentColor = Color(0xFFD4AF37); // Sacred Gold
  static const Color liturgicalPurple = Color(
    0xFF6A1B9A,
  ); // Ecclesiastical Purple
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);

  // Card Colors
  static const Color cardBackground = Color(0xFFFDFBF7); // Pergaminho Refinado
  static const Color cardShadow = Color(0x1A000000);

  // 🚨 Alert Colors
  static const Color alertError = Color(0xFFBA1A1A);
  static const Color alertWarning = Color(0xFFFF6C6C);
  static const Color alertSuccess = Color(0xFF42CD63);

  // 📝 Application Text Colors
  static const Color textPrimary = neutralBlack;
  static const Color textSecondary = neutralDark;
  static const Color textOnPrimary = white;
  static const Color textDisabled = neutralGray;
  static const Color textPlaceholder = neutralLight;

  // 🎨 Background Colors
  static const Color backgroundSurface = Color(0xFFE6E6E6);
  static Color get backgroundAccent => _primaryLight;

  // 🧩 Icon Colors
  static Color get iconPrimary => _primaryColor;
  static const Color iconInactive = neutralGray;
  static const Color iconOnDark = neutralWhite;

  // Gradient Start Color - Tom de creme/pêssego claro que combina com dourado
  static const Color gradientStart = Color(
    0xFFF4E4BC,
  ); // Ouro Suave (mesmo que primaryLight)

  // White with opacity
  static const Color white70 = Color(0xB3FFFFFF); // White with 70% opacity

  static final LinearGradient gradientPrimary = LinearGradient(
    colors: [primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(4.9),
  );

  static final LinearGradient gradientGray = LinearGradient(
    colors: [neutralGray, neutralLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(4.9),
  );
}
