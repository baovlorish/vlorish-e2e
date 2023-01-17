import 'package:dio/dio.dart';

abstract class ApiReferralService {
  Future<Response> getReferrals();

  Future<Response> getReferralsSSO();
}
