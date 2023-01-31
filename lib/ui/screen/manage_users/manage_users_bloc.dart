import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/response/check_email.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/manage_users_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/model/requests_page_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_event.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';


class ManageUsersBloc extends Bloc<ManageUsersEvent, ManageUsersState> {
  final Logger logger = getLogger('ManageUsers Bloc');
  final String generalErrorMessage = 'Sorry, something went wrong';

  late final AuthRepository authRepository;
  final UserRepository userRepository;
  final ManageUsersRepository manageUsersRepository;
  final bool isAdvisorSubscription;

  ManageUsersBloc(
      this.authRepository, this.userRepository, this.manageUsersRepository,
      {required this.isAdvisorSubscription})
      : super(ManageUsersInitial()) {
    logger.i('Manage users page');
    add(ManageUsersInitialLoadingEvent());
  }

  Future<void> navigateToProfileOverview(BuildContext context) async {
    logger.i('navigate to Profile overview');
    NavigatorManager.navigateTo(
      context,
      ProfileOverviewPage.routeName,
      replace: true,
    );
  }

  Future<CheckEmailResponse> isUserRegistered(String email) async {
    return await authRepository.isRegistered(email);
  }

  @override
  Stream<ManageUsersState> mapEventToState(ManageUsersEvent event) async* {
    if (event is ManageUsersInitialLoadingEvent) {
      yield* initialLoadingEventToState(event);
    } else if (event is FetchInvitationsPageEvent) {
      yield* fetchInvitationsPageDataToState(event);
    } else if (event is FetchRequestsPageEvent) {
      yield* fetchRequestsPageDataToState(event);
    } else if (event is SendInviteEvent) {
      yield* sendInvitationThenUpdatePage(event);
    } else if (event is SendRequestEvent) {
      yield* sendRequestThenUpdatePage(event);
    } else if (event is ApproveEvent) {
      yield* approveItem(event);
    } else if (event is DeleteEvent) {
      yield* deleteItem(event);
    } else if (event is NoteEvent) {
      yield* sendNote(event);
    } else if (event is EditItemEvent) {
      yield* editItem(event);
    } else if (event is AcceptAccessTypeChangingEvent) {
      yield* acceptAccessTypeChanging(event);
    } else if (event is DeclineAccessTypeChangingEvent) {
      yield* declineAccessTypeChanging(event);
    }
  }

  Stream<ManageUsersState> fetchInvitationsPageDataToState(
    FetchInvitationsPageEvent event,
  ) async* {
    if (state is ManageUsersLoaded || event.previousLoadedState != null) {
      var loadedState = state is ManageUsersLoaded
          ? state as ManageUsersLoaded
          : event.previousLoadedState;
      try {
        var invitationsPageModel =
            await manageUsersRepository.fetchInvitationPage(
                event.pageNumber,
                event.invitationStatus ??
                    loadedState!.invitationsPageModel.invitationStatus);
        // logger.i('Manage Users invitationsPageModel $invitationsPageModel');
        yield ManageUsersLoaded(
            invitationsPageModel: invitationsPageModel,
            requestsPageModel: loadedState!.requestsPageModel);
      } catch (e) {
        yield ManageUsersError(e.toString());
        yield event.previousLoadedState!;
      }
    }
  }

  Stream<ManageUsersState> fetchRequestsPageDataToState(
      FetchRequestsPageEvent event) async* {
    if (state is ManageUsersLoaded || event.previousLoadedState != null) {
      var loadedState = state is ManageUsersLoaded
          ? state as ManageUsersLoaded
          : event.previousLoadedState;
      try {
        var requestsPageModel = await manageUsersRepository.fetchRequestsPage(
            event.pageNumber,
            event.requestsStatus ??
                loadedState!.requestsPageModel.requestsStatus);
        // logger.i('Manage Users requestsPageModel $requestsPageModel');
        yield ManageUsersLoaded(
            invitationsPageModel: loadedState!.invitationsPageModel,
            requestsPageModel: requestsPageModel,
            shouldUpdateUserData: event.shouldUpdateUserData);
      } catch (e) {
        yield ManageUsersError(e.toString());
        yield event.previousLoadedState!;
      }
    }
  }

  Stream<ManageUsersState> initialLoadingEventToState(
      ManageUsersInitialLoadingEvent event) async* {
    try {
      RequestsPageModel initialRequestsPageModel;

      if (isAdvisorSubscription) {
        initialRequestsPageModel = await manageUsersRepository
            .fetchRequestsPage(event.pageNumber, event.requestsStatus);
      } else {
        initialRequestsPageModel = RequestsPageModel(
            pageCount: 0,
            pageNumber: 1,
            requests: [],
            hasRequestSlots: false,
            canRequestToday: false,
            requestsStatus: 1);
      } //event.pageNumber = 1,requestsStatus = 1
      // logger.i(
      //     'Manage Users initialLoadingEventToState ${initialRequestsPageModel.toString()} ');
      var initialInvitationsPageModel =
          await manageUsersRepository.fetchInvitationPage(event.pageNumber,
              event.invitationStatus); // event.invitationStatus = 1
      // logger.i(
      // 'Manage Users initialLoadingEventToState ${initialInvitationsPageModel.toString()}');
      yield ManageUsersLoaded(
          requestsPageModel: initialRequestsPageModel,
          invitationsPageModel: initialInvitationsPageModel);
    } catch (e) {
      yield ManageUsersError(e.toString());
      rethrow;
    }
  }

