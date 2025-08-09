import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart' as marker;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'cached_tile_provider.dart';
import 'classes.dart';
import 'widgets/copyright_osm_widget.dart';
import 'widgets/wide_button.dart';

/// Principal widget to show Flutter map using osm api with pick up location marker and search bar.
/// you can track you current location, search for a location and select it.
/// navigate easily in the map to selecte location.

class FlutterLocationPicker extends StatefulWidget {
  /// [onPicked] : (callback) is trigger when you clicked on select location,return current [PickedData] of the Marker
  ///
  final void Function(PickedData pickedData) onPicked;

  /// [onChanged] : (callback) is trigger when you change marker location on map,return current [PickedData] of the Marker
  ///
  final void Function(PickedData pickedData)? onChanged;

  /// [onError] : (callback) is trigger when an error occurs while fetching location
  ///
  final void Function(Exception e)? onError;

  /// [initPosition] :(LatLong?) set the initial location of the pointer on the map
  ///
  final LatLong? initPosition;

  /// [urlTemplate] : (String) set the url template of the tile layer to get the data from the api (makes you apply your own style to the map) (default = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png')
  ///
  final String urlTemplate;

  /// [mapLanguage] : (String) set the language of the map and address text (default = 'en')
  ///
  final String mapLanguage;

  /// [nominatimHost] : (String) nominatim instance to use (default = 'nominatim.openstreetmap.org')
  ///
  final String nominatimHost;

  /// [nominatimAdditionalQueryParameters] : (Map<String,dynamic>) additional parameters to add to the nominatim query. Can also be used to override existing parameters (example: {'extratags': '1'}) (default = null)
  ///
  final Map<String, dynamic>? nominatimAdditionalQueryParameters;

  /// [nominatimZoomLevel] : (int?) zoom level to use in nominatim requests. If set to null will use zoom level corresponding to current map zoom level (example: 18) (default = null)
  ///
  final int? nominatimZoomLevel;

  /// [countryFilter] : (String) set the list of country codes to filter search results to them (example: 'eg,us') (default = null)
  ///
  final String? countryFilter;

  /// [selectLocationButtonText] : (String) set the text of the select location button (default = 'Set Current Location')
  ///
  final String selectLocationButtonText;

  /// [selectLocationButtonLeadingIcon] : (Widget) set the leading icon of the select location button
  ///
  final Widget? selectLocationButtonLeadingIcon;

  /// [initZoom] : (double) set initialized zoom in specific location  (default = 17)
  ///
  final double initZoom;

  /// [stepZoom] : (double) set default step zoom value (default = 1)
  ///
  final double stepZoom;

  /// [minZoomLevel] : (double) set default zoom value (default = 2)
  ///
  final double minZoomLevel;

  /// [maxZoomLevel] : (double) set default zoom value (default = 18.4)
  ///
  final double maxZoomLevel;

  /// [maxBounds] : (LatLngBounds?) set default max bounds of the map (default = null)
  ///
  final LatLngBounds? maxBounds;

  /// [loadingWidget] : (Widget) show custom  widget until the map finish initialization
  ///
  final Widget? loadingWidget;

  /// [trackMyPosition] : (bool) if is true, map will track your your location on the map initialization and makes inittial position of the pointer your current location (default = false)
  ///
  final bool trackMyPosition;

  /// [showCurrentLocationPointer] : (bool) if is true, your current location will be shown on the map (default = true)
  ///
  final bool showCurrentLocationPointer;

  /// [showZoomController] : (bool) enable/disable zoom in and zoom out buttons (default = true)
  ///
  final bool showZoomController;

  /// [showLocationController] : (bool) enable/disable locate me button (default = true)
  ///
  final bool showLocationController;

  /// [showSelectLocationButton] : (bool) enable/disable select location button (default = true)
  ///
  final bool showSelectLocationButton;

  /// [mapAnimationDuration] : (Duration) time duration of the move from point to point animation (default = Duration(milliseconds: 2000))
  ///
  final Duration mapAnimationDuration;

  /// [mapLoadingBackgroundColor] : (Color) change the background color of the loading screen before the map initialized
  ///
  final Color? mapLoadingBackgroundColor;

  /// [selectLocationButtonStyle] : (ButtonStyle) change the style of the select Location button
  ///
  final ButtonStyle? selectLocationButtonStyle;

