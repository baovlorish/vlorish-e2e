import 'package:intl/intl.dart';

class MemoNoteModel {
  final String id;
  final String? transactionId;
  final DateTime? creationDate;
  final double? transactionAmount;
  final String note;
  final bool isTransaction;
  final bool isGoal;
  final DateTime monthYear;
  final String authorUserId;
  final String? authorFirstName;
  final String? authorLastName;
  final String? authorImageUrl;
  final List<MemoNoteModel> replies;
  final bool isReply;
  final bool canShowMore;
  final bool canAddReply;

  MemoNoteModel({
    required this.id,
    required this.transactionId,
    required this.note,
    required this.isTransaction,
    required this.isGoal,
    required this.authorUserId,
    required this.authorFirstName,
    required this.authorLastName,
    required this.authorImageUrl,
    this.creationDate,
    this.transactionAmount,
    required this.isReply,
    required this.replies,
    required this.monthYear,
    required this.canShowMore,
    required this.canAddReply,
  });

  factory MemoNoteModel.fromJson(
      Map<String, dynamic> json, bool isGoal, DateTime monthYear) {
    var replies = <MemoNoteModel>[];
    var firstReply;
    if (json['firstReply'] != null) {
      firstReply = MemoNoteModel(
        id: json['firstReply']['id'],
        transactionId: json['firstReply']['transactionId'],
        note: json['firstReply']['note'],
        isTransaction: json['isTransaction'],
        monthYear: monthYear,
        isGoal: isGoal,
        creationDate: (json['firstReply']['creationDate'] != null)
            ? DateFormat('yyyy-MM-ddTHH:mm:ss')
                .parse(json['firstReply']['creationDate'], true)
            : null,
        authorImageUrl: json['firstReply']['authorImageUrl'],
        authorUserId: json['firstReply']['authorUserId'],
        authorLastName: json['firstReply']['authorLastName'],
        authorFirstName: json['firstReply']['authorFirstName'],
        replies: [],
        isReply: true,
        canAddReply: false,
        canShowMore: false,
      );
      replies.add(firstReply);
    } else if (json['replies'] != null) {
      for (var reply in json['replies']) {
        replies.add(MemoNoteModel(
          id: reply['id'],
          transactionId: reply['transactionId'],
          note: reply['note'],
          isTransaction: json['isTransaction'],
          monthYear: monthYear,
          isGoal: isGoal,
          creationDate: (reply['creationDate'] != null)
              ? DateFormat('yyyy-MM-ddTHH:mm:ss')
                  .parse(reply['creationDate'], true)
              : null,
          authorImageUrl: reply['authorImageUrl'],
          authorUserId: reply['authorUserId'],
          authorLastName: reply['authorLastName'],
          authorFirstName: reply['authorFirstName'],
          replies: [],
          isReply: true,
          canAddReply: false,
          canShowMore: false,
        ));
      }
    }
    return MemoNoteModel(
      id: json['id'],
      transactionId: json['transactionId'],
      note: json['note'],
      isTransaction: json['isTransaction'],
      monthYear: monthYear,
      isGoal: isGoal,
      creationDate: (json['creationDate'] != null)
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').parse(json['creationDate'], true)
          : null,
      transactionAmount: json['transactionAmount'],
      authorImageUrl: json['authorImageUrl'],
      authorUserId: json['authorUserId'],
      authorLastName: json['authorLastName'],
      authorFirstName: json['authorFirstName'],
      replies: replies,
      isReply: false,
      canAddReply: json['canAddReply'] ?? replies.length < 3,
      canShowMore: json['canShowMore'] ?? replies.length > 1,
    );
  }

