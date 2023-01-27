import 'package:get/get.dart';

class RadioButtonController extends GetxController {
  RxMap<String, int> groupValue = RxMap<String, int>();
  void groupValueChanged(String id, String tag, int newVal) {
    final previous = tag.toString() + "${groupValue[tag]}";
    groupValue[tag] = newVal;
    update([id, previous]);
  }
}
