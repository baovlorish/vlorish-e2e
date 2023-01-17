import 'package:burgundy_budgeting_app/domain/network/api_client.dart';
import 'package:pubnub/pubnub.dart';

abstract class NotificationService {
  Stream get notificationStream;

  void initNotificationService(String userId);
}

class NotificationServiceImpl implements NotificationService {
  Keyset? keySet;

  PubNub? pubnub;

  Channel? channel;

  Subscription? subscription;
  String? userId;

  NotificationServiceImpl();

  @override
  void initNotificationService(String newUserId) {
    userId = newUserId;
    keySet = Keyset(
        subscribeKey: ApiClient.ENV_PUBNUB_CREDENTIALS['sub_key']!,
        publishKey: ApiClient.ENV_PUBNUB_CREDENTIALS['publish_key']!,
        uuid: UUID(userId!));
    pubnub = PubNub(defaultKeyset: keySet);
    channel = pubnub!.channel('individual_channel_$userId');
    subscription = pubnub!.subscribe(channels: {'individual_channel_$userId'});
  }

  @override
  Stream get notificationStream => subscription!.messages;
}
