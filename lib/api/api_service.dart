import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum RequestType { GET, POST, PUT, DELETE }

final api = ApiService('https://alkarim.mulia.or.id/api');

class ApiService {
  final String baseUrl;
  ApiService(this.baseUrl);

  Future<T> request<T>(
    String endpoint,
    RequestType type, {
    Map<String, dynamic>? body,
    String? token,
    required T Function(dynamic json) fromJson,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    http.Response res;
    switch (type) {
      case RequestType.GET:
        res = await http.get(url, headers: headers);
      case RequestType.POST:
        res = await http.post(url, headers: headers, body: jsonEncode(body));
      case RequestType.PUT:
        res = await http.put(url, headers: headers, body: jsonEncode(body));
      case RequestType.DELETE:
        res = await http.delete(url, headers: headers);
    }

    debugPrint('Status code: ${res.statusCode}');
    debugPrint('Response body: ${res.body}');

    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return fromJson(data);
    } else {
      final message = (data is Map && data['error'] != null) ? data['error'] : res.reasonPhrase;
      throw Exception('Error ${res.statusCode}: $message');
    }
  }

}