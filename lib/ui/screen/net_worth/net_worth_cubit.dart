import 'package:burgundy_budgeting_app/domain/repository/networth_repository.dart';
import 'package:burgundy_budgeting_app/ui/model/net_worth_statistic_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/net_worth/net_worth_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class NetWorthCubit extends Cubit<NetWorthState> {
  final Logger logger = getLogger('NetWorthCubit');

  final NetWorthRepository repository;

  NetWorthCubit(this.repository) : super(NetWorthInitial()) {
    logger.i('Net WorthCubit Page');
    emit(NetWorthLoading());
    fetchNetWorth(DateTime.now().year);
  }

  Future<void> fetchNetWorth(
    int year,
  ) async {
    try {
      var model =
          await repository.fetchNetWorth(year);

      emit(NetWorthLoaded(
        netWorthModel: model,
        netWorthStatisticModel: NetWorthStatisticModel(
          totalDebts: model.totalDebts,
          totalAssets: model.totalAssets,
        ),
        isAssetsExpanded: state is NetWorthLoaded
            ? (state as NetWorthLoaded).isAssetsExpanded
            : true,
        isDebtsExpanded: state is NetWorthLoaded
            ? (state as NetWorthLoaded).isDebtsExpanded
            : true,
      ));
    } catch (e) {
      emit(NetWorthError(e.toString()));
      rethrow;
    }
  }

  Future<void> setNode({
    required String manualAccountId,
    required int amount,
    required DateTime monthYear,
    required bool isPersonal,
    required bool isAssets,
  }) async {
    if (state is NetWorthLoaded) {
      var loadedState = state as NetWorthLoaded;
      try {
        await repository.setNode(manualAccountId, amount, monthYear, isAssets);
        var updatedModel = loadedState.netWorthModel.copyWithNodeOrAccountName(
            accountId: manualAccountId,
            isPersonal: isPersonal,
            monthYear: monthYear,
            amount: amount,
            isAssets: isAssets);
        emit(NetWorthLoaded(
          netWorthModel: updatedModel,
          netWorthStatisticModel: NetWorthStatisticModel(
            totalDebts: updatedModel.totalDebts,
            totalAssets: updatedModel.totalAssets,
          ),
          isAssetsExpanded: loadedState.isAssetsExpanded,
          isDebtsExpanded: loadedState.isDebtsExpanded,
        ));
      } catch (e) {
        emit(NetWorthError(e.toString()));
        emit(loadedState);
        rethrow;
      }
    }
  }

  void toggleExpanded(bool value, {required bool isAssets}) {
    if (state is NetWorthLoaded) {
      emit(NetWorthLoaded(
        netWorthModel: (state as NetWorthLoaded).netWorthModel,
        netWorthStatisticModel:
            (state as NetWorthLoaded).netWorthStatisticModel,
        isAssetsExpanded:
            isAssets ? value : (state as NetWorthLoaded).isAssetsExpanded,
        isDebtsExpanded:
            !isAssets ? value : (state as NetWorthLoaded).isDebtsExpanded,
      ));
    }
  }

  Future<void> setAccountName(
      {required String id,
      required bool isPersonal,
      required String name,
      required bool isManual,
      required bool isAssets}) async {
    if (state is NetWorthLoaded) {
      var loadedState = state as NetWorthLoaded;
      try {
        if (isManual) {
          await repository.setManualAccountName(
            manualAccountId: id,
            name: name,
          );
        } else {
          await repository.setBankAccountName(
            bankAccountId: id,
            name: name,
          );
        }
        var updatedModel = loadedState.netWorthModel.copyWithNodeOrAccountName(
            accountId: id,
            name: name,
            isPersonal: isPersonal,
            isAssets: isAssets);
        emit(NetWorthLoaded(
          netWorthModel: updatedModel,
          netWorthStatisticModel: loadedState.netWorthStatisticModel,
          isAssetsExpanded: loadedState.isAssetsExpanded,
          isDebtsExpanded: loadedState.isDebtsExpanded,
        ));
      } catch (e) {
        emit(NetWorthError(e.toString()));
        emit(loadedState);
        rethrow;
      }
    }
  }
}
