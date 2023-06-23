import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static void showModelSheet(BuildContext context, Widget child,
      {bool dismissible = true, double heightFactor = 0.67}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: dismissible,
        isDismissible: dismissible,
        enableDrag: dismissible,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        builder: (context) {
          return FractionallySizedBox(heightFactor: heightFactor, child: child);
        });
  }
}

PermissionStatus? permissions;

class CheckPermissionForPhoto extends StatelessWidget {
  final String name;
  final IconData icon;
  final ValueSetter<File> imageFile;
  final ValueSetter<String> attachmentBase64;

  const CheckPermissionForPhoto(
      {Key? key,
        required this.name,
        required this.icon,
        required this.imageFile,
        required this.attachmentBase64})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (name == 'Camera') {
          if (await Permission.camera.isGranted) {
            _openImagePicker(ImageSource.camera, context);
          } else if (await Permission.camera.request().isGranted) {
            _openImagePicker(ImageSource.camera, context);
          } else {
            permissions = await Permission.camera.request();
            if (permissions!.isGranted) {
              _openImagePicker(ImageSource.camera, context);
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Camera Permission'),
                    content: const Text(
                        'This app needs camera access to take pictures for upload user profile photo'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('Deny'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CupertinoDialogAction(
                        child: const Text('Settings'),
                        onPressed: () => openAppSettings(),
                      ),
                    ],
                  ));
            }
          }
        } else if (name == 'Gallery') {
          if (await Permission.photos.isGranted) {
            _openImagePicker(ImageSource.gallery, context, fromGallery: true);
          } else if (await Permission.photos.request().isGranted) {
            _openImagePicker(ImageSource.gallery, context, fromGallery: true);
          } else {
            await Permission.photos.request();
            if (await Permission.photos.request().isGranted) {
              _openImagePicker(ImageSource.gallery, context, fromGallery: true);
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Gallery Permission'),
                    content: const Text(
                        'This app needs gallery access to select pictures for upload'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('Deny'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CupertinoDialogAction(
                        child: const Text('Settings'),
                        onPressed: () => openAppSettings(),
                      ),
                    ],
                  ));
            }
          }
        }
        else if (name == 'Files') {
          // _openFilePicker(context);
          if (await Permission.storage.isGranted) {
            _openFilePicker(context);
          } else if (await Permission.storage.request().isGranted) {
            _openFilePicker(context);
          } else {
            await Permission.storage.request();
            if (await Permission.storage.request().isGranted) {
              _openFilePicker(context);
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Files Permission'),
                    content: const Text(
                        'This app needs Files access to select files for upload'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('Deny'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CupertinoDialogAction(
                        child: const Text('Settings'),
                        onPressed: () => openAppSettings(),
                      ),
                    ],
                  ));
            }
          }
        }

      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 45.0,
            width: 45.0,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,),
            child: Icon(icon),
          ),
          const SizedBox(height: 10.0),
          Text(
            name,
          )
        ],
      ),
    );
  }

  Future _openImagePicker(ImageSource source, BuildContext context,
      {bool fromGallery = false}) async {
    try {
      final _file = await ImagePicker().pickImage(
          source: source,
          // maxHeight: 400, maxWidth: 400,
          imageQuality: 100);
      if (_file != null) {
        List<int> imageBytes = await File(_file.path).readAsBytes();
        imageFile(File(_file.path));
        attachmentBase64(base64Encode(imageBytes));
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future _openFilePicker(BuildContext context) async {
    try {
      final _file = (await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png'],
          allowMultiple: false,
          allowCompression: false,
          onFileLoading: (FilePickerStatus status) => print(status)))?.files;
      if (_file != null && _file.isNotEmpty) {
        File file = File(_file.first.path!);
        int sizeInBytes = file.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb < 50){
          List<int> imageBytes = await File(_file.first.path ?? '').readAsBytes();
          imageFile(File(_file.first.path ?? ''));
          attachmentBase64(base64Encode(imageBytes));
          Navigator.pop(context);
        }
        else{
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}
