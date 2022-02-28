part of 'theme.dart';

class LightColors {
  static const kPrimaryValue = 0xFFA1D4AB;
  static const kPrimarySwatch = MaterialColor(
  kPrimaryValue,
  <int, Color>{
    50: Color(0xFFA1D4AB),
    100: Color(0xFFA1D4AB),
    200: Color(0xFFA1D4AB),
    300: Color(0xFFA1D4AB),
    400: Color(0xFFA1D4AB),
    500: Color(0xFFA1D4AB),
    600: Color(0xFFA1D4AB),
    700: Color(0xFFA1D4AB),
    800: Color(0xFFA1D4AB),
    900: Color(kPrimaryValue),
  },
);

  static const kSecondaryValue = 0xFFA1D4AB;
  static const kSecondarySwatch = MaterialColor(
    kPrimaryValue,
    <int, Color>{
      50: Color(0xFFA1D4AB),
      100: Color(0xFFA1D4AB),
      200: Color(0xFFA1D4AB),
      300: Color(0xFFA1D4AB),
      400: Color(0xFFA1D4AB),
      500: Color(0xFFA1D4AB),
      600: Color(0xFFA1D4AB),
      700: Color(0xFFA1D4AB),
      800: Color(kPrimaryValue),
      900: Color(0xFFA1D4AB),
    },
  );

  static const kOnSurfaceBodyTextColor = Colors.black87;
  final onSurfaceHoveredColor = kPrimarySwatch.withOpacity(0.04);
  final onSurfaceFocusColor = kPrimarySwatch.withOpacity(0.12);
  final onSurfaceSelectedColor = kPrimarySwatch.withOpacity(0.12);

  static const kDarkSurfaceColor = Color(0xFFA1D4AB);
  static const kOnDarkSurfaceHighEmphasis = Colors.black87;
  static const kOnDarkSurfaceMediumEmphasis = Colors.black87;
  static const kOnLightSurfaceMediumEmphasis = Color(0xFFA1D4AB);
  final onDarkSurfaceSelectedColor = kPrimarySwatch.shade300.withOpacity(0.12);

  final errorColor = Colors.red;
}

const kPrimaryValue = 0xFF213339;
const kPrimarySwatch = MaterialColor(
  kPrimaryValue,
  <int, Color>{
    50: Color(0xFF57AF7C),
    100: Color(0xFF57AF7C),
    200: Color(0xFF268575),
    300: Color(0xFF268575),
    400: Color(0xFF1D5B5E),
    500: Color(0xFF1D5B5E),
    600: Color(kPrimaryValue),
    700: Color(kPrimaryValue),
    800: Color(kPrimaryValue),
    900: Color(kPrimaryValue),
  },
);

const kSecondaryValue = 0xFFA1D4AB;
const kSecondarySwatch = MaterialColor(
  kPrimaryValue,
  <int, Color>{
    50: Color(0xFFA1D4AB),
    100: Color(0xFFA1D4AB),
    200: Color(0xFFA1D4AB),
    300: Color(0xFFA1D4AB),
    400: Color(0xFFA1D4AB),
    500: Color(0xFFA1D4AB),
    600: Color(0xFFA1D4AB),
    700: Color(0xFFA1D4AB),
    800: Color(0xFFA1D4AB),
    900: Color(kPrimaryValue),
  },
);

const kOnSurfaceBodyTextColor = Colors.black87;
final onSurfaceHoveredColor = kPrimarySwatch.withOpacity(0.04);
final onSurfaceFocusColor = kPrimarySwatch.withOpacity(0.12);
final onSurfaceSelectedColor = kPrimarySwatch.withOpacity(0.12);

const kDarkSurfaceColor = Color(kPrimaryValue);
const kOnDarkSurfaceHighEmphasis = Colors.white;
const kOnDarkSurfaceMediumEmphasis = Colors.white60;
final onDarkSurfaceSelectedColor = kPrimarySwatch.shade300.withOpacity(0.12);

final errorColor = Colors.red;
