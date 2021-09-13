import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 35,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage)
              : AssetImage('images/empty_profile_pic.png'),
          //Image.asset('/images/empty_profile_pic.png'),
        ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.photo),
            onPressed: _pickImage,
            label: Text('Add a profile picture')),
      ],
    );
  }
}
