import 'package:get/get.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();


  //Variables

  //Update Current Index when Page Scroll
  void updatePageIndicator(index) {}

  //Jump to the specific dot selected page
  void dotNavigationClick(index) {}

  //Update current Index & Jump to next page
  void nextPage() {}

  //Update current Index & Jump to the last Page
  void skipPage() {}
}