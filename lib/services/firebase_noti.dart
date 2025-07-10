import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_noti.dart';

class FirebaseNoti {
  static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  static Future<void> initializeFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    final token = await messaging.getToken();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        LocalNoti.showNotification(
          title: message.notification!.title ?? 'Thông báo',
          body: message.notification!.body ?? '',
        );
      }
    });

    // Xử lý khi app ở background
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // (Optional) Đăng ký topic để admin gửi FCM đến nhiều người
    await messaging.subscribeToTopic("allUsers");
  }
}
