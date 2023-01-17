import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_vlorish_score_service.dart';
import 'package:burgundy_budgeting_app/ui/model/vlorish_score_model.dart';

abstract class VlorishScoreRepository {
  Future<VlorishScoreModel> getLast();

  Future<void> refresh();
}

class VlorishScoreRepositoryImpl implements VlorishScoreRepository {
  final ApiVlorishScoreService _apiVlorishScoreService;
  final String generalErrorMessage = 'Sorry, something went wrong';

  VlorishScoreRepositoryImpl(this._apiVlorishScoreService);

  @override
  Future<VlorishScoreModel> getLast() async {
    var response = await _apiVlorishScoreService.getLast();

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return VlorishScoreModel.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> refresh() async {
    var response = await _apiVlorishScoreService.refresh();

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }
}
