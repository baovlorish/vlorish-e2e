import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'home_screen_menu_state.dart';

class HomeScreenMenuCubit extends Cubit<HomeScreenMenuState>
    with HydratedMixin {
  HomeScreenMenuCubit()
      : super(HomeScreenMenuState(
          isMenuExpanded: true,
          firstItemExpanded: true,
        )) {
    hydrate();
  }

  @override
  HomeScreenMenuState? fromJson(Map<String, dynamic> json) {
    if (json['isMenuExpanded'] != null && json['firstItemExpanded'] != null) {
      return HomeScreenMenuState(
        isMenuExpanded: json['isMenuExpanded'],
        firstItemExpanded: json['firstItemExpanded'],
      );
    }
  }

  @override
  Map<String, dynamic>? toJson(HomeScreenMenuState state) {
    return state.toJson();
  }

  void toggleIsMenuExpanded(bool isMenuExpanded) {
    emit(HomeScreenMenuState(
      isMenuExpanded: isMenuExpanded,
      firstItemExpanded: state.firstItemExpanded,
    ));
  }

  void toggleFirstItem(bool firstItemExpanded) {
    emit(HomeScreenMenuState(
      isMenuExpanded: state.isMenuExpanded,
      firstItemExpanded: firstItemExpanded,
    ));
  }
}
