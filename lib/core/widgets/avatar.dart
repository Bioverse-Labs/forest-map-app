import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? url;
  final Size size;
  final Widget? placeholderWidget;
  final Widget? errorWidget;
  final bool canEdit;

  const Avatar({
    Key? key,
    required this.url,
    this.size = const Size(140, 140),
    this.placeholderWidget,
    this.errorWidget,
    this.canEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return ImageContainer(
        size: size,
        child: Icon(
          canEdit ? Icons.add_a_photo_outlined : Icons.camera_alt_outlined,
          color: Colors.grey.shade400,
          size: 80,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url!,
      placeholder: (context, url) => ImageContainer(
        size: size,
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => ImageContainer(
        size: size,
        child: Icon(
          canEdit ? Icons.add_a_photo_outlined : Icons.camera_alt_outlined,
          size: 80,
          color: Colors.grey.shade400,
        ),
      ),
      imageBuilder: (_, imageProvider) => ImageContainer(
        size: size,
        imageProvider: imageProvider,
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final Widget? child;
  final Size? size;
  final ImageProvider? imageProvider;

  const ImageContainer({
    Key? key,
    this.child,
    this.size,
    this.imageProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size!.width,
      height: size!.height,
      decoration: BoxDecoration(
        image: imageProvider != null
            ? DecorationImage(image: imageProvider!, fit: BoxFit.cover)
            : null,
        color: Colors.white,
        borderRadius: BorderRadius.circular(size!.width / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
