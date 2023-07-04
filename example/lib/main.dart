import 'dart:io';

import 'package:example/permission_handler.dart';
import 'package:offline_image/preferred_directory.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_image/offline_image.dart';

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
      debugShowCheckedModeBanner: false,
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
  List<Image?> images = [];

  @override
  void initState() {
    super.initState();
    getOfflineFiles();
  }

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
              child: const Text('Take a Picture')),
          ElevatedButton(onPressed: (){
            getOfflineFiles();
          },
              child: const Text('Auto Sync')),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return _imageContainer(image: images[index]!);
            },
          ),
        ],
      )
    );
  }

  getOfflineFiles() async {
    try {
      images = await OfflineImage.getImages(
          preferredLocation: PreferredDirectoryLocation.newFolder,
          applicationName: 'Example', directoryName: 'Test', context: context);
      //print(images);
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
                await OfflineImage.storeImage(context: context, image: XFile(value!.path), applicationName: 'Example', preferredLocation: PreferredDirectoryLocation.newFolder, directoryName: 'Test', imageName: 'test${images.length}.jpg' );
                getOfflineFiles();
                setState(() {});
              }
            },
          ),
          CheckPermissionForPhoto(
            name: 'Camera',
            icon: Icons.camera_alt,
            attachmentBase64: (dynamic value) {},
            imageFile: (dynamic value) async {
              if (value != null && mounted) {
                await OfflineImage.storeImage(context: context, image: XFile(value!.path), applicationName: 'Example', preferredLocation: PreferredDirectoryLocation.newFolder, directoryName: 'Test', imageName: 'test${images.length}.jpg' );
                getOfflineFiles();
                setState(() {});
              }
            },
          ),
        ],
      ),
      heightFactor: 0.2,
    );
  }

  Widget _imageContainer({required Image image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(child: SizedBox(
              child: image
          )),
          const SizedBox(width: 10),
          InkWell(
            child: const Icon(Icons.upload, color: Colors.blue),
            onTap: (){}
          ),
          const SizedBox(width: 10),
          InkWell(
            child: const Icon(Icons.delete, color: Colors.red),
            onTap: () {
              String path = (image.image.toString()).split('"')[1];
              OfflineImage.deleteImage(applicationName: 'Example', directoryName: path.split('/')[(path.split('/').length -2)], preferredLocation: PreferredDirectoryLocation.newFolder, context: context, imageName: path.split('/').last);
              getOfflineFiles();
              setState(() {});
            }
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
