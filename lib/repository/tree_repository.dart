import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/asset.dart';
import '../model/location.dart';

abstract class ITreeRepository {
  Future<List<Location>> fetchLocations(final String companyId);

  Future<List<Asset>> fetchAssets(final String companyId);
}

class TractianApiTreeRepository implements ITreeRepository {
  final String baseUrl = 'https://fake-api.tractian.com';

  @override
  Future<List<Location>> fetchLocations(final String companyId) async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/companies/$companyId/locations'),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load locations');
    }

    final List<dynamic> jsonResponse = json.decode(response.body);

    return jsonResponse.map<Location>(Location.fromJson).toList();
  }

  @override
  Future<List<Asset>> fetchAssets(final String companyId) async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/companies/$companyId/assets'),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load assets');
    }

    final List<dynamic> jsonResponse = json.decode(response.body);

    return jsonResponse.map<Asset>(Asset.fromJson).toList();
  }
}
