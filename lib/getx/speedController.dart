import 'package:get/get.dart';

class SpeedController extends GetxController {
  var speed = 0.obs;
  var max_speed = 0.obs;
  var status_speed = 1.obs;

  incrementspeed(int testtestspeed) {
    speed.value = testtestspeed;
    if (testtestspeed > max_speed.value) {
      max_speed.value = testtestspeed;
    }
    print("speed GET X");
    if (speed >= 120) {
      //todo
      status_speed.value = 3;
      update();
    } else if (speed >= 89 && speed < 119) {
      //todo
      status_speed.value = 2;
      update();
    } else {
      //todo
      status_speed.value = 1;
      update();
    }
    update();
  }
}