  Stream<ManageUsersState> sendInvitationThenUpdatePage(
      SendInviteEvent event) async* {
    var loadedState = state as ManageUsersLoaded;
    try {
      var isSuccessful = await manageUsersRepository.sendInvite(
          event.accessType, event.email, event.role, event.note);
      if (isSuccessful) {
        add(FetchInvitationsPageEvent(
            loadedState.invitationsPageModel.pageNumber,
            invitationStatus:
                loadedState.invitationsPageModel.invitationStatus));
        logger.i(
            'Manage Users send Invite {accessType : ${event.accessType},email: ${event.email},role: ${event.role},note: ${event.note}}');
      }
    } catch (e) {
      if (e is CustomException) {
        yield ManageUsersError(e.toString(), type: e.type, isInvitation: true);
      } else {
        yield ManageUsersError(e.toString());
      }
      yield loadedState;
      rethrow;
    }
  }

  Stream<ManageUsersState> sendRequestThenUpdatePage(
      SendRequestEvent event) async* {
    var loadedState = state as ManageUsersLoaded;
    try {
      var isSuccessful = await manageUsersRepository.sendRequest(
          event.accessType, event.email, event.note);
      if (isSuccessful) {
        add(FetchRequestsPageEvent(loadedState.requestsPageModel.pageNumber,
            requestsStatus: loadedState.requestsPageModel.requestsStatus));
      }
      logger.i(
          'Manage Users send Request {accessType : ${event.accessType},email: ${event.email},note: ${event.note}}');
    } catch (e) {
      if (e is CustomException) {
        yield ManageUsersError(e.toString(), type: e.type, isInvitation: false);
      } else {
        yield ManageUsersError(e.toString());
      }
      yield loadedState;
      rethrow;
    }
  }

  Stream<ManageUsersState> deleteItem(DeleteEvent event) async* {
    var loadedState = state as ManageUsersLoaded;
    try {
      var isSuccessful = event.model.sharingApplicationType == 1
          ? await manageUsersRepository.deleteInvitation(event.model.id)
          : await manageUsersRepository.deleteRequest(event.model.id);
      if (isSuccessful) {
        var pageNumber = event.model.isInvitation
            ? loadedState.invitationsPageModel.pageNumber
            : loadedState.requestsPageModel.pageNumber;

        var isLastItem = event.model.isInvitation
            ? loadedState.invitationsPageModel.invitations.length == 1
            : loadedState.requestsPageModel.requests.length == 1;

        logger.i(
            'delete ${event.model.isInvitation ? 'invitation' : 'request'} ${event.model.id}');

        if (isLastItem && pageNumber > 1) {
          logger.i('changed page from $pageNumber to ${pageNumber - 1}');
          pageNumber--;
        }

        if (event.model.isInvitation) {
          add(FetchInvitationsPageEvent(pageNumber,
              invitationStatus:
                  loadedState.invitationsPageModel.invitationStatus));
        } else {
          add(FetchRequestsPageEvent(pageNumber,
              requestsStatus: loadedState.requestsPageModel.requestsStatus,
              shouldUpdateUserData:
                  event.model.status == 2)); //when request status is approved
        }
      }
    } catch (e) {
      yield ManageUsersError(e.toString());
      yield loadedState;
      rethrow;
    }
  }

  Stream<ManageUsersState> sendNote(NoteEvent event) async* {
    var loadedState = state as ManageUsersLoaded;
    try {
      var isSuccessful = event.model.sharingApplicationType == 2
          ? await manageUsersRepository.noteRequest(
              event.model.id, event.model.note)
          : await manageUsersRepository.noteInvitation(
              event.model.id, event.model.note);
      if (isSuccessful) {
        logger.i(
            '${event.model.sharingApplicationType == 2 ? 'note Request' : 'note Invitation'}'
            '{Id : ${event.model.id}, note: ${event.model.note}');
      }
    } catch (e) {
      yield ManageUsersError(e.toString());
      yield loadedState;
      rethrow;
    }
  }

