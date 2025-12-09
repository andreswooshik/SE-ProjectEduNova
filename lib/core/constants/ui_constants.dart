/// UI-related constants following Single Responsibility Principle
/// This class only handles UI constant values
class UIConstants {
  // Private constructor to prevent instantiation
  UIConstants._();

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Border radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusCircular = 25.0;

  // Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Font sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeading = 28.0;

  // Card dimensions
  static const double cardElevation = 2.0;
  static const double cardElevationHovered = 4.0;
  static const double maxCardWidth = 600.0;

  // Button dimensions
  static const double buttonHeight = 50.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonMinWidth = 120.0;

  // Animation durations (in milliseconds)
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 300;
  static const int animationDurationLong = 500;

  // List item dimensions
  static const double listItemHeight = 72.0;
  static const double listItemHeightCompact = 56.0;

  // Image dimensions
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 72.0;
  static const double logoHeight = 80.0;

  // Input field dimensions
  static const double inputFieldHeight = 56.0;
  static const double inputFieldMinLines = 1;
  static const double inputFieldMaxLines = 5;

  // Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  // Opacity values
  static const double opacityDisabled = 0.5;
  static const double opacityHint = 0.6;
  static const double opacityLight = 0.8;
}
