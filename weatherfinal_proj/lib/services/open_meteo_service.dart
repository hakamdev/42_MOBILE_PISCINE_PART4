import 'package:open_meteo/open_meteo.dart';

class OpenMeteoService {
  // Singleton stuff
  OpenMeteoService._();

  static final OpenMeteoService _instance = OpenMeteoService._();

  static OpenMeteoService get instance => _instance;

  final _weather = const WeatherApi();
  final _geocoding = const GeocodingApi();

  Future<List<Map<String, dynamic>>?> getGeo(String query) async {
    try {
      final result = await _geocoding.requestJson(
        name: query,
        count: 5,
      );
      return List<Map<String, dynamic>>.from(result["results"] ?? []);
    } catch (e) {
      if (e is OpenMeteoApiError) {
        print(e.reason);
      } else {
        print(e.toString());
      }
    }
    return null;
  }

  Future<ApiResponse<WeatherApi>?> getWeather(double lat, double lng) async {
    try {
      final result = await _weather.request(
        latitude: lat,
        longitude: lng,
        hourly: {
          WeatherHourly.temperature_2m,
          WeatherHourly.wind_speed_10m,
          WeatherHourly.rain,
          WeatherHourly.snowfall,
          WeatherHourly.showers,
          WeatherHourly.cloud_cover,
        },
        daily: {
          WeatherDaily.temperature_2m_max,
          WeatherDaily.temperature_2m_min,
          WeatherDaily.rain_sum,
          WeatherDaily.showers_sum,
          WeatherDaily.snowfall_sum,
          // WeatherDaily.sunshine_duration,
          WeatherDaily.wind_speed_10m_max
        },
        current: {
          WeatherCurrent.temperature_2m,
          WeatherCurrent.wind_speed_10m,
          WeatherCurrent.rain,
          WeatherCurrent.snowfall,
          WeatherCurrent.showers,
          WeatherCurrent.cloud_cover,
        },
        startDate: DateTime.now(),
        endDate: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 6,
        ),
      );
      return result;
    } catch (e) {
      if (e is OpenMeteoApiError) {
        print(e.reason);
      } else {
        print(e.toString());
      }
    }
    return null;
  }
}
