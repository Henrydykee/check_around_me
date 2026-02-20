/// Lightweight models for countries.json asset (country -> states -> cities).
class CountryModel {
  final int id;
  final String name;
  final String? iso2;
  final String? phonecode;
  final List<StateModel> states;

  const CountryModel({
    required this.id,
    required this.name,
    this.iso2,
    this.phonecode,
    required this.states,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final statesList = json['states'] as List<dynamic>? ?? [];
    final phonecodeValue = json['phonecode'];
    final phonecode = phonecodeValue != null 
        ? (phonecodeValue is String ? phonecodeValue : phonecodeValue.toString())
        : null;
    return CountryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      iso2: json['iso2'] as String?,
      phonecode: phonecode,
      states: statesList
          .map((e) => StateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StateModel {
  final int id;
  final String name;
  final List<CityModel> cities;

  const StateModel({
    required this.id,
    required this.name,
    required this.cities,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    final citiesList = json['cities'] as List<dynamic>? ?? [];
    return StateModel(
      id: json['id'] as int,
      name: json['name'] as String,
      cities: citiesList
          .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CityModel {
  final int id;
  final String name;

  const CityModel({required this.id, required this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
