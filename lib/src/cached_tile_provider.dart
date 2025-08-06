import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_provider/path_provider.dart';

/// A tile provider that uses cached_network_image for caching tile images
class CachedTileProvider extends TileProvider {
  CachedTileProvider({
    this.maxHeight = 256,
    this.maxWidth = 256,
    this.httpHeaders,
    this.cacheKey,
    this.maxCacheSize = 100,
    this.maxCacheAge = const Duration(days: 30),
    this.enableMemoryCache = true,
    this.enableDiskCache = true,
  });

  final int? maxHeight;
  final int? maxWidth;
  final Map<String, String>? httpHeaders;
  final String? cacheKey;
  final int maxCacheSize;
  final Duration maxCacheAge;
  final bool enableMemoryCache;
  final bool enableDiskCache;

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final url = options.urlTemplate!
        .replaceAll('{x}', coordinates.x.toString())
        .replaceAll('{y}', coordinates.y.toString())
        .replaceAll('{z}', coordinates.z.toString());

    if (options.subdomains.isNotEmpty) {
      final subdomain = options.subdomains[coordinates.x % options.subdomains.length];
      final subdomainIndex = url.indexOf('{s}');
      if (subdomainIndex != -1) {
        final urlWithSubdomain = url.replaceRange(subdomainIndex, subdomainIndex + 3, subdomain);
        return _createCachedImageProvider(urlWithSubdomain);
      }
    }

    return _createCachedImageProvider(url);
  }

  CachedNetworkImageProvider _createCachedImageProvider(String url) {
    return CachedNetworkImageProvider(
      url,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      headers: httpHeaders,
      cacheKey: cacheKey,
    );
  }

  /// Get the cache age in days for this provider
  int get cacheAgeInDays => maxCacheAge.inDays;

  Future<ui.Image> getImageFromProvider(
    ImageProvider provider,
    TileCoordinates coordinates,
    TileLayer options,
  ) async {
    try {
      final Completer<ui.Image> completer = Completer<ui.Image>();
      final ImageStream stream = provider.resolve(ImageConfiguration.empty);
      final ImageStreamListener listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          completer.complete(info.image);
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          completer.completeError(exception, stackTrace);
        },
      );
      stream.addListener(listener);
      return await completer.future;
    } catch (e) {
      // Fallback to a blank image if loading fails
      return await _createBlankImage();
    }
  }

  Future<ui.Image> _createBlankImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = const Color(0xFFF0F0F0);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 256, 256),
      paint,
    );
    final picture = recorder.endRecording();
    return await picture.toImage(256, 256);
  }

  /// Clear all cached tiles from memory and disk
  static Future<void> clearCache() async {
    // Clear memory cache
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    // Clear disk cache
    try {
      final cacheDir = await getTemporaryDirectory();
      final tileCacheDir = Directory('${cacheDir.path}/tile_cache');

      if (await tileCacheDir.exists()) {
        await tileCacheDir.delete(recursive: true);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing cache: $e');
      }
    }
  }

  /// Get cache size in bytes
  static Future<int> getCacheSize() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final tileCacheDir = Directory('${cacheDir.path}/tile_cache');

      if (await tileCacheDir.exists()) {
        int totalSize = 0;
        final files = tileCacheDir.listSync(recursive: true);

        for (final file in files) {
          if (file is File) {
            totalSize += await file.length();
          }
        }

        return totalSize;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting cache size: $e');
      }
    }

    return 0;
  }

  /// Get cache size in human readable format
  static Future<String> getCacheSizeFormatted() async {
    final sizeInBytes = await getCacheSize();

    if (sizeInBytes < 1024) {
      return '${sizeInBytes}B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)}KB';
    } else if (sizeInBytes < 1024 * 1024 * 1024) {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(sizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  /// Clean old cache files (older than specified days)
  /// If a provider instance is provided, uses its maxCacheAge
  static Future<void> cleanOldCache({int? maxAgeDays, CachedTileProvider? provider}) async {
    final days = maxAgeDays ?? provider?.cacheAgeInDays ?? 7;
    try {
      final cacheDir = await getTemporaryDirectory();
      final tileCacheDir = Directory('${cacheDir.path}/tile_cache');

      if (await tileCacheDir.exists()) {
        final files = tileCacheDir.listSync();
        final now = DateTime.now();

        for (final file in files) {
          if (file is File) {
            final stat = await file.stat();
            if (now.difference(stat.modified).inDays > days) {
              await file.delete();
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cleaning old cache: $e');
      }
    }
  }

  /// Set memory cache size limit
  static void setMemoryCacheSize(int size) {
    PaintingBinding.instance.imageCache.maximumSize = size;
  }

  /// Get current memory cache size
  static int getMemoryCacheSize() {
    return PaintingBinding.instance.imageCache.currentSize;
  }

  /// Get memory cache size limit
  static int getMemoryCacheSizeLimit() {
    return PaintingBinding.instance.imageCache.maximumSize;
  }
}
