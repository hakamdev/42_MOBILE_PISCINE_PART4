import 'package:flutter/material.dart';
import 'package:open_meteo/open_meteo.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({
    super.key,
    required this.weatherData,
    required this.location,
    this.error,
  });

  final Map<String, dynamic> location;
  final Map weatherData;
  final String? error;

  String getWeatherDescription(
    num rain,
    num snowfall,
    num showers,
    num cloudCover,
    num windSpeed,
  ) {
    if (snowfall > 0) {
      return "Snowy";
    } else if (rain > 0 || showers > 0) {
      return "Rainy";
    } else if (cloudCover > 0) {
      return "Cloudy";
    } else if (windSpeed > 38) {
      return "Windy";
    } else {
      return "Clear";
    }
  }

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

  List<String> getTodayTemp() {
    final tempValues = weatherData[WeatherHourly.temperature_2m]?.values
            as Map<DateTime, num>? ??
        {};
    final windSpdValue = weatherData[WeatherHourly.wind_speed_10m]?.values
            as Map<DateTime, num>? ??
        {};
    final rainValue =
        weatherData[WeatherHourly.rain]?.values as Map<DateTime, num>? ?? {};
    final snowValue =
        weatherData[WeatherHourly.snowfall]?.values as Map<DateTime, num>? ??
            {};
    final showersValue =
        weatherData[WeatherHourly.showers]?.values as Map<DateTime, num>? ?? {};
    final cloudsValue =
        weatherData[WeatherHourly.cloud_cover]?.values as Map<DateTime, num>? ??
            {};

    final todayTemp = tempValues.entries.take(24).toList();
    final todayWindSpd = windSpdValue.entries.take(24).toList();
    final todayRain = rainValue.entries.take(24).toList();
    final todaySnow = snowValue.entries.take(24).toList();
    final todayShowers = showersValue.entries.take(24).toList();
    final todayClouds = cloudsValue.entries.take(24).toList();

    List<String> todayWeatherList = [];
    for (int i = 0; i < todayTemp.length; i++) {
      String item = "";
      final time =
          "${todayTemp[i].key.hour.toString().padLeft(2, "0")}:${todayTemp[i].key.minute.toString().padLeft(2, "0")}";
      item += time;
      final temp = "${(todayTemp[i].value as num?)?.toStringAsFixed(1)} ºC";
      item += "   $temp";
      if (i < todayWindSpd.length) {
        final windSpd =
            "${(todayWindSpd[i].value as num?)?.toStringAsFixed(1)} km/h";
        item += "   $windSpd";
      }

      if (i < todayRain.length &&
          i < todaySnow.length &&
          i < todayShowers.length &&
          i < todayClouds.length) {
        final desc = getWeatherDescription(
          todayRain[i].value,
          todaySnow[i].value,
          todayShowers[i].value,
          todayClouds[i].value,
          todayWindSpd[i].value,
        );
        item += "   $desc";
      }

      todayWeatherList.add(item);
    }
    return todayWeatherList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: error != null
            ? Text(
                error ?? "Error",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      // fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
              )
            : SingleChildScrollView(
                child: Column(
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
                      for (final item in getTodayTemp())
                        Text(
                          item,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                  ],
                ),
              ),
      ),
    );
  }
}
