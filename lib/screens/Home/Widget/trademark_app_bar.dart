import 'package:HDTech/constants.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class TrademarkAppBar extends StatefulWidget {
  final Function(String)
      onCompanySelected; // Callback để truyền lại thương hiệu
  const TrademarkAppBar({super.key, required this.onCompanySelected});

  @override
  TrademarkAppBarState createState() => TrademarkAppBarState();
}

class TrademarkAppBarState extends State<TrademarkAppBar> {
  String selectedBrand = 'All';

  void updateSelectedBrand(String brandName) {
    setState(() {
      selectedBrand = brandName;
    });

    // Gọi callback để truyền thương hiệu đã chọn về HomeScreen
    widget.onCompanySelected(brandName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ZoomTapAnimation(
                child: GestureDetector(
                  onTap: () {
                    updateSelectedBrand('All');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 6, left: 6, right: 16, bottom: 6),
                    decoration: ShapeDecoration(
                      color: selectedBrand == 'All'
                          ? kprimaryColor
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Image.asset(
                                'images/notes-minimalistic-svgrepo-com.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (selectedBrand == 'All')
                          const Text(
                            'All',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Airbnb Cereal App',
                              fontWeight: FontWeight.w500,
                              height: 0.08,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              ...List.generate(3, (index) {
                String imagePath;
                String brandName;

                switch (index) {
                  case 0:
                    imagePath = 'images/audi.png';
                    brandName = 'Audi';
                    break;
                  case 1:
                    imagePath = 'images/ranglan.png';
                    brandName = 'Ranglan';
                    break;
                  case 2:
                    imagePath = 'images/happytee.png';
                    brandName = 'HappyTee';
                    break;
                  default:
                    imagePath = '';
                    brandName = '';
                }

                return ZoomTapAnimation(
                  child: GestureDetector(
                    onTap: () {
                      updateSelectedBrand(brandName);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 6, right: 16),
                      decoration: ShapeDecoration(
                        color: selectedBrand == brandName
                            ? kprimaryColor
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 42,
                            height: 54,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (selectedBrand == brandName)
                            Text(
                              brandName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Airbnb Cereal App',
                                fontWeight: FontWeight.w500,
                                height: 0.08,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
