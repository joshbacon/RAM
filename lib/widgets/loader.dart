import 'package:flutter/material.dart';

class Loader extends StatefulWidget {

  const Loader({Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with TickerProviderStateMixin{

  // // Size animation
  // late double beginW;
  // late double endW;
  // late final tweenWidth = Tween<double>(begin: beginW, end: endW);
  // double get width => tweenWidth.evaluate(sizeController);
  // late final sizeController = AnimationController(
  //   vsync: this,
  //   duration: const Duration(seconds: 1)
  // );

  // // Rotate animation
  // late final rotateController = AnimationController(
  //   vsync: this,
  //   duration: const Duration(seconds: 2)
  // );
  // late final tweenAngle = Tween<double>(begin: 0, end: 6.28).chain(CurveTween(curve: Curves.easeInOut));
  // double get angle => tweenAngle.evaluate(rotateController);


  // @override
  // void initState() {
  //   sizeController.addListener(() => setState(() {}));
  //   rotateController.addListener(() => setState(() {}));
  //   sizeController.repeat(reverse: true);
  //   rotateController.repeat();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   sizeController.dispose();
  //   rotateController.dispose();
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   double w = MediaQuery.of(context).size.width;
  //   beginW = w * 0.2;
  //   endW = w * 0.5;
  //   return Center(
  //     child: Transform.rotate(
  //       angle: angle,
  //       child: SizedBox(
  //         width: width,
  //         child: Image.asset(
  //           'assets/icon.png',
  //         ),
  //       ),
  //     )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}