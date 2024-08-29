import 'package:flutter/material.dart';
import 'package:open_meteo/open_meteo.dart';

class WeeklyScreen extends StatelessWidget {
  const WeeklyScreen({
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

  String getWeatherDescription(
      num rain, num snowfall, num showers, num windSpd) {
    if (snowfall > 0) {
      return "Snowy";
    } else if (rain > 0 || showers > 0) {
      return "Rainy";
    } else if (windSpd > 38) {
      return "Windy";
    } else {
      return "Clear";
    }
  }

  List<String> getTodayTemp() {
    final tempMinValues = weatherData[WeatherDaily.temperature_2m_min]?.values
            as Map<DateTime, num>? ??
        {};
    final tempMaxValues = weatherData[WeatherDaily.temperature_2m_max]?.values
            as Map<DateTime, num>? ??
        {};
    final rainValue =
        weatherData[WeatherDaily.rain_sum]?.values as Map<DateTime, num>? ?? {};
    final snowValue =
        weatherData[WeatherDaily.snowfall_sum]?.values as Map<DateTime, num>? ??
            {};
    final showersValue =
        weatherData[WeatherDaily.showers_sum]?.values as Map<DateTime, num>? ??
            {};
    final windSpdValue = weatherData[WeatherDaily.wind_speed_10m_max]?.values
            as Map<DateTime, num>? ??
        {};

    final todayMinTemp = tempMinValues.entries.take(24).toList();
    final todayMaxTemp = tempMaxValues.entries.take(24).toList();
    final todayRain = rainValue.entries.take(24).toList();
    final todaySnow = snowValue.entries.take(24).toList();
    final todayShowers = showersValue.entries.take(24).toList();
    final todayWindSpd = windSpdValue.entries.take(24).toList();

    List<String> todayWeatherList = [];
    for (int i = 0; i < todayMinTemp.length; i++) {
      String item = "";
      final date = todayMinTemp[i].key.toString().split(" ").first;
      item += date;
      final minTemp =
          "${(todayMinTemp[i].value as num?)?.toStringAsFixed(1)} ºC";
      item += "   $minTemp";
      if (i < todayMaxTemp.length) {
        final maxTemp =
            "${(todayMaxTemp[i].value as num?)?.toStringAsFixed(1)} ºC";
        item += "   $maxTemp";
      }

      if (i < todayRain.length &&
          i < todaySnow.length &&
          i < todayShowers.length &&
          i < todayWindSpd.length) {
        final desc = getWeatherDescription(
          todayRain[i].value,
          todaySnow[i].value,
          todayShowers[i].value,
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
