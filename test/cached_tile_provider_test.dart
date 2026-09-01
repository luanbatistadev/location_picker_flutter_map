import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('resolves every url placeholder and carries the user agent', () {
    final provider = CachedTileProvider();
    final layer = TileLayer(
      urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
      subdomains: const ['a', 'b', 'c'],
      userAgentPackageName: 'com.denga',
      retinaMode: true,
      tileProvider: provider,
    );

    final url = provider.getTileUrl(const TileCoordinates(1, 2, 3), layer);

    expect(url, isNot(contains('{')));
    expect(url, 'https://a.basemaps.cartocdn.com/rastertiles/voyager/3/1/2@2x.png');
    expect(provider.headers['User-Agent'], 'flutter_map (com.denga)');
  });

  test('default tile layer needs no api key', () {
    final picker = FlutterLocationPicker(onPicked: (_) {});

    expect(picker.urlTemplate, 'https://tile.openstreetmap.org/{z}/{x}/{y}.png');
  });

  test('tiles cache in their own bucket, apart from the app image cache', () {
    expect(CachedTileProvider.cacheDirectoryName, 'tile_cache');
    expect(CachedTileProvider.cacheDirectoryName, isNot(DefaultCacheManager.key));
    expect(CachedTileProvider.maxCachedTiles, greaterThan(200));
  });

  test('cache manager supports resizing, as maxWidth/maxHeight require', () {
    expect(CachedTileProvider.cacheManager, isA<ImageCacheManager>());
  });
}
