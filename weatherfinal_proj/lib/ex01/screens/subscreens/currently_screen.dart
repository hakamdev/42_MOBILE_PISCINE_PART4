import 'package:flutter/material.dart';
import 'package:open_meteo/open_meteo.dart';

class CurrentlyScreen extends StatelessWidget {
  const CurrentlyScreen({
    super.key,
    required this.weatherData,
    required this.location,
    this.error,
  });

  final Map<String, dynamic> location;
  final Map weatherData;
  final String? error;

  String getLocationString() {
    String locStr = "";
    locStr += (location["name"] ?? "Getting location...");
    if (location["admin1"] != null) {
      locStr += "\n${location["admin1"]}";
    }
    if (location["country"] != null) {
      locStr += "\n${location["country"]}";
    }
    return locStr;
  }

  String getCurrentWindSpeed() {
    final value = weatherData[WeatherCurrent.wind_speed_10m]?.value ?? {};
    return "${(value as num?)?.toStringAsFixed(1) ?? "N/A"} km/h";
  }

  String getCurrentTemp() {
    final value = weatherData[WeatherCurrent.temperature_2m]?.value;
    return "${(value as num?)?.toStringAsFixed(1) ?? "N/A"} ºC";
  }

  String getCurrentDescription() {
    final r = weatherData[WeatherCurrent.rain]?.value;
    final s = weatherData[WeatherCurrent.snowfall]?.value;
    final sh = weatherData[WeatherCurrent.showers]?.value;
    final c = weatherData[WeatherCurrent.cloud_cover]?.value;
    final w = weatherData[WeatherCurrent.wind_speed_10m]?.value;

    if (s > 0) {
      return "Snowy";
    } else if (r > 0 || sh > 0) {
      return "Rainy";
    } else if (c > 0) {
      return "Cloudy";
    } else if (w > 38) {
      return "Windy";
    } else {
      return "Clear";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: error != null
            ? Text(
                error ?? "Error",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.error,
                    ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getLocationString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                  ),
                  if (location.isNotEmpty) const SizedBox(height: 16),
                  if (location.isNotEmpty)
                    Text(
                      weatherData.isEmpty
                          ? "Getting Weather..."
                          : "${getCurrentTemp()}\n${getCurrentWindSpeed()}\n${getCurrentDescription()}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                ],
              ),
      ),
    );
  }
}
