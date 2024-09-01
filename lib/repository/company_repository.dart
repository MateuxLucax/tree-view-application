import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/company.dart';

abstract class ICompanyRepository {
  Future<List<Company>> fetchCompanies();
}

class TractianApiCompanyRepository implements ICompanyRepository {
  final String baseUrl = 'https://fake-api.tractian.com';

  @override
  Future<List<Company>> fetchCompanies() async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/companies'),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load companies');
    }

    final List<dynamic> jsonResponse = json.decode(response.body);

    return jsonResponse.map<Company>(Company.fromJson).toList();
  }
}
