# location_picker_flutter_map

A Flutter package that provides Place search and Location picker for flutter maps with a lot of customizations using Open Street Map.

[![Get the library](https://img.shields.io/badge/Get%20library-pub-blue)](https://pub.dev/packages/location_picker_flutter_map) &nbsp; [![Example](https://img.shields.io/badge/Example-Ex-success)](https://pub.dev/packages/location_picker_flutter_map/example)

## Features

- Pick location from map
- Show current location pointer on map
- Search location by places
- Show/Hide controllers, buttons and searchBar
- Use custom map style
- Easy to use
- **NEW**: Cached tile provider for better performance and offline support

## Getting Started

<img src="https://user-images.githubusercontent.com/25803558/186015160-ac89e47e-374d-42fb-b0d7-35ce660726d0.png" width="300" height="600" />

## Setup

To add the location_picker_flutter_map to your Flutter application read the instructions. Below are some Android and iOS specifics that are required for the package to work correctly.

<details>
<summary>Android</summary>
  
**Upgrade pre 1.12 Android projects**
  
Since version 5.0.0 this plugin is implemented using the Flutter 1.12 Android plugin APIs. Unfortunately this means App developers also need to migrate their Apps to support the new Android infrastructure. You can do so by following the [Upgrading pre 1.12 Android projects](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects) migration guide. Failing to do so might result in unexpected behaviour.

**AndroidX**

The location_picker_flutter_map plugin requires the AndroidX version of the Android Support Libraries. This means you need to make sure your Android project supports AndroidX. Detailed instructions can be found [here](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility).

The TL;DR version is:

1. Add the following to your "gradle.properties" file:

```
android.useAndroidX=true
android.enableJetifier=true
```

2. Make sure you set the `compileSdkVersion` in your "android/app/build.gradle" file:

```
android {
  compileSdkVersion 33

  ...
}
```

3. Make sure you set the `minSdkVersion` in your "android/app/build.gradle" file:

```
android {
  minSdkVersion 23

  ...
}
```

4. Make sure you replace all the `android.` dependencies to their AndroidX counterparts (a full list can be found here: [Migrating to AndroidX](https://developer.android.com/jetpack/androidx/migrate)).

**Permissions**

On Android you'll need to add either the `ACCESS_COARSE_LOCATION` or the `ACCESS_FINE_LOCATION` permission to your Android Manifest. To do so open the AndroidManifest.xml file (located under android/app/src/main) and add one of the following two lines as direct children of the `<manifest>` tag (when you configure both permissions the `ACCESS_FINE_LOCATION` will be used by the location_picker_flutter_map plugin):

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

> **NOTE:** Specifying the `ACCESS_COARSE_LOCATION` permission results in location updates with an accuracy approximately equivalent to a city block. It might take a long time (minutes) before you will get your first locations fix as `ACCESS_COARSE_LOCATION` will only use the network services to calculate the position of the device. More information can be found [here](https://developer.android.com/training/location/retrieve-current#permissions).

</details>

<details>
<summary>iOS</summary>

On iOS you'll need to add the following entries to your Info.plist file (located under ios/Runner) in order to access the device's location. Simply open your Info.plist file and add the following (make sure you update the description so it is meaningful in the context of your App):

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
```

If you would like to receive updates when your App is in the background, you'll also need to add the Background Modes capability to your XCode project (Project > Signing and Capabilities > "+ Capability" button) and select Location Updates. Be careful with this, you will need to explain in detail to Apple why your App needs this when submitting your App to the AppStore. If Apple isn't satisfied with the explanation your App will be rejected.

When using the `requestTemporaryFullAccuracy({purposeKey: "YourPurposeKey"})` method, a dictionary should be added to the Info.plist file.

```xml
<key>NSLocationTemporaryUsageDescriptionDictionary</key>
<dict>
  <key>YourPurposeKey</key>
  <string>The example App requires temporary access to the device&apos;s precise location.</string>
</dict>
```

The second key (in this example called `YourPurposeKey`) should match the purposeKey that is passed in the `requestTemporaryFullAccuracy()` method. It is possible to define multiple keys for different features in your app. More information can be found in Apple's [documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationtemporaryusagedescriptiondictionary).

> NOTE: the first time requesting temporary full accuracy access it might take several seconds for the pop-up to show. This is due to the fact that iOS is determining the exact user location which may take several seconds. Unfortunately this is out of our hands.

</details>

<details>
<summary>macOS</summary>

On macOS you'll need to add the following entries to your Info.plist file (located under macOS/Runner) in order to access the device's location. Simply open your Info.plist file and add the following (make sure you update the description so it is meaningful in the context of your App):

```xml
<key>NSLocationUsageDescription</key>
<string>This app needs access to location.</string>
```

You will also have to add the following entry to the DebugProfile.entitlements and Release.entitlements files. This will declare that your App wants to make use of the device's location services and adds it to the list in the "System Preferences" -> "Security & Privacy" -> "Privacy" settings.

```xml
<key>com.apple.security.personal-information.location</key>
<true/>
```

When using the `requestTemporaryFullAccuracy({purposeKey: "YourPurposeKey"})` method, a dictionary should be added to the Info.plist file.

```xml
<key>NSLocationTemporaryUsageDescriptionDictionary</key>
<dict>
  <key>YourPurposeKey</key>
  <string>The example App requires temporary access to the device&apos;s precise location.</string>
</dict>
```

The second key (in this example called `YourPurposeKey`) should match the purposeKey that is passed in the `requestTemporaryFullAccuracy()` method. It is possible to define multiple keys for different features in your app. More information can be found in Apple's [documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationtemporaryusagedescriptiondictionary).

> NOTE: the first time requesting temporary full accuracy access it might take several seconds for the pop-up to show. This is due to the fact that macOS is determining the exact user location which may take several seconds. Unfortunately this is out of our hands.

</details>

## Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
      location_picker_flutter_map: ^3.1.0

## Simple Usage

Import the following package in your dart file

```dart
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
```

To use is simple, just call the widget bellow. You need to pass the onPicked method to get the picked position from the map.

    FlutterLocationPicker(
            initZoom: 11,
            minZoomLevel: 5,
            maxZoomLevel: 16,
            trackMyPosition: true,
            onPicked: (pickedData) {
            })

# Then Usage

Now if you press Set Current Location button, you will get the pinned location by onPicked method.

Or you can use onChanged method to get the picked data whenever user change marker location on map.

The onPicked and onChanged methods return pickedData.

pickedData has three properties.

1. latLong
2. address `//String address`
3. addressData `//Map<String, dynamic> contains address details`

latLong has two more properties.

1. latitude
2. longitude

For example

    FlutterLocationPicker(
            initPosition: LatLong(23, 89),
            selectLocationButtonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
            selectLocationButtonText: 'Set Current Location',
            selectLocationButtonLeadingIcon: const Icon(Icons.check),
            initZoom: 11,
            minZoomLevel: 5,
            maxZoomLevel: 16,
            trackMyPosition: true,
            onError: (e) => print(e),
            onPicked: (pickedData) {
              print(pickedData.latLong.latitude);
              print(pickedData.latLong.longitude);
              print(pickedData.address);
              print(pickedData.addressData['country']);
            },
            onChanged: (pickedData) {
              print(pickedData.latLong.latitude);
              print(pickedData.latLong.longitude);
              print(pickedData.address);
              print(pickedData.addressData);
            })

You can get latitude, longitude, address and addressData like that.

# Cached Tile Provider

The package now includes a `CachedTileProvider` that uses `cached_network_image` for better performance and offline support. This provider automatically caches map tiles locally, reducing data usage and improving load times for previously viewed areas.

## Benefits

- **Offline Support**: Previously viewed map areas remain accessible without internet
- **Faster Loading**: Cached tiles load instantly
- **Reduced Data Usage**: Tiles are only downloaded once
- **Better User Experience**: Smoother map navigation

## Usage

The `CachedTileProvider` is used by default in the `FlutterLocationPicker`. You can also use it directly with `flutter_map`:

```dart
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:flutter_map/flutter_map.dart';

// Using with flutter_map directly
TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  subdomains: const ['a', 'b', 'c'],
  tileProvider: CachedTileProvider(
    maxHeight: 256,
    maxWidth: 256,
    maxCacheSize: 50,
    maxCacheAge: const Duration(days: 3),
    httpHeaders: {'User-Agent': 'YourApp/1.0'},
    cacheKey: 'custom_cache_key',
  ),
)
```

## Configuration Options

- `maxHeight` / `maxWidth`: Maximum dimensions for cached images (default: 256)
- `httpHeaders`: Custom HTTP headers for tile requests
- `cacheKey`: Custom cache key for the tile provider
- `maxCacheSize`: Maximum number of cached objects (default: 100)
- `maxCacheAge`: Maximum age of cached files (default: 7 days)
- `enableMemoryCache`: Enable memory cache (default: true)
- `enableDiskCache`: Enable disk cache (default: true)

## Memory Management

The `CachedTileProvider` includes several methods to help manage memory usage:

```dart
// Clear all cached tiles
await CachedTileProvider.clearCache();

// Get cache size in bytes
int size = await CachedTileProvider.getCacheSize();

// Get cache size in human readable format
String sizeFormatted = await CachedTileProvider.getCacheSizeFormatted();

// Clean old cache files (older than 7 days by default)
await CachedTileProvider.cleanOldCache(maxAgeDays: 7);

// Clean old cache using provider's maxCacheAge
final provider = CachedTileProvider(maxCacheAge: Duration(days: 3));
await CachedTileProvider.cleanOldCache(provider: provider);

// Set memory cache size limit
CachedTileProvider.setMemoryCacheSize(50);

// Get current memory cache size
int currentSize = CachedTileProvider.getMemoryCacheSize();

// Get memory cache size limit
int limit = CachedTileProvider.getMemoryCacheSizeLimit();
```

### Memory Optimization Tips

1. **Reduce tile dimensions**: Use smaller `maxHeight` and `maxWidth` values
2. **Limit cache size**: Set a reasonable `maxCacheSize` based on your app's needs
3. **Set cache expiration**: Use `maxCacheAge` to automatically expire old tiles
4. **Clean old cache**: Regularly call `cleanOldCache()` to remove old tiles
5. **Monitor usage**: Use `getCacheSizeFormatted()` to monitor cache growth
6. **Disable when needed**: Set `enableMemoryCache: false` for low-memory devices

### Cache Expiration (maxCacheAge)

The `maxCacheAge` parameter controls how long tiles stay in cache before being automatically removed:

```dart
// Cache expires in 1 day (good for frequently updated maps)
CachedTileProvider(maxCacheAge: Duration(days: 1))

// Cache expires in 7 days (default - good balance)
CachedTileProvider(maxCacheAge: Duration(days: 7))

// Cache expires in 30 days (good for static maps)
CachedTileProvider(maxCacheAge: Duration(days: 30))

// Cache expires in 12 hours (very aggressive cleanup)
CachedTileProvider(maxCacheAge: Duration(hours: 12))
```

**When to use different expiration times:**

- **Short expiration (1-3 days)**: Maps that change frequently, apps with limited storage
- **Medium expiration (7 days)**: Standard use case, good balance of performance and storage
- **Long expiration (30+ days)**: Static maps, offline-first apps, areas that rarely change

# Custom Map Style

You can apply themes to your map using [Map Tiler](https://www.maptiler.com/)

Head to the website and sign up then choose the map tile you want

Get the Maptile Url like this

```
  https://api.maptiler.com/maps/hybrid/{z}/{x}/{y}.jpg?{apikey}
```

use it in the urlTemplate parameter.

```dart
FlutterLocationPicker(
    urlTemplate:
        'https://api.maptiler.com/maps/hybrid/{z}/{x}/{y}.jpg?key={apikey}',
    )
```

Example:

<img src="https://user-images.githubusercontent.com/25803558/186025531-8e57f941-56d2-4413-8931-1841b437e740.png" width="300" height="600" />

&nbsp;

## Contributing

Pull requests are welcome. For major changes, please open an [issue](https://github.com/Michael-M-aher/location_picker_flutter_map/issues) first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Author

👤 **Michael Maher**

- Twitter: [@Michael\_\_\_Maher](https://twitter.com/Michael___Maher)
- Github: [@Michael-M-aher](https://github.com/Michael-M-aher)

## Show your support

Please ⭐️ this repository if this project helped you!

<a href="https://www.buymeacoffee.com/michael.maher" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="60px" width="200" ></a>

## 📝 License

Copyright © 2022 [Michael Maher](https://github.com/Michael-M-aher).<br />
This project is [MIT](https://github.com/Michael-M-aher/location_picker_flutter_map/blob/main/LICENSE) licensed.
