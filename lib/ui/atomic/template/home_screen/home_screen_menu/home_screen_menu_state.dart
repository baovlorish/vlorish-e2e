import 'package:equatable/equatable.dart';

class HomeScreenMenuState extends Equatable {
  final bool isMenuExpanded;
  final bool firstItemExpanded;

  HomeScreenMenuState({
    required this.isMenuExpanded,
    required this.firstItemExpanded,
  });

  @override
  List<Object> get props => [isMenuExpanded, firstItemExpanded];

  Map<String, dynamic>? toJson() {
    return {
      'isMenuExpanded': isMenuExpanded,
      'firstItemExpanded': firstItemExpanded,
    };
  }
}
