import 'manage_users_item_model.dart';

abstract class ManageUsersPage {
  abstract final int pageCount;
  abstract final int pageNumber;
  abstract final List<ManageUsersItemModel> items;
}