  /// [selectLocationButtonWidth] : (double) change the width of the select Location button
  ///
  final double? selectLocationButtonWidth;

  /// [selectLocationButtonHeight] : (double) change the height of the select Location button
  ///
  final double? selectLocationButtonHeight;

  /// [selectedLocationButtonTextStyle] : set the style of the button text (default = TextStyle(fontSize: 20))
  ///
  final TextStyle selectedLocationButtonTextStyle;

  /// [selectLocationButtonPositionTop] : (double) change the top position of the select Location button (default = null)
  ///
  final double? selectLocationButtonPositionTop;

  /// [selectLocationButtonPositionRight] : (double) change the right position of the select Location button (default = 0)
  ///
  final double? selectLocationButtonPositionRight;

  /// [selectLocationButtonPositionLeft] : (double) change the left position of the select Location button (default = 0)
  ///
  final double? selectLocationButtonPositionLeft;

  /// [selectLocationButtonPositionBottom] : (double) change the bottom position of the select Location button (default = 3)
  ///
  final double? selectLocationButtonPositionBottom;

  /// [showSearchBar] : (bool) enable/disable search bar (default = true)
  ///
  final bool showSearchBar;

  /// [searchBarBackgroundColor] : (Color) change the background color of the search bar
  ///
  final Color? searchBarBackgroundColor;

  /// [searchBarTextColor] : (Color) change the color of the search bar text
  ///
  final Color? searchBarTextColor;

  /// [searchBarHintText] : (String) change the hint text of the search bar
  ///
  final String searchBarHintText;

  /// [searchBarHintColor] : (Color) change the color of the search bar hint text
  ///
  final Color? searchBarHintColor;

  /// [searchbarInputBorder] : (OutlineInputBorder) change the border of the search bar
  ///
  final OutlineInputBorder? searchbarInputBorder;

  /// [searchbarInputFocusBorder] : (OutlineInputBorder) change the border of the search bar when focused
  ///
  final OutlineInputBorder? searchbarInputFocusBorderp;

  /// [searchbarBorderRadius] : (BorderRadiusGeometry) change the border radius of the search bar
  ///
  final BorderRadiusGeometry? searchbarBorderRadius;

  /// [searchbarDebounceDuration] : (Duration) change the duration of search debounce
  ///
  final Duration? searchbarDebounceDuration;

  /// [zoomButtonsColor] : (Color) change the color of the zoom buttons icons
  ///
  final Color? zoomButtonsColor;

  /// [zoomButtonsBackgroundColor] : (Color) change the background color of the zoom buttons
  ///
  final Color? zoomButtonsBackgroundColor;

  /// [locationButtonsColor] : (Color) change the color of the location button icon
  ///
  final Color? locationButtonsColor;

  /// [locationButtonBackgroundColor] : (Color) change the background color of the location button
  ///
  final Color? locationButtonBackgroundColor;

  /// [markerIcon] : (IconData) change the marker icon of the map (default = Icon(icons.location_on, color: Colors.blue, size: 50))
  ///
  final Widget? markerIcon;

  /// [markerIconOffset] : (double) change the marker icon offset in y direction (default = 50.0)
  ///
  final double markerIconOffset;

  /// [showContributorBadgeForOSM] : (bool) for copyright of osm, we need to add badge in bottom of the map (default false)
  ///
  final bool showContributorBadgeForOSM;

  /// [contributorBadgeForOSMColor] : (Color) change the color of the badge (default Colors.grey[300])
  ///
  final Color? contributorBadgeForOSMColor;

  /// [contributorBadgeForOSMTextColor] : (Color) change the color of the badge text (default Colors.blue)
  ///
  final Color contributorBadgeForOSMTextColor;

  /// [contributorBadgeForOSMText] : (String) change the text of the badge (default 'OpenStreetMap contributors')
  ///
  final String contributorBadgeForOSMText;

  // [contributorBadgeForOSMPositionTop] : (double) change the position of the badge from top (default 0)
  ///
  final double? contributorBadgeForOSMPositionTop;

  /// [contributorBadgeForOSMPositionLeft] : (double) change the position of the badge from left (default null)
  ///
  final double? contributorBadgeForOSMPositionLeft;

  /// [contributorBadgeForOSMPositionRight] : (double) change the position of the badge from right (default 0)
  ///
  final double? contributorBadgeForOSMPositionRight;

