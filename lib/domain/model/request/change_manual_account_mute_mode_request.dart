class ChangeManualAccountMuteModeRequest {
  final String bankAccountId;
  final bool isMuted;

  const ChangeManualAccountMuteModeRequest(
      {required this.bankAccountId, required this.isMuted});

  Map<String, dynamic>? toJson() {
    return {
      'bankAccountId': bankAccountId,
      'isMuted': isMuted,
    };
  }
}
