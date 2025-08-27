import 'package:flutter/material.dart';
import 'dart:async';

class SuccessPopup {
  static void show({
    required BuildContext context,
    required String title,
    String? subtitle,
    String buttonText = 'OK',
    IconData icon = Icons.check_circle,
    required Color iconColor,
    Color backgroundColor = Colors.white,
    int autoCloseDuration = 2, // in seconds
    Widget? navigateToScreen,
    VoidCallback? onClose,
    bool showButtonLoader = false, // NEW: control loader instead of button
  }) {
    final rootContext = context; // save the parent context

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        if (autoCloseDuration > 0) {
          Timer(Duration(seconds: autoCloseDuration), () {
            if (Navigator.canPop(dialogContext)) {
              Navigator.of(dialogContext).pop();
            }
            if (navigateToScreen != null && rootContext.mounted) {
              Navigator.pushReplacement(
<<<<<<< HEAD
                rootContext,
                MaterialPageRoute(builder: (context) => navigateToScreen),
              );
=======
                  context,
                  MaterialPageRoute(
                    builder: (context) => navigateToScreen,
                  ));
>>>>>>> f5ca9adc0b17953edd64d3a2a75f73f16afe71ff
            }
            onClose?.call();
          });
        }

        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: backgroundColor,
            content: SizedBox(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon section
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      icon,
                      size: 50,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  if (subtitle != null)
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 15),

                  // Button or Loader
                  if (autoCloseDuration <= 0)
                    showButtonLoader
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: iconColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
<<<<<<< HEAD
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                if (navigateToScreen != null &&
                                    rootContext.mounted) {
                                  Navigator.pushReplacement(
                                    rootContext,
                                    MaterialPageRoute(
                                        builder: (context) => navigateToScreen),
                                  );
                                }
                                onClose?.call();
                              },
                              child: Text(
                                buttonText,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                    else
                      const CircularProgressIndicator(),
                  ],
                ),
=======
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (navigateToScreen != null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => navigateToScreen,
                                    ));
                              }
                              onClose?.call();
                            },
                            child: Text(
                              buttonText,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                  else
                    const CircularProgressIndicator(),
                ],
>>>>>>> f5ca9adc0b17953edd64d3a2a75f73f16afe71ff
              ),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'dart:async';

// class SuccessPopup {
//   static void show({
//     required BuildContext context,
//     required String title,
//     String? subtitle,
//     String buttonText = 'OK',
//     IconData icon = Icons.check_circle,
//     required Color iconColor,
//     Color backgroundColor = Colors.white,
//     int autoCloseDuration = 2, // in seconds
//     Widget? navigateToScreen,
//     VoidCallback? onClose,
//     bool showButtonLoader = false,
//   }) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         if (autoCloseDuration > 0) {
//           Timer(Duration(seconds: autoCloseDuration), () {
//             Navigator.of(context).pop();
//             if (navigateToScreen != null) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => navigateToScreen),
//               );
//             }
//             onClose?.call();
//           });
//         }

//         final screenHeight = MediaQuery.of(context).size.height;
//         final screenWidth = MediaQuery.of(context).size.width;

//         return PopScope(
//           canPop: false,
//           child: AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             backgroundColor: backgroundColor,
//             content: SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxWidth: screenWidth * 0.8,
//                   maxHeight: screenHeight * 0.6,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Icon
//                     Container(
//                       width: screenWidth * 0.2,
//                       height: screenWidth * 0.2,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: iconColor.withOpacity(0.2),
//                       ),
//                       child: Icon(
//                         icon,
//                         size: screenWidth * 0.12,
//                         color: iconColor,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Title
//                     Text(
//                       title,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: screenWidth * 0.055,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),

//                     // Subtitle
//                     if (subtitle != null)
//                       Text(
//                         subtitle,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.04,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     const SizedBox(height: 15),

//                     // Button or Loader
//                     if (autoCloseDuration <= 0)
//                       showButtonLoader
//                           ? const CircularProgressIndicator()
//                           : ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: iconColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 if (navigateToScreen != null) {
//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => navigateToScreen,
//                                     ),
//                                   );
//                                 }
//                                 onClose?.call();
//                               },
//                               child: Text(
//                                 buttonText,
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             )
//                     else
//                       const CircularProgressIndicator(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