  factory MemoNoteModel.fromTransactionJson(
    Map<String, dynamic> json,
  ) {
    var replies = <MemoNoteModel>[];
    var firstReply;
    if (json['firstReply'] != null) {
      firstReply = MemoNoteModel(
        id: json['firstReply']['id'],
        transactionId: json['firstReply']['transactionId'],
        note: json['firstReply']['note'],
        isTransaction: true,
        monthYear: DateTime.now(),
        isGoal: false,
        creationDate: (json['firstReply']['creationDate'] != null)
            ? DateFormat('yyyy-MM-ddTHH:mm:ss')
                .parse(json['firstReply']['creationDate'], true)
            : null,
        authorImageUrl: json['firstReply']['authorImageUrl'],
        authorUserId: json['firstReply']['authorUserId'],
        authorLastName: json['firstReply']['authorLastName'],
        authorFirstName: json['firstReply']['authorFirstName'],
        replies: [],
        isReply: true,
        canAddReply: false,
        canShowMore: false,
      );
      replies.add(firstReply);
    } else if (json['replies'] != null) {
      for (var reply in json['replies']) {
        replies.add(MemoNoteModel(
          id: reply['id'],
          transactionId: reply['transactionId'],
          note: reply['note'],
          isTransaction: true,
          monthYear: DateTime.now(),
          isGoal: false,
          creationDate: (reply['creationDate'] != null)
              ? DateFormat('yyyy-MM-ddTHH:mm:ss')
                  .parse(reply['creationDate'], true)
              : null,
          authorImageUrl: reply['authorImageUrl'],
          authorUserId: reply['authorUserId'],
          authorLastName: reply['authorLastName'],
          authorFirstName: reply['authorFirstName'],
          replies: [],
          isReply: true,
          canAddReply: false,
          canShowMore: false,
        ));
      }
    }
    return MemoNoteModel(
      id: json['id'],
      transactionId: json['transactionId'],
      note: json['note'],
      isTransaction: true,
      monthYear: DateTime.now(),
      isGoal: false,
      creationDate: (json['creationDate'] != null)
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').parse(json['creationDate'], true)
          : null,
      transactionAmount: json['transactionAmount'],
      authorImageUrl: json['authorImageUrl'],
      authorUserId: json['authorUserId'],
      authorLastName: json['authorLastName'],
      authorFirstName: json['authorFirstName'],
      replies: replies,
      isReply: false,
      canAddReply: json['canAddReply'] ?? replies.length < 3,
      canShowMore: json['canShowMore'] ?? replies.length > 1,
    );
  }

  String get initials =>
      (authorFirstName?[0] ?? '') + (authorLastName?[0] ?? '');

  String get replyIdList {
    var result = '';
    replies.forEach((element) {
      result += element.id;
    });
    return result;
  }

  MemoNoteModel copyWith({
    String? id,
    String? note,
    bool? isTransaction,
    bool? isGoal,
    DateTime? monthYear,
    DateTime? creationDate,
    double? transactionAmount,
    List<MemoNoteModel>? replies,
  }) {
    var newReplies = replies ?? this.replies;
    return MemoNoteModel(
      id: id ?? this.id,
      transactionId: transactionId,
      note: note ?? this.note,
      isTransaction: isTransaction ?? this.isTransaction,
      isGoal: isGoal ?? this.isGoal,
      monthYear: monthYear ?? this.monthYear,
      creationDate: creationDate ?? this.creationDate,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      authorFirstName: authorFirstName,
      authorUserId: authorUserId,
      authorLastName: authorLastName,
      authorImageUrl: authorImageUrl,
      isReply: isReply,
      replies: newReplies,
      canAddReply: !isReply && newReplies.length < 3,
      canShowMore: !isReply && newReplies.length > 1,
    );
  }
}

class MemoNotesPage {
  final List<MemoNoteModel> notes;
  final bool canBeAdded;
  final bool isGoal;
  final DateTime monthYear;

  MemoNotesPage({
    required this.notes,
    required this.canBeAdded,
    required this.isGoal,
    required this.monthYear,
  });

  factory MemoNotesPage.fromJson(
      Map<String, dynamic> json, bool isGoal, DateTime monthYear) {
    var notes = <MemoNoteModel>[];
    if (json['notes'] != null) {
      for (var note in json['notes']) {
        notes.add(
          MemoNoteModel.fromJson(
            note,
            isGoal,
            monthYear,
          ),
        );
      }
    }
    return MemoNotesPage(
        notes: notes,
        canBeAdded: json['canNoteBeAdded'],
        isGoal: isGoal,
        monthYear: monthYear);
  }

  MemoNotesPage remove(MemoNoteModel item) {
    var updatedNotes = notes.where((element) => element.id != item.id).toList();
    return MemoNotesPage(
        notes: updatedNotes,
        canBeAdded: true,
        isGoal: isGoal,
        monthYear: monthYear);
  }

  factory MemoNotesPage.fromNotesList(
      {required List<MemoNoteModel> list,
      required bool isGoal,
      required DateTime monthYear}) {
    return MemoNotesPage(
        notes: list,
        canBeAdded:
            list.where((element) => element.isTransaction == false).isEmpty &&
                list.where((element) => element.isTransaction).length < 2,
        isGoal: isGoal,
        monthYear: monthYear);
  }

  factory MemoNotesPage.transaction(MemoNoteModel? note) {
    return MemoNotesPage(
        notes: note != null ? [note] : [],
        canBeAdded: note == null,
        isGoal: false,
        monthYear: DateTime.now());
  }
}
