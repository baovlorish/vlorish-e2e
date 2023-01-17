class ChangeBankAccountMuteModeRequest {
  final String bankAccountId;
  final bool isMuted;

  const ChangeBankAccountMuteModeRequest(
      {required this.bankAccountId, required this.isMuted});

  Map<String, dynamic>? toJson() {
    return {
      'bankAccountId': bankAccountId,
      'isMuted': isMuted,
    };
  }
}
