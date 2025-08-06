// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Location Picker',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Location Picker'),
        ),
        body: Column(
          children: [
            // Memory management controls
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final size = await CachedTileProvider.getCacheSizeFormatted();
                      print('Cache size: $size');
                    },
                    child: const Text('Check Cache Size'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await CachedTileProvider.clearCache();
                      print('Cache cleared');
                    },
                    child: const Text('Clear Cache'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await CachedTileProvider.cleanOldCache(maxAgeDays: 1);
                      print('Old cache cleaned');
                    },
                    child: const Text('Clean Old Cache'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FlutterLocationPicker(
                // Now uses CachedTileProvider by default for better performance and offline support
                initZoom: 11,
                minZoomLevel: 5,
                maxZoomLevel: 16,
                trackMyPosition: true,
                searchBarBackgroundColor: Colors.white,
                selectedLocationButtonTextStyle: const TextStyle(fontSize: 18),
                mapLanguage: 'en',
                onError: (e) => print(e),
                selectLocationButtonLeadingIcon: const Icon(Icons.check),
                onPicked: (pickedData) {
                  print(pickedData.latLong.latitude);
                  print(pickedData.latLong.longitude);
                  print(pickedData.address);
                  print(pickedData.addressData);
                },
                onChanged: (pickedData) {
                  print(pickedData.latLong.latitude);
                  print(pickedData.latLong.longitude);
                  print(pickedData.address);
                  print(pickedData.addressData);
                },
                showContributorBadgeForOSM: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
