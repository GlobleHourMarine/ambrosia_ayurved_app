import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/review_section/review_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/review_section/review_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';

class CustomerReviewSection extends StatefulWidget {
  final String productId;

  CustomerReviewSection({required this.productId});

  @override
  _CustomerReviewSectionState createState() => _CustomerReviewSectionState();
}

class _CustomerReviewSectionState extends State<CustomerReviewSection> {
  List<Review> reviews = [];
  bool isLoading = true;
  double averageRating = 0.0;
  int visibleReviewCount = 4;

  @override
  void initState() {
    super.initState();
    getProductReviews();
  }

  Future<void> getProductReviews() async {
    try {
      List<Review> fetchedReviews =
          await ReviewService().fetchReviews(widget.productId);
      setState(() {
        reviews = fetchedReviews;
        isLoading = false;
        calculateAverageRating();
      });
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void calculateAverageRating() {
    if (reviews.isNotEmpty) {
      double totalRating = reviews
          .map((review) => double.tryParse(review.rating) ?? 0.0)
          .fold(0.0, (prev, rating) => prev + rating);
      averageRating = totalRating / reviews.length;
    }
  }

  Widget buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.green,
          size: 24,
        );
      }),
    );
  }

  // Helper function to check if file is a video
  bool isVideoFile(String path) {
    final videoExtensions = [
      '.mp4',
      '.avi',
      '.mov',
      '.mkv',
      '.flv',
      '.wmv',
      '.webm',
      '.m4v'
    ];
    String lowerPath = path.toLowerCase();
    return videoExtensions.any((ext) => lowerPath.contains(ext));
  }

  // Helper function to check if file is an image
  bool isImageFile(String path) {
    final imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.svg'
    ];
    String lowerPath = path.toLowerCase();
    return imageExtensions.any((ext) => lowerPath.contains(ext));
  }
// // //

// Update the _buildMediaWidget method to this:
  Widget _buildMediaWidget(
      String path, BuildContext context, List<String> allPaths) {
    if (isVideoFile(path)) {
      return VideoThumbnailWidget(
        videoUrl: 'https://ambrosiaayurved.in/$path',
        height: 150,
        width: 150,
      );
    } else if (isImageFile(path)) {
      return GestureDetector(
        onTap: () {
          // Find all image paths (excluding videos)
          List<String> imagePaths =
              allPaths.where((p) => isImageFile(p)).toList();
          int initialIndex = imagePaths.indexOf(path);

          if (initialIndex >= 0) {
            _showImageSlider(context, imagePaths, initialIndex);
          }
        },
        child: Image.network(
          'https://ambrosiaayurved.in/$path',
          height: 150,
          width: 150,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print(
                'Image load error: $error, URL: https://ambrosiaayurved.in/$path');
            return Container(
              height: 150,
              width: 150,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, color: Colors.grey[600]),
                  Text('Image Error', style: TextStyle(fontSize: 10)),
                ],
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 150,
              width: 150,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Container(
        height: 150,
        width: 150,
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_drive_file, color: Colors.grey[600]),
            Text('Unknown File', style: TextStyle(fontSize: 10)),
          ],
        ),
      );
    }
  }

