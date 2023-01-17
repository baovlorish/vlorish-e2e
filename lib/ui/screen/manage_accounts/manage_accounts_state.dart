import 'package:burgundy_budgeting_app/ui/model/account_group.dart';
import 'package:equatable/equatable.dart';

abstract class ManageAccountsState extends Equatable {
  const ManageAccountsState();
}

class ManageAccountsInitial extends ManageAccountsState {
  ManageAccountsInitial();

  @override
  List<Object> get props => [];
}

class ManageAccountsLoading extends ManageAccountsState {
  ManageAccountsLoading();

  @override
  List<Object> get props => [];
}

class ManageAccountsLoaded extends ManageAccountsState {
  final List<AccountGroup> accountGroupList;
  ManageAccountsLoaded(this.accountGroupList,
     );

  @override
  List<Object> get props => [accountGroupList];
}

class ManageAccountsError extends ManageAccountsState {
  final String error;

  ManageAccountsError(this.error);

  @override
  List<Object> get props => [error];
}