  /// [contributorBadgeForOSMPositionBottom] : (double) change the position of the badge from bottom (default -6)
  ///
  final double? contributorBadgeForOSMPositionBottom;

  /// [mapLayers] : (List<Widget>) add custom layers to the map (default [])
  ///  example: [PolylineLayerWidget(polyline: Polyline(points: points, color: Colors.red))]
  final List<Widget> mapLayers;

  /// [maxDistance] : (double?) set the maximum distance in kilometers to show a circle around the marker (default = null)
  ///
  final double? maxDistance;

  /// [maxDistanceCircleColor] : (Color) change the color of the max distance circle border (default = Colors.blue)
  ///
  final Color maxDistanceCircleColor;

  /// [maxDistanceCircleFillColor] : (Color) change the fill color of the max distance circle (default = Colors.blue with 0.1 opacity)
  ///
  final Color maxDistanceCircleFillColor;

  /// [onMaxDistanceTap] : (VoidCallback?) callback when the max distance FAB is tapped
  ///
  final VoidCallback? onMaxDistanceTap;

  const FlutterLocationPicker({
    super.key,
    required this.onPicked,
    this.onChanged,
    this.selectedLocationButtonTextStyle = const TextStyle(fontSize: 20),
    this.onError,
    this.initPosition,
    this.stepZoom = 1,
    this.initZoom = 17,
    this.minZoomLevel = 2,
    this.maxZoomLevel = 18.4,
    this.maxBounds,
    this.urlTemplate = 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
    this.mapLanguage = 'en',
    this.nominatimHost = 'nominatim.openstreetmap.org',
    this.nominatimZoomLevel,
    this.nominatimAdditionalQueryParameters,
    this.countryFilter,
    this.selectLocationButtonText = 'Set Current Location',
    this.mapAnimationDuration = const Duration(milliseconds: 2000),
    this.trackMyPosition = false,
    this.showZoomController = true,
    this.showLocationController = true,
    this.showSelectLocationButton = true,
    this.showCurrentLocationPointer = true,
    this.selectLocationButtonStyle,
    this.selectLocationButtonWidth,
    this.selectLocationButtonHeight,
    this.selectLocationButtonPositionTop,
    this.selectLocationButtonPositionRight = 0,
    this.selectLocationButtonPositionLeft = 0,
    this.selectLocationButtonPositionBottom = 3,
    this.showSearchBar = true,
    this.searchBarBackgroundColor,
    this.searchBarTextColor,
    this.searchBarHintText = 'Search location',
    this.searchBarHintColor,
    this.searchbarInputBorder,
    this.searchbarInputFocusBorderp,
    this.searchbarBorderRadius,
    this.searchbarDebounceDuration,
    this.mapLoadingBackgroundColor,
    this.locationButtonBackgroundColor,
    this.zoomButtonsBackgroundColor,
    this.zoomButtonsColor,
    this.locationButtonsColor,
    this.markerIcon,
    this.markerIconOffset = 50.0,
    this.showContributorBadgeForOSM = false,
    this.contributorBadgeForOSMColor,
    this.contributorBadgeForOSMTextColor = Colors.blue,
    this.contributorBadgeForOSMText = 'OpenStreetMap contributors',
    this.contributorBadgeForOSMPositionTop,
    this.contributorBadgeForOSMPositionLeft,
    this.contributorBadgeForOSMPositionRight = 0,
    this.contributorBadgeForOSMPositionBottom = -6,
    this.mapLayers = const [],
    this.maxDistance,
    this.maxDistanceCircleColor = Colors.blue,
    this.maxDistanceCircleFillColor = const Color(0x1A0000FF), // Colors.blue with 0.1 opacity
    this.onMaxDistanceTap,
    Widget? loadingWidget,
    this.selectLocationButtonLeadingIcon,
  }) : loadingWidget = loadingWidget ?? const CircularProgressIndicator();

  @override
  State<FlutterLocationPicker> createState() => _FlutterLocationPickerState();
}