  Stream<ManageUsersState> approveItem(ApproveEvent event) async* {
    var loadedState = state as ManageUsersLoaded;

    try {
      var isSuccessful = event.model.sharingApplicationType == 1
          ? await manageUsersRepository.approveInvitation(event.model.id)
          : await manageUsersRepository.approveRequest(event.model.id);
      if (isSuccessful) {
        logger.i(
            'approve ${event.model.isInvitation ? 'invitation' : 'request'} ${event.model.id}');
        if (event.model.isInvitation) {
          add(FetchInvitationsPageEvent(
              loadedState.invitationsPageModel.pageNumber,
              invitationStatus:
                  loadedState.invitationsPageModel.invitationStatus));
        } else {
          add(FetchRequestsPageEvent(loadedState.requestsPageModel.pageNumber,
              requestsStatus: loadedState.requestsPageModel.requestsStatus,
              shouldUpdateUserData: true));
        }
      }
    } catch (e) {
      yield ManageUsersError(e.toString());
      yield loadedState;
      rethrow;
    }
  }

  Stream<ManageUsersState> acceptAccessTypeChanging(
      AcceptAccessTypeChangingEvent event) async* {
    var loadedState = state as ManageUsersLoaded;

    try {
      var isSuccessful = event.model.sharingApplicationType == 1
          ? await manageUsersRepository
              .acceptAccessTypeChangingInvitation(event.model.id)
          : await manageUsersRepository
              .acceptAccessTypeChangingRequest(event.model.id);
      if (isSuccessful) {
        logger.i(
            'accept Access Type Changing Request {requestId : ${event.model.id}}');
        add(FetchInvitationsPageEvent(
            loadedState.invitationsPageModel.pageNumber,
            invitationStatus:
                loadedState.invitationsPageModel.invitationStatus));
      }
    } catch (e) {
      yield ManageUsersError(e.toString());
      yield loadedState;
      rethrow;
    }
  }

  Stream<ManageUsersState> declineAccessTypeChanging(
      DeclineAccessTypeChangingEvent event) async* {
    var loadedState = state as ManageUsersLoaded;

    try {
      var isSuccessful = event.model.sharingApplicationType == 1
          ? await manageUsersRepository
              .declineAccessTypeChangingInvitation(event.model.id)
          : await manageUsersRepository
              .declineAccessTypeChangingRequest(event.model.id);
      if (isSuccessful) {
        logger.i(
            'decline Access Type Changing Request {requestId : ${event.model.id}}');
        add(FetchInvitationsPageEvent(
            loadedState.invitationsPageModel.pageNumber,
            invitationStatus:
                loadedState.invitationsPageModel.invitationStatus));
      }
    } catch (e) {
      yield ManageUsersError(e.toString());
      yield loadedState;
      rethrow;
    }
  }

  Stream<ManageUsersState> editItem(EditItemEvent event) async* {
    var loadedState = state as ManageUsersLoaded;
    try {
      var isSuccessful = event.model.sharingApplicationType == 2
          ? await manageUsersRepository.editRequest(
              event.model.id, event.accessType!, note: event.note)
          : event.model.status == 2
              ? await manageUsersRepository.invitationEditApproved(
                  event.model.id, event.accessType, event.note)
              : await manageUsersRepository.invitationEditPending(
                  event.role!, event.model.id, event.accessType, event.note);
      if (event.model.role != event.role) {
        add(event.model.isInvitation
            ? FetchInvitationsPageEvent(
                loadedState.invitationsPageModel.pageNumber,
                invitationStatus:
                    loadedState.invitationsPageModel.invitationStatus)
            : FetchRequestsPageEvent(loadedState.requestsPageModel.pageNumber,
                requestsStatus: loadedState.requestsPageModel.requestsStatus));
      }
      if (isSuccessful) {
        logger.i(
            'edit ${event.model.sharingApplicationType == 2 ? 'editRequest' : event.model.status == 2 ? 'invitationEditApproved' : 'invitationEditPending'}} {id: ${event.model.id}, accessType: ${event.accessType}, note: ${event.note}');
      }
    } catch (e) {
      if (e is CustomException) {
        yield ManageUsersError(e.toString(),
            type: e.type, isInvitation: event.model.isInvitation);
      } else {
        yield ManageUsersError(e.toString());
      }
      add(event.model.isInvitation
          ? FetchInvitationsPageEvent(
              loadedState.invitationsPageModel.pageNumber,
              invitationStatus:
                  loadedState.invitationsPageModel.invitationStatus,
              previousLoadedState: loadedState)
          : FetchRequestsPageEvent(loadedState.requestsPageModel.pageNumber,
              requestsStatus: loadedState.requestsPageModel.requestsStatus,
              previousLoadedState: loadedState));

      rethrow;
    }
  }

  void startForeignSession(String id, int accessType, String? firstName,
      String? lastName, BuildContext context) {
    userRepository.startForeignSession(id, accessType, firstName, lastName);
    NavigatorManager.navigateTo(
      context,
      BudgetPersonalPage.routeName,
    );
  }
}
