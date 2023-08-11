import 'package:flutter/material.dart';
import 'package:ram/widgets/fullimage.dart';

class LittlePost extends StatefulWidget {
  const LittlePost(this.data, {Key? key}) : super(key: key);
  
  final Map<String, dynamic> data;

  @override
  State<LittlePost> createState() => _LittlePostState();
}

class _LittlePostState extends State<LittlePost> {

  showFullImage(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FullImage(widget.data)));
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showFullImage(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image(image: widget.data['image']),
      ),
    );
  }
}