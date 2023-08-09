import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  const FullImage(this.data, {Key? key}) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
              width: w,
              height: h,
              child: Image(
                image: data['image'],
              ),
            ),
          ),
          // interaction bar also (???)
          //comment section
        ],
      ),
    );
  }
}