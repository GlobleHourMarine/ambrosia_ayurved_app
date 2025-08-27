// import 'package:flutter/material.dart';

// // Define your colors
// const Color color1 = Color(0xFF788CCE); // #788CCE
// const Color color2 = Color(0xFF272829); // #202E5A  272829
// const Color color3 = Color(0xFF4D5C88); // #4D5C88
// const Color color4 = Color(0xFF3C5CB6); // #3C5CB6
// const Color color5 = Color(0xFFCBD7F6); // #CBD7F6
// const Color color6 = Color(0xFFFFFFFF); // #FFFFFF
// const Color color7 = Color(0xFF000000); // #000000
// const Color color8 = Color(0xFFB1C2F4); // #4D5C88
// const Color color9 = Color(0xFF272829); // #000000
// const Color color10 = Color(0xFFBF3131); // #000000
// const Color color11 = Color(0xFFEAD196); // #000000 61677A
// const Color color12 = Color(0xF8EFEFBC); // #000000  0xF8EFEFBC
// const Color color13 = Color(0xFF515151); // #000000
// const Color color14 = Color(0xFFD9D9D9); // #000000
// const Color color15 = Color(0xFF9c9e9d); // #000000
// const Color color16 = Color(0xFF2b4cc2); // #000000 #2b4cc2
// const Color color17 = Color(0xFFe9670d); // #000000 #e9670d
// const Color color18 = Color(0xFFee4ee8); // #000000 #ee4ee8

// // Define the light color scheme
// const ColorScheme lightColorScheme = ColorScheme(
//   brightness: Brightness.light,
//   primary: color9, // Primary color for light mode
//   onPrimary: color6, // Color for text and icons on the primary color
//   primaryContainer: color11, // Background color of components like cards
//   onPrimaryContainer: color12, // Text color on primary container
//   secondary: color13, // Secondary color for light mode
//   onSecondary: color6, // Color for text and icons on secondary color
//   secondaryContainer: color11, // Background color of components like buttons
//   onSecondaryContainer: color6, // Text color on secondary container
//   tertiary: color7, // Tertiary color (if needed)
//   onTertiary: color6, // Color for text and icons on tertiary color
//   background: color6, // Background color of the app
//   onBackground: color9, // Text color on the background
//   surface: color6, // Surface color for cards, sheets, etc.
//   onSurface: color7, // Text color on the surface
//   surfaceVariant: color5, // Surface variant color (if needed)
//   onSurfaceVariant: color7, // Text color on surface variant
//   error: color7, // Error color
//   onError: color6, // Text color on error
//   errorContainer: color7, // Error container color
//   onErrorContainer: color6, // Text color on error container
// );

// // Define the dark color scheme
// const ColorScheme darkColorScheme = ColorScheme(
//   brightness: Brightness.dark,
//   primary: color9, // Primary color for dark mode
//   onPrimary: color12, // Color for text and icons on the primary color
//   primaryContainer: color10, // Background color of components like cards
//   onPrimaryContainer: color11, // Text color on primary container
//   secondary: color2, // Secondary color for dark mode
//   onSecondary: color6, // Color for text and icons on secondary color
//   secondaryContainer: color1, // Background color of components like buttons
//   onSecondaryContainer: color6, // Text color on secondary container
//   tertiary: color7, // Tertiary color (if needed)
//   onTertiary: color6, // Color for text and icons on tertiary color
//   background: color7, // Background color of the app
//   onBackground: color6, // Text color on the background
//   surface: color7, // Surface color for cards, sheets, etc.
//   onSurface: color6, // Text color on the surface
//   surfaceVariant: color1, // Color(0x00000000)needed)
//   onSurfaceVariant: color6, // Text color on surface variant
//   error: color6, // Error color
//   onError: color7, // Text color on error
//   errorContainer: color1, // Error container color
//   onErrorContainer: color6, // Text color on error container
// );

// ThemeData lightMode = ThemeData(
//   useMaterial3: true,
//   brightness: Brightness.light,
//   colorScheme: lightColorScheme,
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ButtonStyle(
//       backgroundColor: MaterialStateProperty.all<Color>(
//         lightColorScheme.primary, // Slightly darker shade for the button
//       ),
//       foregroundColor: MaterialStateProperty.all<Color>(color6), // text color
//       elevation: MaterialStateProperty.all<double>(5.0), // shadow
//       padding: MaterialStateProperty.all<EdgeInsets>(
//           const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
//       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16), // Adjust as needed
//         ),
//       ),
//     ),
//   ),
// );

// ThemeData darkMode = ThemeData(
//   useMaterial3: true,
//   brightness: Brightness.dark,
//   colorScheme: darkColorScheme,
// );
