import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {

  // have a comment section under the image

  const FullImage(this.data, {Key? key}) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          InteractiveViewer(
            minScale: 1.0,
            maxScale: 2.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: w,
                height: h,
                child: Image(
                  fit: BoxFit.contain,
                  image: data['image'],
                ),
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