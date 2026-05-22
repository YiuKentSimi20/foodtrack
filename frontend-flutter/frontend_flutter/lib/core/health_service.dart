import 'package:health/health.dart';

class HealthConnectService {

  final Health health = Health();

  final types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  HealthConnectService() {
    health.configure();
  }

  Future<List<Map<String, dynamic>>> syncHistoricalData({int daysBack = 30}) async {

    bool requested = await health.requestAuthorization(types);

    if (!requested) {
      print("Permisiuni refuzate de utilizator.");
      return [];
    }

    final now = DateTime.now();
    final past = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysBack));

    try {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: types,
        startTime: past,
        endTime: now,
      );

      Map<String, Map<String, dynamic>> dailySummary = {};

      for (var data in healthData) {
        String dateKey = "${data.dateFrom.year}-${data.dateFrom.month.toString().padLeft(2, '0')}-${data.dateFrom.day.toString().padLeft(2, '0')}";

        if (!dailySummary.containsKey(dateKey)) {
          dailySummary[dateKey] = {
            "data_activitate": dateKey,
            "numar_pasi": 0,
            "calorii_arse": 0.0
          };
        }

        if (data.type == HealthDataType.STEPS) {
          dailySummary[dateKey]!["numar_pasi"] += (data.value as NumericHealthValue).numericValue.toInt();
        } else if (data.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
          dailySummary[dateKey]!["calorii_arse"] += (data.value as NumericHealthValue).numericValue.toDouble();
        }
      }

      List<Map<String, dynamic>> payload = dailySummary.values.toList();

      return payload;

    } catch (e) {
      return [];
    }
  }
}