

enum AppTheme { SYSTEM, DARK, LIGHT }

extension AppThemeExtension on AppTheme {
  String getThemeName() {
    switch (this) {
      case AppTheme.DARK:
        {
          return "Dark";
        }
      case AppTheme.LIGHT:
        {
          return "Light";
        }
      default:
        return "System";
    }
  }

  static bool getIsDarkModeOn(AppTheme theme) {
    return theme == AppTheme.DARK;
  }
}
