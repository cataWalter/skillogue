
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Country {
  String? country;

  Country(this.country);

  @override
  String toString() {
    return 'Country{country: $country}';
  }
}

Future<List<Country>> queryAllCountries() async {
  List<ParseObject> results = <ParseObject>[];
  final QueryBuilder<ParseObject> parseQuery =
      QueryBuilder<ParseObject>(ParseObject('Country'));
  //parseQuery.whereContains('att1', 'Walter');
  final ParseResponse apiResponse = await parseQuery.query();
  if (apiResponse.success && apiResponse.results != null) {
    results = apiResponse.results as List<ParseObject>;
  } else {
    results = [];
  }
  return countriesFromResults(results);
}

List<Country> countriesFromResults(List<ParseObject> results) {
  List<Country> newResults = <Country>[];
  for (var t in results) {
    newResults.add(countryFromJson(t));
  }
  return newResults;
}

Country countryFromJson(dynamic t) {
  return Country(
    t['country'] as String,
  );
}
