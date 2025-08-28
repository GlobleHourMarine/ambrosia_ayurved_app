import 'package:ambrosia_ayurved/ambrosia/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart'; // For accessing user provider
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http_parser/http_parser.dart';

class SubmitReviewScreen extends StatefulWidget {
  final String productId;
  final String orderId;
  final VoidCallback? onReviewSubmitted;

  const SubmitReviewScreen({
    super.key,
    required this.productId,
    required this.orderId,
    this.onReviewSubmitted,
  });

  @override
  _SubmitReviewScreenState createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends State<SubmitReviewScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  List<String> _getRatingDescriptions(BuildContext context) => [
        "",
        AppLocalizations.of(context)!.ratingPoor,
        AppLocalizations.of(context)!.ratingFair,
        AppLocalizations.of(context)!.ratingGood,
        AppLocalizations.of(context)!.ratingVeryGood,
        AppLocalizations.of(context)!.ratingExcellent,
      ];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<bool> _checkAndRequestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        Permission cameraPermission = Permission.camera;
        Permission mediaPermission =
            sdkInt >= 33 ? Permission.photos : Permission.storage;

        var cameraStatus = await cameraPermission.status;
        var mediaStatus = await mediaPermission.status;

        if (cameraStatus.isPermanentlyDenied ||
            mediaStatus.isPermanentlyDenied) {
          return await _showSettingsDialog();
        }

        if (!cameraStatus.isGranted || !mediaStatus.isGranted) {
          final shouldRequest = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Permissions Needed'),
                  content: const Text(
                      'To add photos, we need access to your camera and media files.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ) ??
              false;

          if (!shouldRequest) return false;

          if (!cameraStatus.isGranted) await cameraPermission.request();
          if (!mediaStatus.isGranted) await mediaPermission.request();

          cameraStatus = await cameraPermission.status;
          mediaStatus = await mediaPermission.status;

          if (cameraStatus.isGranted && mediaStatus.isGranted) return true;

          if (cameraStatus.isPermanentlyDenied ||
              mediaStatus.isPermanentlyDenied) {
            return await _showSettingsDialog();
          }

          SnackbarMessage.showSnackbar(context, 'Permissions denied.');
          return false;
        }

        return true;
      } else if (Platform.isIOS) {
        var cameraStatus = await Permission.camera.status;
        var photosStatus = await Permission.photos.status;

        if (cameraStatus.isPermanentlyDenied ||
            photosStatus.isPermanentlyDenied) {
          return await _showSettingsDialog();
        }

        if (!cameraStatus.isGranted || !photosStatus.isGranted) {
          final shouldRequest = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Permissions Needed'),
                  content: const Text(
                      'To add photos, we need access to your camera and photo library.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ) ??
              false;

          if (!shouldRequest) return false;

          if (!cameraStatus.isGranted) await Permission.camera.request();
          if (!photosStatus.isGranted) await Permission.photos.request();

          cameraStatus = await Permission.camera.status;
          photosStatus = await Permission.photos.status;

          if (cameraStatus.isGranted && photosStatus.isGranted) return true;

          if (cameraStatus.isPermanentlyDenied ||
              photosStatus.isPermanentlyDenied) {
            return await _showSettingsDialog();
          }

          SnackbarMessage.showSnackbar(context, 'Permissions denied.');
          return false;
        }

        return true;
      }

      return false;
    } catch (e) {
      print("Permission error: $e");
      SnackbarMessage.showSnackbar(context, 'Error requesting permissions: $e');
      return false;
    }
  }

