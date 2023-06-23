import 'dart:io';

import 'package:example/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_image/offline_image.dart';

import 'internal_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Offline Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File?> files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          ElevatedButton(onPressed: (){
            _showModelSheet(context: context);
          },
              child: const Text('Upload')),
          ElevatedButton(onPressed: (){
            getOfflineFiles();
          },
              child: const Text('Refresh')),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: files.length,
            itemBuilder: (context, index) {
              return Image.file(files[index]!);
            },
          ),
        ],
      )
    );
  }

  getOfflineFiles() async {
    try {
      files = await getFiles(
          preferredLocation: PreferredDirectoryLocation.newFolder,
          applicationName: 'Example', directoryName: 'Test');
      print(files);
      // files = files.toList();
      setState(() {});
    } catch (e) {
      debugPrint('error : $e');
    }
  }

  void _showModelSheet(
      {required BuildContext context}) {
    Utils.showModelSheet(
      context,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CheckPermissionForPhoto(
            name: 'Gallery',
            icon: Icons.receipt_rounded,
            attachmentBase64: (dynamic value) {
              if (value != null && mounted) {}
            },
            imageFile: (dynamic value) async {
              if (value != null && mounted) {
                setState(() {
                  storeImage(context: context, image: XFile(value!.path), applicationName: 'Example', preferredLocation: PreferredDirectoryLocation.newFolder, directoryName: 'Test', fileName: 'test2.jpg' );
                });
              }
            },
          ),
          CheckPermissionForPhoto(
            name: 'Camera',
            icon: Icons.camera_alt,
            attachmentBase64: (dynamic value) {},
            imageFile: (dynamic value) async {
              if (value != null && mounted) {
                setState(() {
                  storeImage(context: context, image: XFile(value!.path), applicationName: 'Example', preferredLocation: PreferredDirectoryLocation.newFolder, directoryName: 'Test', fileName: 'test2.jpg' );
                });
              }
            },
          ),
          CheckPermissionForPhoto(
            name: 'Files',
            icon: Icons.file_copy_outlined,
            attachmentBase64: (dynamic value) {},
            imageFile: (dynamic value) async {
              if (value != null && mounted) {
                setState(() {
                });
              }
            },
          ),
        ],
      ),
      heightFactor: 0.2,
    );
  }
}
