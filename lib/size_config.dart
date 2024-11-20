import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static Orientation? orientation;

  // Hàm khởi tạo
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;

    // Thêm kiểm tra nếu cần thiết
    assert(screenWidth != null);
    assert(screenHeight != null);
  }
}

// Lấy chiều cao tỷ lệ theo kích thước màn hình
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight ?? 812.0; // Giá trị mặc định
  return (inputHeight / 812.0) * screenHeight;
}

// Lấy chiều rộng tỷ lệ theo kích thước màn hình
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth ?? 375.0; // Giá trị mặc định
  return (inputWidth / 375.0) * screenWidth;
}
