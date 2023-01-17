class SupportTicketModel {
  final String email;
  final String subject;
  final String? phone;
  final String name;
  final int code;

  SupportTicketModel(
      {required this.email,
      required this.name,
      required this.subject,
      required this.phone,
      required this.code});

  Map<String, dynamic> toJson() {
    return {
      'ticket': {
        'requester_id': 1,
        'subject': subject,
        'priority': 'normal',
        'description': codeString,
        'comment': {
          'body':
              'User: $name\nEmail: $email\n${phone != null ? 'Phone: $phone\n' : ''}Message: $subject\nReason of Contact: $codeString',
        },
        'email_ccs': [
          {'user_email': email, 'user_name': name, 'action': 'put'}
        ],
        'custom_fields': [
          {'id': 1, 'value': phone}
        ],
      }
    };
  }

  String get codeString {
    switch (code) {
      case 0:
        return 'Give a feedback';
      case 1:
        return 'Request a feature';
      case 2:
        return 'Support';
      default:
        return 'Other';
    }
  }
}
