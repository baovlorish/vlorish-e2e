import 'package:burgundy_budgeting_app/domain/model/response/net_worth_model.dart';
import 'package:burgundy_budgeting_app/ui/model/net_worth_statistic_model.dart';
import 'package:equatable/equatable.dart';

abstract class NetWorthState extends Equatable {
  const NetWorthState();
}

class NetWorthInitial extends NetWorthState {
  NetWorthInitial();

  @override
  List<Object> get props => [];
}

class NetWorthLoading extends NetWorthState {
  NetWorthLoading();

  @override
  List<Object> get props => [];
}

class NetWorthLoaded extends NetWorthState {
  final NetWorthModel netWorthModel;
  final NetWorthStatisticModel netWorthStatisticModel;

  final bool isAssetsExpanded;
  final bool isDebtsExpanded;

  NetWorthLoaded({
    required this.netWorthModel,
    required this.netWorthStatisticModel,
    required this.isAssetsExpanded,
    required this.isDebtsExpanded,
  });

  @override
  List<Object> get props => [
        netWorthModel,
        netWorthStatisticModel,
        isAssetsExpanded,
        isDebtsExpanded
      ];
}

class NetWorthError extends NetWorthState {
  final String error;

  NetWorthError(this.error);

  @override
  List<Object?> get props => [error];
}
