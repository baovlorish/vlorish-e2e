import 'package:equatable/equatable.dart';

abstract class EducationCenterState extends Equatable {
  abstract final int tab;

  const EducationCenterState();
}

class EducationCenterInitial extends EducationCenterState {
  @override
  final int tab;

  EducationCenterInitial(this.tab);

  @override
  List<Object> get props => [tab];
}
