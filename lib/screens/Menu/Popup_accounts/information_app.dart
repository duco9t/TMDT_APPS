import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Information extends StatelessWidget {
  const Information({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
        leading: IconButton(
          icon: SvgPicture.asset(
            'images/icons/alt-arrow-left-svgrepo-com.svg', // Update with your icon path
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Nhóm 14 - HK7 - Thương mại điện tử - Học Viện Hàng Không Việt Nam',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nguyễn Tấn Dũng - 2254810025\n'
              'Trần Ngọc Duy - 2254810037\n'
              'Phan Hữu Hào - 2254810021\n'
              'Võ Như Hoàng Huy - 2254810046\n',
              style: TextStyle(
                fontSize: 20,
                height: 1.5,
              ),
            ),
            Spacer(),
            Center(
              child: Text(
                '© đây là sản phẩm của Nhóm 14,HK7, NH 2024 - 2025. Xin vui lòng không sao chép dưới mọi hình thức',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
