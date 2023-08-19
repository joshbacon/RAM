import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ram/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class UploadPage extends StatefulWidget {

  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  bool addLocal = true;
  //bool addURL = false;
  bool showUploadErr = false;

  TextEditingController urlController = TextEditingController();

  Future<XFile?> acceptImage() async {
    ImagePicker picker = ImagePicker();
    return await picker.pickImage(
      source: ImageSource.gallery,
    );
  }

  Future<void> _showDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            msg,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text( "Ok",
                style: TextStyle(
                  fontFamily: "dubai",
                  color: Color.fromARGB(255, 56, 56, 56),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 75),
        child: Column( children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: (){
                  setState(() {
                    addLocal = true;
                    showUploadErr = false;
                  });
                },
                child: Text(
                  "Local",
                  style: TextStyle(
                    fontFamily: "dubai",
                    decoration: TextDecoration.none,
                    color: addLocal ? Colors.white : Theme.of(context).colorScheme.primary,
                    fontSize: 27,
                  )
                )
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    addLocal = false;
                    showUploadErr = false;
                  });
                },
                child: Text(
                  "URL",
                  style: TextStyle(
                    fontFamily: "dubai",
                    decoration: TextDecoration.none,
                    color: !addLocal ? Colors.white : Theme.of(context).colorScheme.primary,
                    fontSize: 27,
                  )
                )
              ),
            ]
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: addLocal ? [
              const SizedBox(height: 100),
              DottedBorder(
                dashPattern: const [8, 4],
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onBackground,
                child: IconButton(
                  highlightColor: Theme.of(context).colorScheme.primary.withAlpha(69),
                  padding: EdgeInsets.all(min(w, h)/8),
                  onPressed: () async {
                    XFile? imagePicked = await acceptImage();
                    if ( imagePicked != null && await context.read<User>().uploadPost(File(imagePicked.path)) ) {
                      setState(() {
                        _showDialog('Your post has been uploaded');
                        showUploadErr = false;
                      });
                    } else {
                      setState(() {
                        showUploadErr = true;
                      });
                    }
                  },
                  iconSize: min(w/5, 100),
                  icon: Icon(
                    Icons.add_a_photo_outlined,
                    color: Theme.of(context).colorScheme.primary
                  )
                ),
              ),
              const SizedBox(height: 50),
              Text(
                "choose an image to upload",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: showUploadErr,
                child: const Text(
                  "woops try again",
                  style: TextStyle(
                    fontFamily: "dubai",
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ] : [
              const SizedBox(height: 100),
              Text(
                "enter URL to the image you want to upload",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "dubai",
                  decoration: TextDecoration.none,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 28,
                  height: 1,
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: urlController,
                maxLines: 3,
                minLines: 1,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                  ),
                ),
                style: const TextStyle(
                  fontFamily: "dubai",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 25),
              IconButton(
                onPressed: () async {
                  if (
                    urlController.text.isNotEmpty &&
                    await context.read<User>().uploadPostFromURL(urlController.text)
                  ) {
                    setState(() {
                      _showDialog('Your post has been uploaded');
                      urlController.clear();
                      FocusScope.of(context).unfocus();
                      showUploadErr = false;
                    });
                  } else {
                    setState(() {
                      showUploadErr = true;
                    });
                  }
                },
                iconSize: min(w/5, 100),
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Theme.of(context).colorScheme.primary
                )
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: showUploadErr,
                child: const Text(
                  "woops try again",
                  style: TextStyle(
                    fontFamily: "dubai",
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],),
      ),
    );
  }
}




