import 'dart:convert';
import 'package:http/http.dart' as http;

class OSMService {
  Future<Map<String, String>> getAddressFromOSM(double lat, double lng) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&addressdetails=1';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent': 'com.mohdiop.m3fund',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final addr = data['address'];
      return {
        'city': addr['city'] ?? addr['town'] ?? addr['village'] ?? '',
        'region': addr['state'] ?? addr['city'] ?? '',
        'country': addr['country'] ?? '',
        'district':
            addr['village'] ?? addr['city_district'] ?? addr['suburb'] ?? '',
      };
    }

    throw Exception('Impossible de récupérer l’adresse OSM');
  }
}