// Add this helper method to your State class
  Future<bool> _showSettingsDialog() async {
    if (!mounted) return false;

    // First show a snackbar message
    SnackbarMessage.showSnackbar(context,
        'Permissions denied. Please enable them in app settings to use this feature.');

    // Then show dialog to open settings
    bool openSettings = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permissions Denied'),
            content: Text(
                'Would you like to open app settings to enable permissions?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Not Now'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Open Settings'),
              ),
            ],
          ),
        ) ??
        false;

    if (openSettings) {
      await openAppSettings();
    }

    return false;
  }

  Future<void> _pickImages() async {
    try {
      final hasPermission = await _checkAndRequestPermissions();
      if (!hasPermission) {
        return; // Don't proceed if permissions not granted
      }

      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        if (_imageFiles.length + images.length > 5) {
          SnackbarMessage.showSnackbar(
            context,
            AppLocalizations.of(context)!.maxPhotoLimit,
          );

          final int remainingSlots = 5 - _imageFiles.length;
          if (remainingSlots > 0) {
            setState(() {
              for (int i = 0; i < remainingSlots; i++) {
                _imageFiles.add(File(images[i].path));
              }
            });
          }
        } else {
          setState(() {
            for (var image in images) {
              _imageFiles.add(File(image.path));
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarMessage.showSnackbar(
            context,
            //   '${AppLocalizations.of(context)?.errorOccurred ??

            'Error occurred : ${e.toString()}');
      }
    }
  }

  Future<void> _takePicture() async {
    try {
      final hasPermission = await _checkAndRequestPermissions();
      if (!hasPermission) {
        return; // Don't proceed if permissions not granted
      }

      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        if (_imageFiles.length >= 5) {
          SnackbarMessage.showSnackbar(
            context,
            AppLocalizations.of(context)!.maxPhotoLimit,
          );
        } else {
          setState(() {
            _imageFiles.add(File(photo.path));
          });
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarMessage.showSnackbar(
            context,
            //  '${AppLocalizations.of(context)?.errorOccurred ??

            'Error occurred : ${e.toString()}');
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  Future<void> _submitReview() async {
    // Validate rating
    if (_rating == 0) {
      SnackbarMessage.showSnackbar(
        context,
        AppLocalizations.of(context)!.pleaseSelectRating,
      );
      return;
    }

    // Validate review text
    if (_reviewController.text.trim().isEmpty) {
      SnackbarMessage.showSnackbar(
        context,
        AppLocalizations.of(context)!.pleaseWriteReview,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.id.toString();

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://ambrosiaayurved.in/api/submit_review'),
      );

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Connection': 'keep-alive',
      });

      // Add form fields
      request.fields.addAll({
        'user_id': userId,
        'product_id': widget.productId.toString(),
        'rating': _rating.toString(),
        'message': _reviewController.text.trim(),
        'order_id': widget.orderId.toString(),
      });

      // Add image files as array
      for (var i = 0; i < _imageFiles.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file_path[]', // Array notation with square brackets
            _imageFiles[i].path,
            contentType:
                MediaType('image', 'jpeg'), // Adjust for your image type
          ),
        );
      }

      // Print request details for debugging
      debugPrint('Request Fields: ${request.fields}');
      debugPrint('Files Count: ${request.files.length}');

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      debugPrint('Full API Response: $jsonResponse');

      // Handle response
      if (response.statusCode == 200) {
        if (jsonResponse['status'] == 'success') {
          // Success case
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.thankYou),
              content: Text(
                jsonResponse['message'] ??
                    AppLocalizations.of(context)!.reviewSuccessMessage,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _rating = 0;
                      _reviewController.clear();
                      _imageFiles.clear();
                      _isSubmitting = false;
                    });
                    // Optional: Trigger callback if exists
                    widget.onReviewSubmitted?.call();
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
              ],
            ),
          );

          // Log uploaded files
          if (jsonResponse['file_path'] != null) {
            debugPrint('Uploaded files: ${jsonResponse['file_path']}');
          }
        } else {
          throw Exception(jsonResponse['message'] ??
              AppLocalizations.of(context)!.reviewSubmitFailed);
        }
      } else {
        throw Exception(
          jsonResponse['message'] ??
              '${AppLocalizations.of(context)!.serverError}: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('Stack Trace: $stackTrace');
      SnackbarMessage.showSnackbar(
        context,
        '${AppLocalizations.of(context)!.error}: ${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: CustomAppBar(title: appLocalizations.writeAReview),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Icon(Icons.rate_review,
                            size: 48, color: Colors.green),
                        const SizedBox(width: 25),
                        Text(
                          appLocalizations.shareYourExperience,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      appLocalizations.productOpinionPrompt,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              appLocalizations.rateThisProduct,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      size: 40,
                      color: index < _rating ? Colors.green : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
            if (_rating > 0) ...[
              const SizedBox(height: 8),
              Text(
                _getRatingDescriptions(context)[_rating],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 15),
            Text(
              appLocalizations.yourReview,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: appLocalizations.reviewHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              appLocalizations.addPhotos,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickImages,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          const Icon(Icons.photo_library, size: 40),
                          const SizedBox(height: 8),
                          Text(appLocalizations.gallery),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _takePicture,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          const Icon(Icons.camera_alt, size: 40),
                          const SizedBox(height: 8),
                          Text(appLocalizations.camera),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_imageFiles.isNotEmpty)
              Container(
                height: 120,
                margin: const EdgeInsets.only(bottom: 20),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageFiles.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(_imageFiles[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 17,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        appLocalizations.submitReview,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
