import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService extends http.BaseClient {
  
  late final Map<String, String> _defaultHeaders;
  
  final http.Client _httpClient = http.Client();
  late String baseUrl;

  ApiService(headers,url){
    baseUrl = url;
    _defaultHeaders = headers;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _httpClient.send(request);
  }

  @override
  Future<http.Response> get(url, { Map<String, String>? headers }) async{
    return await _httpClient.get(Uri.parse('$baseUrl/$url'), headers: _mergedHeaders(headers));
  }

  @override
  Future<http.Response> post(url, {Map<String, String>? headers, dynamic body, Encoding ? encoding}) {
    print(body);
    return _httpClient.post(Uri.parse(baseUrl + url.toString()), headers: _mergedHeaders(headers), body: jsonEncode(body), encoding: encoding);
  }

  @override
  Future<http.Response> patch(url, {Map<String, String>? headers, dynamic body, Encoding ? encoding}) {
    return _httpClient.patch(Uri.parse(baseUrl + url.toString()), headers: _mergedHeaders(headers), body: body,);
  }

  @override
  Future<http.Response> put(url, {Map<String, String>? headers, dynamic body, Encoding ? encoding}) {
    return _httpClient.put(Uri.parse(baseUrl + url.toString()), headers: _mergedHeaders(headers), body: body, encoding: encoding);
  }

  @override
  Future<http.Response> head(url, {Map<String, String>? headers}) {
    return _httpClient.head(Uri.parse(baseUrl + url.toString()), headers: _mergedHeaders(headers));
  }

  // @override
  // Future<http.Response> delete(url, { Map<String, String>? headers, Encoding ? encoding}) {
  //   return _httpClient.delete(Uri.parse(baseUrl + url.toString()), headers: _mergedHeaders(headers), encoding: encoding);
  // }

  Map<String, String> _mergedHeaders(Map<String, String> ? headers) {
    if( headers != null){
      _defaultHeaders.addAll(headers);
    }
    return _defaultHeaders;
  }

}