//
//
//

  // // Helper method to build appropriate widget based on file type
  // Widget _buildMediaWidget(String path, BuildContext context) {
  //   if (isVideoFile(path)) {
  //     return VideoThumbnailWidget(
  //       videoUrl: 'https://ambrosiaayurved.in/$path',
  //       height: 150,
  //       width: 150,
  //     );
  //   } else if (isImageFile(path)) {
  //     return GestureDetector(
  //       onTap: () {
  //         // Show full-screen image
  //         _showImageDialog(context, path);
  //       },
  //       child: Image.network(
  //         'https://ambrosiaayurved.in/$path',
  //         height: 150,
  //         width: 150,
  //         fit: BoxFit.cover,
  //         errorBuilder: (context, error, stackTrace) {
  //           print(
  //               'Image load error: $error, URL: https://ambrosiaayurved.in/$path');
  //           return Container(
  //             height: 150,
  //             width: 150,
  //             color: Colors.grey[300],
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(Icons.broken_image, color: Colors.grey[600]),
  //                 Text('Image Error', style: TextStyle(fontSize: 10)),
  //               ],
  //             ),
  //           );
  //         },
  //         loadingBuilder: (context, child, loadingProgress) {
  //           if (loadingProgress == null) return child;
  //           return Container(
  //             height: 150,
  //             width: 150,
  //             child: Center(
  //               child: CircularProgressIndicator(
  //                 value: loadingProgress.expectedTotalBytes != null
  //                     ? loadingProgress.cumulativeBytesLoaded /
  //                         loadingProgress.expectedTotalBytes!
  //                     : null,
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   } else {
  //     // Unknown file type
  //     return Container(
  //       height: 150,
  //       width: 150,
  //       color: Colors.grey[300],
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.insert_drive_file, color: Colors.grey[600]),
  //           Text('Unknown File', style: TextStyle(fontSize: 10)),
  //         ],
  //       ),
  //     );
  //   }
  // }

  // // Helper method to show full-screen image
  // void _showImageDialog(BuildContext context, String imageUrl) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => Dialog(
  //       backgroundColor: Colors.black,
  //       child: Container(
  //         child: Stack(
  //           children: [
  //             Center(
  //               child: InteractiveViewer(
  //                 child: Image.network(
  //                   'https://ambrosiaayurved.in/$imageUrl',
  //                   fit: BoxFit.contain,
  //                   errorBuilder: (context, error, stackTrace) {
  //                     return Center(
  //                       child: Text(
  //                         'Failed to load image',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               top: 10,
  //               right: 10,
  //               child: IconButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 icon: Icon(Icons.close, color: Colors.white, size: 30),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    int reviewsToShow = visibleReviewCount.clamp(0, reviews.length);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  '${AppLocalizations.of(context)!.customerReviews}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //   const SizedBox(height: 10),
                      Row(
                        children: [
                          buildStarRating(averageRating.toInt()),
                          const SizedBox(width: 10),
                          Text(
                            "${averageRating.toStringAsFixed(1)} / 5.0",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      //   const Spacer(),
                      Text(
                          '${AppLocalizations.of(context)!.basedOnReviews(reviews.length)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : reviews.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                '${AppLocalizations.of(context)!.noReviewsYet}',
                                style: TextStyle(fontSize: 16)),
                          )
                        : Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reviewsToShow,
                                itemBuilder: (context, index) {
                                  final review = reviews[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            review.fname,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            review.date,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 5),
                                          // Media files display - UPDATED PART
                                          if (review.filePath.isNotEmpty) ...[
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: review.filePath
                                                    .map<Widget>(
                                                      (path) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child:
                                                            _buildMediaWidget(
                                                                path,
                                                                context,
                                                                review
                                                                    .filePath),
                                                        //_buildMediaWidget(
                                                        //  path, context),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                          ],
                                          buildStarRating(
                                              int.parse(review.rating)),
                                          const SizedBox(height: 5),
                                          Text(
                                            review.message,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (reviews.length > 4)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (visibleReviewCount + 4 <
                                          reviews.length) {
                                        visibleReviewCount += 4;
                                      } else if (visibleReviewCount <
                                          reviews.length) {
                                        visibleReviewCount =
                                            reviews.length; // show all
                                      } else {
                                        visibleReviewCount =
                                            4; // reset to initial
                                      }
                                    });
                                  },
                                  child: Text(
                                    visibleReviewCount >= reviews.length
                                        ? '${AppLocalizations.of(context)!.showLess}'
                                        : '${AppLocalizations.of(context)!.readMore}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.green),
                                  ),
                                ),
                              const SizedBox(height: 10),
                            ],
                          ),
              ],
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

// Widget for displaying video thumbnail with play button
class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final double height;
  final double width;

  const VideoThumbnailWidget({
    Key? key,
    required this.videoUrl,
    this.height = 150,
    this.width = 150,
  }) : super(key: key);

  @override
  _VideoThumbnailWidgetState createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      _controller = VideoPlayerController.network(widget.videoUrl);
      await _controller!.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Video initialization error: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: widget.height,
        width: widget.width,
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red),
            Text('Video Error', style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        height: widget.height,
        width: widget.width,
        color: Colors.grey[300],
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () {
        // Navigate to full-screen video player or show video dialog
        _showVideoDialog(context);
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 300,
          child: VideoPlayerWidget(videoUrl: widget.videoUrl),
        ),
      ),
    );
  }
}

// Full video player widget
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller!.value.isInitialized
        ? Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
              VideoProgressIndicator(_controller!, allowScrubbing: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                      });
                    },
                    icon: Icon(
                      _controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}

// Add this new widget class for the image slider
class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageSlider({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Image.network(
                  'https://ambrosiaayurved.in/${widget.imageUrls[index]}',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.imageUrls.length, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.white : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// Update the _CustomerReviewSectionState class:

// Replace the _showImageDialog method with this:
void _showImageSlider(
    BuildContext context, List<String> imageUrls, int initialIndex) {
  showDialog(
    context: context,
    builder: (context) => ImageSlider(
      imageUrls: imageUrls,
      initialIndex: initialIndex,
    ),
  );
}
