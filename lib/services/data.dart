import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/mosque_model.dart';

class Data {
  Future<MosqueModel> fetchData(
      {double valueRadius, double longitude, double latitude, int page}) async {
    print('https://dev.prayer-now.com/api/v2/mosques?latitude=$latitude&longitude=$longitude&page=$page&limit=10&radius=$valueRadius');

    final response = await http.get(
        'https://dev.prayer-now.com/api/v2/mosques?latitude=$latitude&longitude=$longitude&page=$page&limit=10&radius=$valueRadius');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return MosqueModel.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
