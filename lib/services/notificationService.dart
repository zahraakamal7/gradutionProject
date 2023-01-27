import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationService extends GetxService {
  RxMap<String, dynamic> data = RxMap<String, dynamic>();
  Future<NotificationService> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      message.data.forEach((key, value) {
        data[key] = value;
      });
    }
    // NotificationSettings settings =
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final token = await messaging.getToken();
    GetStorage().write("fireToken", token);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(messageClicked);
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      AuthController.controller
          .refreshFireBaseToken(GetStorage().read("fireToken"), newToken);
      GetStorage().write("fireToken", newToken);
      print("new token" + newToken);
    });
    print(token);
    return this;
  }

  Future messageClicked(RemoteMessage message) async {
    print('Message clicked! ${message.data}');
    message.data.forEach((key, value) {
      data[key] = value;
    });
    if (data.keys.length > 0) {
      // Get.rawSnackbar(message: "${data.values.elementAt(0)}");
      data.clear();
    }
  }
}
