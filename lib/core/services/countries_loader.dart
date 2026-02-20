import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../data/model/country_state_city.dart';

/// Loads and parses countries.json asset. Parsing runs in a background isolate.
/// Result is cached for the app session.
class CountriesLoader {
  CountriesLoader._();

  static List<CountryModel>? _cached;

  /// Returns cached list if already loaded; otherwise loads asset and parses in compute.
  static Future<List<CountryModel>> loadCountries() async {
    if (_cached != null) return _cached!;
    final jsonString = await rootBundle.loadString('assets/json/countries.json');
    final list = await compute(_parseCountriesJson, jsonString);
    _cached = list;
    return list;
  }

  static List<CountryModel> _parseCountriesJson(String jsonString) {
    final list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Clear cache (e.g. for tests or memory pressure).
  static void clearCache() {
    _cached = null;
  }
}
