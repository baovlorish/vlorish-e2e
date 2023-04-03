import 'dart:convert';

import 'package:burgundy_budgeting_app/domain/network/api_client.dart';
import 'package:burgundy_budgeting_app/domain/service/session_manager.dart';
import 'package:dio/dio.dart';

class HttpManager {
  final SessionManager sessionManager;
  late final Dio baseDio;

  HttpManager(this.sessionManager) {
    baseDio = Dio();
    dio.options.baseUrl = ApiClient.BASE_URL + '/api';
    dio.options.connectTimeout = 20000;
    dio.options.receiveTimeout = 20000;
    dio.options.responseType = ResponseType.json;
    dio.interceptors.add(sessionManager);
  }

  Dio get dioCitySearch {
    var dioCitySearch = Dio();
    dioCitySearch.options.baseUrl = ApiClient.ENV_GEO_CREDENTIALS['ApiUrl']!;
    dioCitySearch.options.connectTimeout = 20000;
    dioCitySearch.options.receiveTimeout = 20000;
    dioCitySearch.options.responseType = ResponseType.json;
    return dioCitySearch;
  }

  Dio get dioSupport {
    var dioSupport = Dio();
    dioSupport.options.baseUrl = 'https://vlorish.zendesk.com/api/v2';
    var username = 'farah@vlorish.com';
    var token = 'grsssHFrgb5A39wX4l4U96pSGDjQfc85X4PE6pvY';
    var basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username/token:$token'));
    dioSupport.options.connectTimeout = 20000;
    dioSupport.options.receiveTimeout = 20000;
    dioSupport.options.headers['authorization'] = basicAuth;
    dioSupport.options.responseType = ResponseType.json;
    return dioSupport;
  }

  Dio get dio => baseDio;
}
