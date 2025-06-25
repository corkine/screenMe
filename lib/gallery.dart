import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'api/gallery.dart';

int cacheMinute = 0;

class GalleryView extends ConsumerWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fg = ref.watch(getFaceGalleryProvider).value ?? FaceGallery();
    final (lastMinutes, need) = fg.needRefreshGalleryConfig;
    if (need && lastMinutes != cacheMinute) {
      debugPrint(
          "refreshing face gallery config due to ${fg.configRefreshMinutes}");
      cacheMinute = lastMinutes;
      ref.invalidate(getFaceGalleryProvider);
    }
    final image = fg.imageNow;
    return KeyedSubtree(
        key: ValueKey(image),
        child: image.isNotEmpty
            ? Stack(fit: StackFit.expand, children: [
                CachedNetworkImage(
                    imageUrl: image, cacheKey: image, fit: BoxFit.cover),
                BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                        color: Colors.black.withOpacity(fg.blurOpacity))),
                Positioned(
                    right: 10,
                    top: 10,
                    bottom: 10,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(fg.borderRadius),
                        child: CachedNetworkImage(
                            imageUrl: image,
                            cacheKey: image,
                            fit: BoxFit.fitWidth)))
              ]).animate().fadeIn()
            : const SizedBox());
  }
}