class _FlutterLocationPickerState extends State<FlutterLocationPicker>
    with TickerProviderStateMixin {
  /// Creating a new instance of the MapController class.
  MapController _mapController = MapController();

  // Create a animation controller that has a duration and a TickerProvider.
  late AnimationController _animationController;
  late AnimationController _radiusAnimationController;
  final TextEditingController _searchController = TextEditingController();
  final Location location = Location();
  final FocusNode _focusNode = FocusNode();
  List<OSMdata> _options = <OSMdata>[];
  LatLong? initPosition;
  Timer? _debounce;
  bool isLoading = true;
  bool isSearching = false;
  late void Function(Exception e) onError;
  late final String _userAgentId;
  double _previousRadius = 0.0;
  double _currentRadius = 0.0;

  /// It returns true if the text is RTL, false if it's LTR
  ///
  /// Args:
  ///   text (String): The text to be checked for RTL directionality.
  ///
  /// Returns:
  ///   A boolean value.
  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  Future<void> checkLocationPermission() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        const error = 'Location services are disabled.';
        throw Exception(error);
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        const error = 'Location permission denied';
        onError(Exception(error));
      }
    } else if (permissionGranted == PermissionStatus.deniedForever) {
      const error = 'Location permission denied forever';
      throw Exception(error);
    }
  }

  /// If location services are enabled, check if we have permissions to access the location. If we don't
  /// have permissions, request them. If we have permissions, return the current position
  ///
  /// Returns:
  ///   A Future<Position> object.
  Future<LocationData> _determinePosition() async {
    try {
      // Test if location services are enabled.
      await checkLocationPermission();
      return await location.getLocation();
    } catch (e) {
      rethrow;
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }

  /// Create a animation controller, add a listener to the controller, and
  /// then forward the controller with the new location
  ///
  /// Args:
  ///   destLocation (LatLng): The LatLng of the destination location.
  ///   destZoom (double): The zoom level you want to animate to.
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween =
        Tween<double>(begin: _mapController.camera.center.latitude, end: destLocation.latitude);
    final lngTween =
        Tween<double>(begin: _mapController.camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.camera.zoom, end: destZoom);
    // Create a animation controller that has a duration and a TickerProvider.
    if (mounted) {
      _animationController =
          AnimationController(vsync: this, duration: widget.mapAnimationDuration);
    }
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _animationController.addListener(() {
      _mapController.move(LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    if (mounted) {
      _animationController.forward();
    }
  }

  /// The function `onLocationChanged` updates the current position with the given latitude and
  /// longitude, then retrieves data and calls the `onChanged` callback with the retrieved value.
  ///
  /// Args:
  ///   latitude (double): The latitude parameter represents the current latitude coordinate of the
  /// location. It is a double value that specifies the north-south position on the Earth's surface.
  ///   longitude (double): The longitude parameter represents the current longitude coordinate of the
  /// location.
  ///  address (String): The address parameter represents the current address of the location.
  void onLocationChanged({required latLng, String? address}) {
    pickData(latLng).then(
      (PickedData pickedData) {
        if (widget.onChanged != null) widget.onChanged!(pickedData);
        // These two lines, and the onError callback below are the replacement =
        // for the entire setNameCurrentPos function.
        _searchController.text = address ?? pickedData.address;
        setState(() {});
      },
    ).onError<Exception>((error, stackTrace) {
      onError(error);
    });
  }

  /// It takes the pointer of the map and sends a request to the OpenStreetMap API to get the address of
  /// the pointer
  ///
  /// Returns:
  ///   A Future object that will eventually contain a PickedData object.
  Future<PickedData> pickData(LatLong center) async {
    var client = http.Client();
    // If zoom level is not explicitly set, use zoom level corresponding to current camera zoom, when possible
    int roundedZoom = widget.nominatimZoomLevel ??
        ((isLoading || _animationController.isAnimating)
            ? 18
            : min(_mapController.camera.zoom.round(), 18));
    // String url =
    //     'https://${widget.nominatimHost}/reverse?format=json&lat=${center.latitude}&lon=${center.longitude}&zoom=$roundedZoom&addressdetails=1&accept-language=${widget.mapLanguage}';
    // var uri = Uri.parse(url);
    Map<String, dynamic> queryParameters = {
      'format': 'json',
      'lat': center.latitude.toString(),
      'lon': center.longitude.toString(),
      'zoom': roundedZoom.toString(),
      'addressdetails': '1',
      'accept-language': widget.mapLanguage,
    };
    queryParameters.addAll(widget.nominatimAdditionalQueryParameters ?? {});
    var uri = Uri.https(widget.nominatimHost, '/reverse', queryParameters);
    var response = await client.get(
      uri,
      headers: {
        'User-Agent': 'DengaLoveApp/1.0.$_userAgentId (Denga Location Picker; contact@denga.app)',
        'Referer': 'https://denga.app',
      },
    );
    String displayName = "This Location is not accessible";
    Map decodedResponse;

    try {
      // Check if response is successful and content is JSON
      if (response.statusCode == 200) {
        String responseBody = response.body; // Use response.body instead of utf8.decode
        // Check if response starts with '{' (JSON) or '<' (HTML error)
        if (responseBody.trim().startsWith('{') || responseBody.trim().startsWith('[')) {
          decodedResponse = jsonDecode(responseBody);
        } else {
          // Response is HTML (likely blocked or error page)
          debugPrint(
              'Nominatim returned HTML instead of JSON: ${responseBody.substring(0, min(200, responseBody.length))}...');
          if (responseBody.toLowerCase().contains('access blocked')) {
            throw Exception(
                'Access blocked by Nominatim. Please wait before making more requests.');
          }
          return PickedData(center, displayName, {
            'display_name': displayName,
            'lat': center.latitude.toString(),
            'lon': center.longitude.toString(),
          }, {});
        }
      } else {
        debugPrint('Nominatim API error: ${response.statusCode} - ${response.reasonPhrase}');
        return PickedData(center, displayName, {
          'display_name': displayName,
          'lat': center.latitude.toString(),
          'lon': center.longitude.toString(),
        }, {});
      }
    } catch (e) {
      debugPrint('Error decoding Nominatim response: $e');
      return PickedData(center, displayName, {
        'display_name': displayName,
        'lat': center.latitude.toString(),
        'lon': center.longitude.toString(),
      }, {});
    }
    Map<String, dynamic> address;

    if (decodedResponse is Map<String, dynamic>) {
      if (decodedResponse['display_name'] != null) {
        displayName = decodedResponse['display_name'];
        address = decodedResponse['address'];
      } else {
        center = const LatLong(0, 0);
        address = decodedResponse;
      }
      return PickedData(center, displayName, address, decodedResponse);
    } else {
      return PickedData(const LatLong(0, 0), displayName, {}, decodedResponse);
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _mapController = MapController();
    _animationController = AnimationController(duration: widget.mapAnimationDuration, vsync: this);
    _radiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    onError = widget.onError ?? (e) => debugPrint(e.toString());

    // Generate unique user agent ID for this instance
    _userAgentId = Random().nextInt(999999).toString().padLeft(6, '0');

    /// Checking if the trackMyPosition is true or false. If it is true, it will get the current
    /// position of the user and set the initLate and initLong to the current position. If it is false,
    /// it will set the initLate and initLong to the [initPosition].latitude and
    /// [initPosition].longitude.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.initPosition != null) {
        initPosition = LatLong(widget.initPosition!.latitude, widget.initPosition!.longitude);
        onLocationChanged(latLng: initPosition);
        setState(() {
          isLoading = false;
        });
      }
    });

    if (widget.trackMyPosition) {
      _determinePosition().then((currentPosition) {
        if (mounted) {
          initPosition = LatLong(currentPosition.latitude!, currentPosition.longitude!);

          onLocationChanged(latLng: initPosition);
          _animatedMapMove(initPosition!.toLatLng(), 10);
          setState(
            () {
              isLoading = false;
            },
          );
        }
      }, onError: (e) => onError(e)).whenComplete(
        () {
          if (mounted) {
            setState(
              () {
                isLoading = false;
              },
            );
          }
        },
      );
    } else {
      // Don't call onLocationChanged if no initial position is set
      setState(() {
        isLoading = false;
      });
    }

    /// The above code is listening to the mapEventStream and when the mapEventMoveEnd event is
    /// triggered, it calls the setNameCurrentPos function.
    _mapController.mapEventStream.listen((event) async {
      if (event is MapEventMoveEnd) {
        LatLong center = LatLong(event.camera.center.latitude, event.camera.center.longitude);
        onLocationChanged(latLng: center);
      }
    });

    super.initState();
  }

  /// The dispose() function is called when the widget is removed from the widget tree and is used to
  /// clean up resources
  @override
  void dispose() {
    // Cancel any ongoing operations first
    _debounce?.cancel();
    _debounce = null;

    // Remove focus to prevent MediaQuery access issues
    _focusNode.unfocus();

    // Dispose controllers
    _mapController.dispose();
    _animationController.dispose();
    _radiusAnimationController.dispose();

    super.dispose();
  }

  Widget _buildListView() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: _buildCurrentState(),
    );
  }

  Widget _buildCurrentState() {
    // Loading state
    if (isSearching) {
      return Container(
        key: const ValueKey('loading'),
        height: 60,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.searchBarTextColor ?? const Color(0xFFEA751C),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (_options.isEmpty) {
      return Container(
        key: const ValueKey('empty'),
        child: const SizedBox.shrink(),
      );
    }

    // Results state
    return Container(
      key: const ValueKey('results'),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _options.length > 5 ? 5 : _options.length,
          itemBuilder: (context, index) {
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 200 + (index * 80)),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, (1 - value) * 15),
                  child: Transform.scale(
                    scale: (0.8 + (value * 0.2)).clamp(0.1, 2.0),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: index == 0 ? 8 : 0,
                  bottom: index == (_options.length > 5 ? 4 : _options.length - 1) ? 8 : 0,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    splashColor: (widget.searchBarTextColor ?? const Color(0xFFEA751C))
                        .withValues(alpha: 0.1),
                    highlightColor: (widget.searchBarTextColor ?? const Color(0xFFEA751C))
                        .withValues(alpha: 0.05),
                    onTap: () {
                      LatLong center = LatLong(_options[index].latitude, _options[index].longitude);
                      _animatedMapMove(center.toLatLng(), 5);
                      onLocationChanged(
                        latLng: center,
                        address: _options[index].displayname,
                      );
                      _focusNode.unfocus();
                      _options.clear();
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (widget.searchBarTextColor ?? const Color(0xFFEA751C))
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: widget.searchBarTextColor ?? const Color(0xFFEA751C),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _options[index].displayname,
                                  style: TextStyle(
                                    color: widget.searchBarTextColor ?? Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey.withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                        ),
                        // Separator line (except for last item)
                        if (index < (_options.length > 5 ? 4 : _options.length - 1))
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            color: Colors.grey.withValues(alpha: 0.1),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
    );
    OutlineInputBorder inputFocusBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
    );

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: widget.searchBarBackgroundColor ?? Theme.of(context).colorScheme.surface,
          borderRadius: widget.searchbarBorderRadius ?? BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            TextFormField(
              textDirection: isRTL(_searchController.text) ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyle(color: widget.searchBarTextColor),
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: widget.searchBarHintText,
                hintTextDirection:
                    isRTL(widget.searchBarHintText) ? TextDirection.rtl : TextDirection.ltr,
                border: widget.searchbarInputBorder ?? inputBorder,
                focusedBorder: widget.searchbarInputFocusBorderp ?? inputFocusBorder,
                hintStyle: TextStyle(color: widget.searchBarHintColor),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _options.clear();
                    isSearching = false;
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.clear,
                    color: widget.searchBarTextColor,
                  ),
                ),
              ),
              onChanged: (String value) {
                if (_debounce?.isActive ?? false) {
                  _debounce?.cancel();
                }
                setState(() {});
                _debounce = Timer(
                  widget.searchbarDebounceDuration ??
                      const Duration(milliseconds: 1000), // Increased to 1s to respect OSM policy
                  () async {
                    if (value.trim().isEmpty) {
                      setState(() {
                        _options.clear();
                        isSearching = false;
                      });
                      return;
                    }

                    setState(() => isSearching = true);
                    var client = http.Client();
                    try {
                      String url =
                          'https://${widget.nominatimHost}/search?q=$value&format=json&polygon_geojson=1&addressdetails=1&accept-language=${widget.mapLanguage}${widget.countryFilter != null ? '&countrycodes=${widget.countryFilter}' : ''}';
                      var response = await client.get(
                        Uri.parse(url),
                        headers: {
                          'User-Agent':
                              'DengaLoveApp/1.0.$_userAgentId (Denga Location Picker; contact@denga.app)',
                          'Referer': 'https://denga.app',
                        },
                      );
                      // Check if response is HTML (blocked) or JSON
                      String responseBody = response.body;
                      if (responseBody.trim().startsWith('<html') ||
                          responseBody.contains('Access blocked')) {
                        throw Exception(
                            'Access blocked by Nominatim. Please wait before making more requests.');
                      }

                      var decodedResponse = jsonDecode(responseBody) as List<dynamic>;
                      _options = decodedResponse
                          .map((e) => OSMdata(
                              displayname: e['display_name'],
                              latitude: double.parse(e['lat']),
                              longitude: double.parse(e['lon'])))
                          .toList();
                      setState(() => isSearching = false);
                    } on Exception catch (e) {
                      setState(() => isSearching = false);
                      if (e.toString().contains('Access blocked')) {
                        // Show user-friendly message for blocked access
                        debugPrint('Nominatim access blocked - please wait and try again');
                      }
                      onError(e);
                    } finally {
                      client.close();
                    }
                  },
                );
              },
            ),
            StatefulBuilder(
              builder: ((context, setState) {
                return _buildListView();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControllerButtons() {
    if (!mounted) return const SizedBox.shrink();

    return PositionedDirectional(
      bottom: 72,
      end: 16,
      child: Column(
        children: [
          if (widget.showZoomController)
            FloatingActionButton(
              heroTag: "btn1",
              shape: const CircleBorder(),
              backgroundColor: widget.zoomButtonsBackgroundColor,
              onPressed: () {
                if (mounted) {
                  _animatedMapMove(
                      _mapController.camera.center, _mapController.camera.zoom + widget.stepZoom);
                }
              },
              child: Icon(
                Icons.zoom_in,
                color: widget.zoomButtonsColor,
              ),
            ),
          const SizedBox(height: 16),
          if (widget.showZoomController)
            FloatingActionButton(
              heroTag: "btn2",
              shape: const CircleBorder(),
              backgroundColor: widget.zoomButtonsBackgroundColor,
              onPressed: () {
                if (mounted) {
                  _animatedMapMove(
                      _mapController.camera.center, _mapController.camera.zoom - widget.stepZoom);
                }
              },
              child: Icon(
                Icons.zoom_out,
                color: widget.zoomButtonsColor,
              ),
            ),
          const SizedBox(height: 22),
          if (widget.showLocationController)
            FloatingActionButton(
              heroTag: "btn3",
              backgroundColor: widget.locationButtonBackgroundColor,
              onPressed: () async {
                if (!mounted) return;

                // setState(() {
                //   isLoading = true;
                // });
                _determinePosition().then(
                  (currentPosition) {
                    if (mounted) {
                      LatLong center =
                          LatLong(currentPosition.latitude!, currentPosition.longitude!);
                      _animatedMapMove(center.toLatLng(), 5);
                      onLocationChanged(latLng: center);
                      setState(
                        () {
                          isLoading = false;
                        },
                      );
                    }
                  },
                  onError: (e) => onError(e),
                );
              },
              child: Icon(Icons.my_location, color: widget.locationButtonsColor),
            ),
          if (widget.maxDistance != null) ...[
            const SizedBox(height: 22),
            Material(
              color: Colors.transparent,
              child: FloatingActionButton(
                heroTag: "btn4",
                backgroundColor: widget.maxDistanceCircleColor,
                onPressed: widget.onMaxDistanceTap, // Callback when tapped
                child: Text(
                  '${widget.maxDistance!.round()} km',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Positioned.fill(
      child: FlutterMap(
        options: MapOptions(
          initialCenter:
              widget.initPosition?.toLatLng() ?? initPosition?.toLatLng() ?? const LatLng(0, 0),
          initialZoom: widget.initZoom,
          maxZoom: widget.maxZoomLevel,
          minZoom: widget.minZoomLevel,
          cameraConstraint: (widget.maxBounds != null
              ? CameraConstraint.contain(bounds: widget.maxBounds!)
              : const CameraConstraint.unconstrained()),
          backgroundColor: widget.mapLoadingBackgroundColor ?? const Color(0xFFF8FAFB),
          keepAlive: true,
        ),
        mapController: _mapController,
        children: [
          TileLayer(
            urlTemplate: widget.urlTemplate,
            subdomains: const ['a', 'b', 'c'],
            tileProvider: CachedTileProvider(),
            retinaMode: RetinaMode.isHighDensity(context),
          ),
          if (widget.showCurrentLocationPointer) _buildCurrentLocation(),
          if (widget.maxDistance != null) _buildMaxDistanceCircle(),
          ...widget.mapLayers,
        ],
      ),
    );
  }

  Widget _buildCurrentLocation() {
    return marker.CurrentLocationLayer(
      style: const marker.LocationMarkerStyle(
        markerDirection: marker.MarkerDirection.heading,
        headingSectorRadius: 60,
        markerSize: Size(18, 18),
      ),
    );
  }

  Widget _buildMaxDistanceCircle() {
    if (widget.maxDistance == null || widget.maxDistance! <= 0) return const SizedBox.shrink();
    if (!mounted) return const SizedBox.shrink();

    try {
      // Check if map controller is ready and widget is still mounted
      if (_mapController.camera.center.latitude == 0 &&
          _mapController.camera.center.longitude == 0) {
        return const SizedBox.shrink();
      }

      final center = _mapController.camera.center;

      // Convert kilometers to meters
      final radiusInMeters = widget.maxDistance! * 1000;

      // Start animation if radius changed
      if (_previousRadius != radiusInMeters) {
        _currentRadius = _previousRadius; // Store current radius as start point
        _previousRadius = radiusInMeters;
        if (mounted) {
          _radiusAnimationController.forward(from: 0.0);
        }
      }

      return AnimatedBuilder(
        animation: _radiusAnimationController,
        builder: (context, child) {
          // Create a smooth animation curve
          final curvedValue = Curves.easeInOut.transform(_radiusAnimationController.value);

          // Animate the radius from current value to the target value
          final animatedRadius = _currentRadius + (radiusInMeters - _currentRadius) * curvedValue;

          return CircleLayer(
            circles: [
              CircleMarker(
                point: center,
                radius: animatedRadius,
                color: widget.maxDistanceCircleFillColor,
                borderColor: widget.maxDistanceCircleColor,
                borderStrokeWidth: 2.0,
                useRadiusInMeter: true,
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Return empty widget if map controller is not ready or any other error
      return const SizedBox.shrink();
    }
  }

  Widget _buildMarker() {
    return Positioned.fill(
      bottom: widget.markerIconOffset,
      child: IgnorePointer(
        child: Center(
          child: widget.markerIcon ??
              const Icon(
                Icons.location_pin,
                color: Colors.blue,
                size: 50,
              ),
        ),
      ),
    );
  }

  Widget _buildSelectButton() {
    return Positioned(
      top: widget.selectLocationButtonPositionTop,
      bottom: widget.selectLocationButtonPositionBottom,
      left: widget.selectLocationButtonPositionLeft,
      right: widget.selectLocationButtonPositionRight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WideButton(
            widget.selectLocationButtonText,
            leadingIcon: widget.selectLocationButtonLeadingIcon,
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              LatLong center = LatLong(
                  _mapController.camera.center.latitude, _mapController.camera.center.longitude);
              pickData(center).then((value) {
                widget.onPicked(value);
              }, onError: (e) => onError(e)).whenComplete(
                () => setState(
                  () {
                    isLoading = false;
                  },
                ),
              );
            },
            style: widget.selectLocationButtonStyle,
            textStyle: widget.selectedLocationButtonTextStyle,
            width: widget.selectLocationButtonWidth,
            height: widget.selectLocationButtonHeight,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMap(),
        if (!isLoading) _buildMarker(),
        if (isLoading) Center(child: widget.loadingWidget!),
        SafeArea(
          child: Stack(
            children: [
              _buildControllerButtons(),
              if (widget.showSearchBar) _buildSearchBar(),
              if (widget.showContributorBadgeForOSM) ...[
                Positioned(
                  top: widget.contributorBadgeForOSMPositionTop,
                  bottom: widget.contributorBadgeForOSMPositionBottom,
                  left: widget.contributorBadgeForOSMPositionLeft,
                  right: widget.contributorBadgeForOSMPositionRight,
                  child: CopyrightOSMWidget(
                    badgeText: widget.contributorBadgeForOSMText,
                    badgeTextColor: widget.contributorBadgeForOSMTextColor,
                    badgeColor: widget.contributorBadgeForOSMColor,
                  ),
                ),
              ],
              if (widget.showSelectLocationButton) _buildSelectButton(),
            ],
          ),
        )
      ],
    );
  }
}
