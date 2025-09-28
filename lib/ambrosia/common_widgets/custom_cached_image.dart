import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/shimmer_effect/shimmer_effect.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double? shimmerWidth;
  final double? shimmerHeight;
  final BorderRadius? borderRadius;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.shimmerWidth,
    this.shimmerHeight,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final shimmerW = shimmerWidth ?? width ?? 250.0;
    final shimmerH = shimmerHeight ?? height ?? 250.0;

    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          ShimmerEffect(width: shimmerW, height: shimmerH),
      errorWidget: (context, url, error) => const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 100,
      ),
      fit: fit,
      width: width,
      height: height,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
