## 3.3.12

- **FIX**: Circle radius animation now animates from current value to new value instead of from 0
- **IMPROVE**: Smoother transition between different radius values

## 3.3.11

- **NEW**: Add smooth animation when max distance circle radius changes
- **IMPROVE**: Circle radius animates from 0 to target value with easeInOut curve
- **IMPROVE**: Animation duration set to 800ms for smooth visual feedback

## 3.3.10

- **FIX**: Remove default Cairo position when trackMyPosition is false
- **FIX**: Make initPosition nullable to prevent showing any location by default
- **FIX**: Prevent onLocationChanged from being called when no initial position is set

## 3.3.9

- **FIX**: Add comprehensive mounted checks to prevent deactivated widget ancestor errors
- **IMPROVE**: Better dispose handling with focus cleanup and timer cancellation

## 3.3.8

- **FIX**: Add Material widget wrapper around distance FAB to support Hero animations

## 3.3.7

- **NEW**: Add onMaxDistanceTap callback to handle distance FAB tap events

## 3.3.6

- **FIX**: Add Material widget wrapper around distance FAB to support Hero animations

## 3.3.5

- **REFACTOR**: Move distance indicator FAB to join other controller buttons in the same column layout
- **IMPROVE**: Remove separate positioned widget for better code organization

## 3.3.4

- **FIX**: Move distance indicator FAB to left side and adjust position to avoid overlap with change location button

## 3.3.3

- **CHANGE**: Move distance indicator to bottom-right corner as FloatingActionButton for better UX

## 3.3.2

- **NEW**: Add distance indicator in top-left corner showing current max distance in kilometers
- **IMPROVE**: Better performance by using CircleMarker instead of polygon with many points

## 3.3.1

- **FIX**: Replace polygon with CircleMarker using meters for perfect circular shape

## 3.3.0

- **IMPROVE**: Increase polygon points to 720 (2 per degree) for ultra-smooth circular shape

## 3.2.9

- **IMPROVE**: Increase polygon points from 64 to 360 for a perfectly smooth circular shape

## 3.2.8

- **FIX**: Add validation to prevent RangeError when building max distance circle with invalid values

## 3.2.7

- **FIX**: Handle MapController not ready exception when building max distance circle

## 3.2.6

- **FIX**: Make max distance circle follow camera center instead of initial position

## 3.2.5

- **FIX**: Correct circle shape by properly accounting for latitude-dependent longitude degrees to prevent oval distortion

## 3.2.4

- **FIX**: Replace CircleMarker with Polygon to create more accurate distance circles using geographic coordinates

## 3.2.3

- **FIX**: Correct max distance circle calculation to use pixels instead of degrees, accounting for current zoom level

## 3.2.2

- **FIX**: Improve accuracy of max distance circle calculation by properly accounting for latitude-dependent longitude degrees

## 3.2.1

- **NEW**: Add `maxDistance` property to show a circle around the marker representing the user's maximum distance preference
- **NEW**: Add `maxDistanceCircleColor` property to customize the circle border color
- **NEW**: Add `maxDistanceCircleFillColor` property to customize the circle fill color with transparency

## 3.2.0

- **NEW**: Add `CachedTileProvider` that uses `cached_network_image` for better performance and offline support
- **NEW**: Map tiles are now automatically cached locally, reducing data usage and improving load times
- **NEW**: Support for offline viewing of previously loaded map areas
- **NEW**: Configurable cache options including max dimensions, HTTP headers, and custom cache keys
- **NEW**: Memory management utilities including cache size monitoring and cleanup methods
- **NEW**: Reduced default tile dimensions (256x256) for better memory efficiency
- **NEW**: Configurable cache size limits and age-based cleanup
- **BREAKING**: Default tile provider changed from `CancellableNetworkTileProvider` to `CachedTileProvider`

## 3.1.0

- Migrate from `Geolocator` to `Location` package.
- Fix initial location not being set when `initialLocation` is provided.
- Fix infinite loading screen when user location is turned off.
- Add `mapLayers` property to allow users to add custom layers to the map.
- Add `nominatimHost` property to allow users to change the default Nominatim host.
- Improve performance.
- Update dependencies

## 3.0.1

- Fix error of Geolocator.getServiceStatusStream() on web
- Update dependencies

## 3.0.0

- Fix `Buffer parameter must not be null` issue.
- Fix `onChanged` null value issue.
- Add `countryFilter` that allows filtering search results to specific countries

## 2.1.0

- Improve performance.
- Reduce tile loading durations (particularly on the web).
- Reduce users' (cellular) data and cache space consumption.

## 2.0.0

- Add `onchanged` function that returns `pickedData` when the user change marker location on map.
- Add `searchbarDebounceDuration` property.
- Upgrade flutter_map to 6.0.1.
- Remove subdomains from the default OSM URLs.
- Update other dependencies.

## 1.2.2

- SetLocationError handling
- Support more customizations for Select Location button Text
- Remove loading when the current location is changed.
- Remove SafeArea from map
- Added maxBounds
- Update dependencies

## 1.2.1

- Added OSM copyrights Badge
- Support more customizations for Select Location button and Search bar
- Update dependencies

## 1.2.0

- Add Current Location Pointer
- Update dependencies

## 1.1.5

- Improve Animations

## 1.1.4

- Fix error zoom buttons and locate me button not working

## 1.1.3

- Fix Ticker error
- Remove Address class
- Add Map `addressData` to `pickedData` response

## 1.1.2

- Add `road` property to `Address` class
- Add `suburb` property to `Address` class

## 1.1.1

- Fix issues with new flutter_map update
- Add `mapLoadingBackgroundColor` property

## 1.1.0

- Improve performance
- Support multiple languages using `mapLanguage`
- Make controls position directional
- Use default app styles and theming instead of explicit values
- Make all controls optional by adding `showSelectLocationButton` and `showSearchBar`
- Add a new class for Address with all address details
- Add `searchBarHintText` property
- Add `addressData` to `pickedData` response
- Add `onError` property and improve error handling
- **BREAKING CHANGES**
  - Replaced `mapIsLoading` with `loadingWidget`
  - Replaced `selectLocationButtonColor` with `selectLocationButtonStyle`

## 1.0.3

- Improve performance

## 1.0.2

- Fixed infinite loading screen when user location is turned off

## 1.0.1

- Fixed formatting issue of loading_widget

## 1.0.0

- Implemented and tested the whole plugin and make sure everything works correctly
