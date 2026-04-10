import 'package:flutter/material.dart';

/// Raw design tokens from the TripClip palette (Figma variables).
/// Use [TripClipColors] (ThemeExtension) for semantic UI colors.
abstract final class TripClipPalette {
  // Primary
  static const Color primary50 = Color(0xFFEFF2FF);
  static const Color primary100 = Color(0xFFDCE3FF);
  static const Color primary200 = Color(0xFFBFCBFF);
  static const Color primary300 = Color(0xFF7F8FEF);
  static const Color primary400 = Color(0xFF3F5BFF);
  static const Color primary500 = Color(0xFF0000D2);
  static const Color primary600 = Color(0xFF0000C0);
  static const Color primary700 = Color(0xFF0000A3);
  static const Color primary800 = Color(0xFF000083);
  static const Color primary900 = Color(0xFF000066);

  // Secondary
  static const Color secondary50 = Color(0xFFFFF7F2);
  static const Color secondary100 = Color(0xFFFFE7D9);
  static const Color secondary200 = Color(0xFFFFC7A8);
  static const Color secondary300 = Color(0xFFFFA474);
  static const Color secondary400 = Color(0xFFFF8B47);
  static const Color secondary500 = Color(0xFFFA782D);
  static const Color secondary600 = Color(0xFFE56A25);
  static const Color secondary700 = Color(0xFFC8581A);
  static const Color secondary800 = Color(0xFFA04612);
  static const Color secondary900 = Color(0xFF7D360C);

  // Tertiary
  static const Color tertiary50 = Color(0xFFF3F5FA);
  static const Color tertiary100 = Color(0xFFE3E7F2);
  static const Color tertiary200 = Color(0xFFC7CEE2);
  static const Color tertiary300 = Color(0xFF7C86AE);
  static const Color tertiary400 = Color(0xFF3F4B78);
  static const Color tertiary500 = Color(0xFF141E46);
  static const Color tertiary600 = Color(0xFF101939);
  static const Color tertiary700 = Color(0xFF0C142E);
  static const Color tertiary800 = Color(0xFF080E22);
  static const Color tertiary900 = Color(0xFF040714);

  // Accent
  static const Color accent50 = Color(0xFFF2FAFF);
  static const Color accent100 = Color(0xFFDFF4FE);
  static const Color accent200 = Color(0xFFB8E6FB);
  static const Color accent300 = Color(0xFF88D4F7);
  static const Color accent400 = Color(0xFF75C9F4);
  static const Color accent500 = Color(0xFF64BEF0);
  static const Color accent600 = Color(0xFF46A8DC);
  static const Color accent700 = Color(0xFF2C8CC0);
  static const Color accent800 = Color(0xFF1B719C);
  static const Color accent900 = Color(0xFF105574);

  // Neutral
  static const Color neutral50 = Color(0xFFF7F9FA);
  static const Color neutral100 = Color(0xFFEFF2F5);
  static const Color neutral200 = Color(0xFFDCE1E6);
  static const Color neutral300 = Color(0xFFC7CED6);
  static const Color neutral400 = Color(0xFFABB3BE);
  static const Color neutral500 = Color(0xFF8E97A3);
  static const Color neutral600 = Color(0xFF757E8A);
  static const Color neutral700 = Color(0xFF5B636F);
  static const Color neutral800 = Color(0xFF3E454F);
  static const Color neutral850 = Color(0xFF2E343D);
  static const Color neutral900 = Color(0xFF1F242B);
  static const Color neutral1000 = Color(0xFF14181F);

  /// Dark theme full-screen / page canvas (`#14181F`).
  static const Color darkPageBackground = Color(0xFF14181F);

  // Error
  static const Color error50 = Color(0xFFFFF6F5);
  static const Color error100 = Color(0xFFFFE4E1);
  static const Color error200 = Color(0xFFFFBFB9);
  static const Color error300 = Color(0xFFFF9188);
  static const Color error400 = Color(0xFFF66659);
  static const Color error500 = Color(0xFFE04B3F);
  static const Color error600 = Color(0xFFC33F35);
  static const Color error700 = Color(0xFFA4332B);
  static const Color error800 = Color(0xFF812720);
  static const Color error900 = Color(0xFF5E1C16);

  // Warning
  static const Color warning50 = Color(0xFFFFFDF6);
  static const Color warning100 = Color(0xFFFFF8E1);
  static const Color warning200 = Color(0xFFFDEEB3);
  static const Color warning300 = Color(0xFFFAD971);
  static const Color warning400 = Color(0xFFF6CA54);
  static const Color warning500 = Color(0xFFF5C044);
  static const Color warning600 = Color(0xFFE1AC30);
  static const Color warning700 = Color(0xFFC5911D);
  static const Color warning800 = Color(0xFF9E6E0F);
  static const Color warning900 = Color(0xFF7A5207);

  // Success (source listed duplicate hex for 500; using mid-ramp green)
  static const Color success50 = Color(0xFFF3FCF8);
  static const Color success100 = Color(0xFFD9F4E7);
  static const Color success200 = Color(0xFFB4E8CF);
  static const Color success300 = Color(0xFF86D9B3);
  static const Color success400 = Color(0xFF52C890);
  static const Color success500 = Color(0xFF2DB87A);
  static const Color success600 = Color(0xFF239E6D);
  static const Color success700 = Color(0xFF1C845C);
  static const Color success800 = Color(0xFF14694A);
  static const Color success900 = Color(0xFF0C4D35);

  /// `button-action` — labeled circular control (TripClip UI kit).
  static const Color buttonActionIdleFill = Color(0xFFF0F2F5);
  static const Color buttonActionIdleBorder = Color(0xFFD1D5DB);
  static const Color buttonActionIdleIcon = Color(0xFF6B7280);
  static const Color buttonActionActiveFill = Color(0xFF141E46);
  static const Color buttonActionCaption = Color(0xFF9CA3AF);
}
