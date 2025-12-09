# EduNova Design System

This document describes the design system for EduNova, based on the Figma design specifications.

**Figma Design:** [EduNova Design File](https://www.figma.com/design/FsBzEqoNr2icN9d5SwH6ao/EduNova?node-id=0-1&p=f&t=YJnwR7kuozZzIyny-0)

## Color Palette

### Primary Colors

#### Current Implementation
- **Primary Color**: `#6A4C93` (Purple)
- **Secondary Color**: `#7FFFD4` (Aquamarine)
- **Dark Blue**: `#003366` (Used for buttons and accents)

#### Color Usage
```dart
// lib/core/constants/app_constants.dart
static const int primaryColorValue = 0xFF6A4C93;      // Purple
static const int secondaryColorValue = 0xFF7FFFD4;    // Aquamarine
static const int textPrimaryValue = 0xFF2C3E50;       // Dark text
static const int textSecondaryValue = 0xFF5A6C7D;     // Light text
static const int accentColorValue = 0xFF9B7EBD;       // Light purple
static const int pinkButtonValue = 0xFFFF69B4;        // Pink accent
```

### Semantic Colors

**To be updated based on Figma design:**

- **Success**: Green (for positive actions)
- **Error**: Red (for errors and warnings)
- **Info**: Blue (for informational messages)
- **Warning**: Orange (for warnings)

## Typography

### Font Family
- **Primary Font**: Roboto (default Flutter font)
- Fallback: System default

### Font Sizes (Current Implementation)

Defined in `lib/core/constants/ui_constants.dart`:

```dart
static const double fontSizeSmall = 12.0;      // Small text, captions
static const double fontSizeMedium = 14.0;     // Body text
static const double fontSizeLarge = 16.0;      // Large body, button text
static const double fontSizeXLarge = 20.0;     // Subheadings
static const double fontSizeTitle = 24.0;      // Section titles
static const double fontSizeHeading = 28.0;    // Page headings
```

### Font Weights
- **Regular**: 400 (Normal text)
- **Medium**: 500 (Emphasized text)
- **Bold**: 700 (Headings, important text)

### Text Styles

**To be aligned with Figma:**

- **H1 (Page Titles)**: 28px, Bold
- **H2 (Section Titles)**: 24px, Bold
- **H3 (Subsections)**: 20px, Bold
- **Body**: 16px, Regular
- **Body Small**: 14px, Regular
- **Caption**: 12px, Regular
- **Button Text**: 16px, Bold

## Spacing System

Defined in `lib/core/constants/ui_constants.dart`:

```dart
static const double spacingXSmall = 4.0;
static const double spacingSmall = 8.0;
static const double spacingMedium = 16.0;
static const double spacingLarge = 24.0;
static const double spacingXLarge = 32.0;
```

### Usage Guidelines
- **XSmall (4px)**: Between related elements
- **Small (8px)**: Within components
- **Medium (16px)**: Between components
- **Large (24px)**: Between sections
- **XLarge (32px)**: Page margins

## Border Radius

```dart
static const double borderRadiusSmall = 8.0;       // Input fields, small cards
static const double borderRadiusMedium = 12.0;     // Cards, dialogs
static const double borderRadiusLarge = 16.0;      // Large cards, panels
static const double borderRadiusCircular = 25.0;   // Buttons, pills
```

## Components

### Buttons

#### Primary Button
- **Background**: Dark Blue (#003366)
- **Text**: White
- **Height**: 56px
- **Border Radius**: 10px
- **Font Size**: 16px, Bold

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF003366),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: const Text('BUTTON TEXT'),
)
```

#### Secondary Button
**To be defined based on Figma**

### Input Fields

#### Text Field
- **Background**: White
- **Border**: None (filled style)
- **Border Radius**: 10px
- **Height**: 56px
- **Padding**: Horizontal 20px, Vertical 15px

```dart
InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  ),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 15,
  ),
)
```

### Cards

#### Standard Card
- **Background**: White
- **Border Radius**: 12px
- **Elevation**: 2dp
- **Padding**: 16px

```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: // Card content
  ),
)
```

### Icons

#### Icon Sizes
```dart
static const double iconSizeSmall = 16.0;
static const double iconSizeMedium = 24.0;
static const double iconSizeLarge = 32.0;
static const double iconSizeXLarge = 48.0;
```

#### Icon Colors
- **Primary**: Matches primary color (#6A4C93)
- **Secondary**: Dark text color (#2C3E50)
- **Inactive**: Light gray

## Screens Overview

### Welcome/Splash Screen
- Logo centered
- App name "EduNova" in large text
- Background: White
- Auto-navigates after 3 seconds

### Onboarding Pages
- Full-screen images/illustrations
- Title and description text
- Navigation dots
- "Next" and "Skip" buttons

### Authentication Screens

#### Sign In
- Logo at top
- "Sign in" heading
- Email input field
- Password input field with toggle
- "Forget Password?" link
- "SIGN IN" button (primary)
- Social sign-in options (Facebook, Google)
- "Sign up Here" link

#### Sign Up
- Similar layout to Sign In
- Additional fields: Name, School
- Role detection happens automatically

### Dashboard Screens

#### Student Dashboard
- Top navigation bar
- Course cards in grid
- Module listings
- Bottom navigation

#### Teacher Dashboard
- Welcome card with name and school
- Employee ID display
- Quick Actions section
- Classes section
- Upcoming section

## Design Tokens Reference

### To Be Updated from Figma

Please review the Figma design and update the following:

1. **Exact color codes** for all UI elements
2. **Typography specifications** (font families if different from Roboto)
3. **Spacing values** for specific components
4. **Component variants** (hover, active, disabled states)
5. **Animation specifications** (if any)
6. **Shadow/elevation values**
7. **Illustration/image specifications**

## Implementation Checklist

- [ ] Verify all colors match Figma
- [ ] Ensure typography matches design specs
- [ ] Check spacing consistency
- [ ] Validate border radius values
- [ ] Confirm button styles
- [ ] Review card components
- [ ] Check icon usage and sizing
- [ ] Verify navigation patterns
- [ ] Ensure accessibility standards
- [ ] Test on different screen sizes

## Accessibility

### Color Contrast
- Ensure text has sufficient contrast with backgrounds
- Minimum contrast ratio: 4.5:1 for normal text
- Minimum contrast ratio: 3:1 for large text

### Touch Targets
- Minimum touch target size: 48x48 dp
- Adequate spacing between interactive elements

### Screen Readers
- Add semantic labels to all interactive elements
- Provide meaningful descriptions for images

## Responsive Design

### Breakpoints
- **Small phones**: < 360dp width
- **Standard phones**: 360-480dp width
- **Large phones/phablets**: 480-600dp width
- **Tablets**: > 600dp width

### Adaptation Guidelines
- Scale spacing proportionally
- Adjust grid columns for different screen sizes
- Use responsive font sizes when appropriate
- Ensure touch targets remain accessible

---

**Note**: This design system document should be kept in sync with the Figma design file. Any changes to the design should be reflected here and in the implementation.

**Last Updated**: December 2024
