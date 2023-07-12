library offline_image;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:offline_image/preferred_directory.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


class OfflineImage {

  static Future<void> storeImage(
      {
        required XFile image,
        PreferredDirectoryLocation? preferredLocation = PreferredDirectoryLocation.androidDataFolder,
        required String applicationName,
        String? directoryName = '',
        required BuildContext context,
        required String imageName
      }
      ) async {
    try {
      Directory dr;
      if(Platform.isAndroid){
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        int sdkVersion = androidInfo.version.sdkInt ?? 0;
        switch (preferredLocation) {
          case PreferredDirectoryLocation.newFolder:
            if(sdkVersion > 29){
              if(await Permission.manageExternalStorage.isGranted){
                Directory dir = Directory(path.join(
                    '/storage/emulated/0/$applicationName',
                    directoryName));
                dr = await dir.create(recursive: true);
                await XFile(image.path).saveTo(path.join(dr.path, imageName));
                break;
              }else{
                var permission = await Permission.manageExternalStorage.request();
                if (permission.isGranted) {
                  Directory dir = Directory(path.join(
                      '/storage/emulated/0/$applicationName',
                      directoryName));
                  dr = await dir.create(recursive: true);
                  await XFile(image.path).saveTo(path.join(dr.path, imageName));
                  break;
                } else {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                          title: Text(
                              '$applicationName Would Like to Access the storage'),
                          content: const Text(
                              'This app needs storage access to store images'),
                          actions: <Widget>[
                            TextButton(
                                child: const Text('Deny'),
                                onPressed: () =>
                                    Navigator.of(context).pop()),
                            TextButton(
                                child: const Text('Settings'),
                                onPressed: () async {
                                  await openAppSettings();
                                })
                          ]));
                  break;
                }
              }
            }else{
              if(await Permission.storage.isGranted){
                Directory dir = Directory(path.join(
                    '/storage/emulated/0/$applicationName',
                    directoryName));
                dr = await dir.create(recursive: true);
                await XFile(image.path).saveTo(path.join(dr.path, imageName));
                break;
              }else{
                var permission = await Permission.storage.request();
                if (permission.isGranted) {
                  Directory dir = Directory(path.join(
                      '/storage/emulated/0/$applicationName',
                      directoryName));
                  dr = await dir.create(recursive: true);
                  await XFile(image.path).saveTo(path.join(dr.path, imageName));
                  break;
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                          title: Text(
                              '$applicationName Would Like to Access the storage'),
                          content: const Text(
                              'This app needs storage access to store images'),
                          actions: <Widget>[
                            TextButton(
                                child: const Text('Deny'),
                                onPressed: () =>
                                    Navigator.of(context).pop()),
                            TextButton(
                                child: const Text('Settings'),
                                onPressed: () async {
                                  await openAppSettings();
                                })
                          ]));
                  break;
                }
              }
            }
          case PreferredDirectoryLocation.androidDataFolder:
            Directory? dir = await getExternalStorageDirectory();
            Directory dir2 = Directory(path.join(dir!.path, directoryName));
            dr = await dir2.create(recursive: true);
            XFile(image.path).saveTo(path.join(dr.path, imageName));
            break;
          default:
            Directory? dir = await getApplicationDocumentsDirectory();
            Directory dir2 = Directory(path.join(dir.path, directoryName));
            dr = await dir2.create(recursive: true);
            await XFile(image.path).saveTo(path.join(dr.path, imageName));
            break;
        }
      }else{
        Directory? dir = await getApplicationDocumentsDirectory();
        Directory dir2 = Directory(path.join(dir.path, directoryName));
        dr = await dir2.create(recursive: true);
        await XFile(image.path).saveTo(path.join(dr.path, imageName));
      }
    } catch (e) {
      debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
    }
  }

  static Future<List<Image?>> getImages(
      {
        PreferredDirectoryLocation? preferredLocation = PreferredDirectoryLocation.androidDataFolder,
        required String applicationName,
        required BuildContext context,
        String? directoryName = ''
      }
      ) async {
    List<Image?> files = [];
    String filePath = '';
    if(Platform.isAndroid){
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      int sdkVersion = androidInfo.version.sdkInt ?? 0;
      switch(preferredLocation){
        case PreferredDirectoryLocation.newFolder:
          if(sdkVersion > 29){
            if(await Permission.manageExternalStorage.isGranted){
              filePath = path.join(
                  '/storage/emulated/0/$applicationName',
                  directoryName);
              break;
            }else{
              await Permission.manageExternalStorage.request();
              if(await Permission.manageExternalStorage.isGranted) {
                filePath = path.join(
                    '/storage/emulated/0/$applicationName',
                    directoryName);
                break;
              }else{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            '$applicationName Would Like to Access the storage'),
                        content: const Text(
                            'This app needs storage access to read images'),
                        actions: <Widget>[
                          TextButton(
                              child: const Text('Deny'),
                              onPressed: () =>
                                  Navigator.of(context).pop()),
                          TextButton(
                              child: const Text('Settings'),
                              onPressed: () async {
                                await openAppSettings();
                              })
                        ]));
                break;
              }
            }
          }else{
            if(await Permission.storage.isGranted){
              filePath = path.join(
                  '/storage/emulated/0/$applicationName',
                  directoryName);
              break;
            }else{
              await Permission.storage.request();
              if(await Permission.storage.isGranted) {
                filePath = path.join(
                    '/storage/emulated/0/$applicationName',
                    directoryName);
                break;
              }else{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            '$applicationName Would Like to Access the storage'),
                        content: const Text(
                            'This app needs storage access to read images'),
                        actions: <Widget>[
                          TextButton(
                              child: const Text('Deny'),
                              onPressed: () =>
                                  Navigator.of(context).pop()),
                          TextButton(
                              child: const Text('Settings'),
                              onPressed: () async {
                                await openAppSettings();
                              })
                        ]));
                break;
              }
            }
          }
        case PreferredDirectoryLocation.androidDataFolder:
          Directory? directory = await getExternalStorageDirectory();
          filePath = path.join(
              directory!.path,
              directoryName
          );
          break;
        default:
          Directory? directory = await getApplicationDocumentsDirectory();
          filePath = path.join(
              directory.path,
              directoryName
          );
          break;
      }
    }else{
      Directory? directory = await getApplicationDocumentsDirectory();
      filePath = path.join(
          directory.path,
          directoryName
      );
    }
    try{
      final dir = Directory(filePath);
      final List entities = dir.listSync().toList();
      for (var element in entities) {
        Image image = Image.file(File(element.path));
        files.add(image);
      }}catch (e){
      debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
    }
    return files;
  }


  static Future<Image?> getImage(
      {
        PreferredDirectoryLocation? preferredLocation = PreferredDirectoryLocation.androidDataFolder,
        required String applicationName,
        String? directoryName = '',
        required BuildContext context,
        required String imageName,
      }
      ) async {
    String filePath = '';
    if(Platform.isAndroid){
      switch(preferredLocation){
        case PreferredDirectoryLocation.newFolder:
          var androidInfo = await DeviceInfoPlugin().androidInfo;
          int sdkVersion = androidInfo.version.sdkInt ?? 0;
          if(sdkVersion > 29){
            if(await Permission.manageExternalStorage.isGranted){
              filePath = path.join(
                  '/storage/emulated/0/$applicationName',
                  directoryName);
              break;
            }else{
              if(await Permission.manageExternalStorage.request().isGranted) {
                filePath = path.join(
                    '/storage/emulated/0/$applicationName',
                    directoryName);
                break;
              }else{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            '$applicationName Would Like to Access the storage'),
                        content: const Text(
                            'This app needs storage access to read the file'),
                        actions: <Widget>[
                          TextButton(
                              child: const Text('Deny'),
                              onPressed: () =>
                                  Navigator.of(context).pop()),
                          TextButton(
                              child: const Text('Settings'),
                              onPressed: () async {
                                await openAppSettings();
                              })
                        ]));
                break;
              }
            }
          }else{
            if(await Permission.storage.isGranted){
              filePath = path.join(
                  '/storage/emulated/0/$applicationName',
                  directoryName);
              break;
            }else{
              if(await Permission.storage.request().isGranted) {
                filePath = path.join(
                    '/storage/emulated/0/$applicationName',
                    directoryName);
                break;
              }else{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            '$applicationName Would Like to Access the storage'),
                        content: const Text(
                            'This app needs storage access to read the file'),
                        actions: <Widget>[
                          TextButton(
                              child: const Text('Deny'),
                              onPressed: () =>
                                  Navigator.of(context).pop()),
                          TextButton(
                              child: const Text('Settings'),
                              onPressed: () async {
                                await openAppSettings();
                              })
                        ]));
                break;
              }
            }
          }
        case PreferredDirectoryLocation.androidDataFolder:
          Directory? directory = await getExternalStorageDirectory();
          filePath = path.join(
              directory!.path,
              directoryName);
          break;
        default:
          Directory? directory = await getApplicationDocumentsDirectory();
          filePath = path.join(
              directory.path,
              directoryName
          );
          break;
      }
    }else{
      Directory? directory = await getApplicationDocumentsDirectory();
      filePath = path.join(
          directory.path,
          directoryName);
    }
    try{
      if(File(path.join(filePath, imageName)).existsSync()){
        return Image.file(File(path.join(filePath, imageName)));
      }else{
        return null;
      }
    }catch (e){
      debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
    }
    return null;
  }


  static Future<void> deleteImage(
      {
        PreferredDirectoryLocation? preferredLocation = PreferredDirectoryLocation.androidDataFolder,
        required String applicationName,
        String? directoryName = '',
        required BuildContext context,
        required String imageName
      }
      ) async {
    String filePath = '';
    if(Platform.isAndroid){
      switch(preferredLocation){
        case PreferredDirectoryLocation.newFolder:
          var androidInfo = await DeviceInfoPlugin().androidInfo;
          int sdkVersion = androidInfo.version.sdkInt ?? 0;
          if(sdkVersion > 29){
            if(await Permission.manageExternalStorage.isGranted){
              filePath = path.join(
                  '/storage/emulated/0/$applicationName',
                  directoryName,
                  imageName);
              break;
            }else{
              await Permission.manageExternalStorage.request();
              if(await Permission.manageExternalStorage.isGranted) {
                filePath = path.join(
                    '/storage/emulated/0/$applicationName',
                    directoryName,
                    imageName);
                break;
              }else{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            '$applicationName Would Like to Access the storage'),
                        content: const Text(
                            'This app needs storage access to delete the image'),
                        actions: <Widget>[
                          TextButton(
                              child: const Text('Deny'),
                              onPressed: () =>
                                  Navigator.of(context).pop()),
                          TextButton(
                              child: const Text('Settings'),
                              onPressed: () async {
                                await openAppSettings();
                              })
                        ]));
                break;
              }
            }
          }else{
            if(await Permission.storage.isGranted){
              filePath = path.join(
                  '/storage/emulated/0/$applicationName',
                  directoryName,
                  imageName);
              break;
            }else{
              await Permission.storage.request();
              if(await Permission.storage.isGranted) {
                filePath = path.join(
                    '/storage/emulated/0/$applicationName',
                    directoryName,
                    imageName);
                break;
              }else{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            '$applicationName Would Like to Access the storage'),
                        content: const Text(
                            'This app needs storage access to delete the image'),
                        actions: <Widget>[
                          TextButton(
                              child: const Text('Deny'),
                              onPressed: () =>
                                  Navigator.of(context).pop()),
                          TextButton(
                              child: const Text('Settings'),
                              onPressed: () async {
                                await openAppSettings();
                              })
                        ]));
                break;
              }
            }
          }
        case PreferredDirectoryLocation.androidDataFolder:
          Directory? directory = await getExternalStorageDirectory();
          filePath = path.join(
              directory!.path,
              directoryName,
              imageName
          );
          break;
        default:
          Directory? directory = await getApplicationDocumentsDirectory();
          filePath = path.join(
              directory.path,
              directoryName,
              imageName
          );
          break;
      }
    }else{
      Directory? directory = await getApplicationDocumentsDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          imageName
      );
    }
    try{
      File file = File(filePath);
      await file.delete();
    }catch (e){
      debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
    }
    return;
  }
}
