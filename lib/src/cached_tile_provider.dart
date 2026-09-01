import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_provider/path_provider.dart';

/// A tile provider that uses cached_network_image for caching tile images
class CachedTileProvider extends TileProvider {
  CachedTileProvider({
    this.maxHeight = 256,
    this.maxWidth = 256,
    this.cacheKey,
    super.headers,
  });

  static const cacheDirectoryName = 'tile_cache';
  static const maxCachedTiles = 1000;
  static const cacheStalePeriod = Duration(days: 30);

  /// Tiles are cached apart from the default image cache so that map panning
  /// cannot evict the images the rest of the app is showing
  static final cacheManager = _TileCacheManager();

  final int? maxHeight;
  final int? maxWidth;
  final String? cacheKey;

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return CachedNetworkImageProvider(
      getTileUrl(coordinates, options),
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      headers: headers,
      cacheKey: cacheKey,
      cacheManager: cacheManager,
    );
  }

  /// Clear all cached tiles from memory and disk
  static Future<void> clearCache() async {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    try {
      await cacheManager.emptyCache();
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
      final tileCacheDir = Directory('${cacheDir.path}/$cacheDirectoryName');

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

class _TileCacheManager extends CacheManager with ImageCacheManager {
  _TileCacheManager()
      : super(
          Config(
            CachedTileProvider.cacheDirectoryName,
            stalePeriod: CachedTileProvider.cacheStalePeriod,
            maxNrOfCacheObjects: CachedTileProvider.maxCachedTiles,
          ),
        );
}
