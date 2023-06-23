import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum PreferredDirectoryLocation {
  newFolder,
  androidDataFolder,
  hiddenFolder,
  temporaryFolder
}

void storeImage(
    {required XFile image,
    required PreferredDirectoryLocation preferredLocation,
    String? applicationName,
    required String directoryName,
    String? innerDirectoryName,
    required BuildContext context,
    String? innerDirectoryName2,
    String? innerDirectoryName3,
    required String fileName}) async {
  try {
    Directory dr;
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    int? sdkVersion = androidInfo.version.sdkInt;
    switch (preferredLocation) {
      case PreferredDirectoryLocation.newFolder:
        if((sdkVersion ?? 0) > 29){
          if(await Permission.manageExternalStorage.isGranted){
            Directory dir = Directory(path.join(
                '/storage/emulated/0/$applicationName',
                directoryName,
                innerDirectoryName,
                innerDirectoryName2,
                innerDirectoryName3));
            dr = await dir.create(recursive: true);
            XFile(image.path).saveTo(path.join(dr.path, fileName));
            break;
          }else{
            var permission = await Permission.manageExternalStorage.request();
            if (permission.isGranted) {
              Directory dir = Directory(path.join(
                  '/storage/emulated/0/$applicationName',
                  directoryName,
                  innerDirectoryName,
                  innerDirectoryName2,
                  innerDirectoryName3));
              dr = await dir.create(recursive: true);
              XFile(image.path).saveTo(path.join(dr.path, fileName));
              break;
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => Platform.isIOS
                      ? CupertinoAlertDialog(
                    title: const Text('Storage Permission'),
                    content: const Text(
                        'This app needs storage access to storage'),
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
                  )
                      : AlertDialog(
                      title: Text(
                          '$applicationName Would Like to Access the storage'),
                      content: const Text(
                          'This app needs storage access to storage'),
                      actions: <Widget>[
                        TextButton(
                            child: const Text('Deny'),
                            onPressed: () =>
                                Navigator.of(context).pop()),
                        TextButton(
                            child: const Text('Settings'),
                            onPressed: () async {
                              await openAppSettings();
                              Navigator.of(context).pop();
                            })
                      ]));
            }
          }
          break;
        }else{
          if(await Permission.storage.isGranted){
            Directory dir = Directory(path.join(
                '/storage/emulated/0/$applicationName',
                directoryName,
                innerDirectoryName,
                innerDirectoryName2,
                innerDirectoryName3));
            dr = await dir.create(recursive: true);
            XFile(image.path).saveTo(path.join(dr.path, fileName));
            break;
          }else{
            var permission = await Permission.storage.request();
            if (permission.isGranted) {
              Directory dir = Directory(path.join(
                  '/storage/emulated/0/$applicationName',
                  directoryName,
                  innerDirectoryName,
                  innerDirectoryName2,
                  innerDirectoryName3));
              dr = await dir.create(recursive: true);
              XFile(image.path).saveTo(path.join(dr.path, fileName));
              break;
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => Platform.isIOS
                      ? CupertinoAlertDialog(
                    title: const Text('Storage Permission'),
                    content: const Text(
                        'This app needs storage access to storage'),
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
                  )
                      : AlertDialog(
                      title: Text(
                          '$applicationName Would Like to Access the storage'),
                      content: const Text(
                          'This app needs storage access to storage'),
                      actions: <Widget>[
                        TextButton(
                            child: const Text('Deny'),
                            onPressed: () =>
                                Navigator.of(context).pop()),
                        TextButton(
                            child: const Text('Settings'),
                            onPressed: () async {
                              await openAppSettings();
                              Navigator.of(context).pop();
                            })
                      ]));
            }
          }
          break;
        }
      case PreferredDirectoryLocation.androidDataFolder:
        Directory? dir = await getExternalStorageDirectory();
        Directory dir2 = Directory(path.join(dir!.path, directoryName,
            innerDirectoryName, innerDirectoryName2, innerDirectoryName3));
        dr = await dir2.create(recursive: true);
        XFile(image.path).saveTo(path.join(dr.path, fileName));
        break;
      case PreferredDirectoryLocation.hiddenFolder:
        Directory? dir = await getApplicationDocumentsDirectory();
        Directory dir2 = Directory(path.join(dir.path, directoryName,
            innerDirectoryName, innerDirectoryName2, innerDirectoryName3));
        dr = await dir2.create(recursive: true);
        XFile(image.path).saveTo(path.join(dr.path, fileName));
        break;
      case PreferredDirectoryLocation.temporaryFolder:
        Directory? dir = await getTemporaryDirectory();
        Directory dir2 = Directory(path.join(dir.path, directoryName,
            innerDirectoryName, innerDirectoryName2, innerDirectoryName3));
        dr = await dir2.create(recursive: true);
        XFile(image.path).saveTo(path.join(dr.path, fileName));
        break;
    }
  } catch (e) {
    debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
  }
}

Future<List<Image?>> getImages(
{
  required PreferredDirectoryLocation preferredLocation,
  String? applicationName,
  required String directoryName,
  String? innerDirectoryName,
  String? innerDirectoryName2,
  String? innerDirectoryName3,
}
    ) async {
  List<Image?> files = [];
  String filePath = '';
  switch(preferredLocation){
    case PreferredDirectoryLocation.newFolder:
      if(await Permission.storage.isGranted){
        filePath = path.join(
            '/storage/emulated/0/$applicationName',
            directoryName,
            innerDirectoryName,
            innerDirectoryName2,
            innerDirectoryName3);
        break;
      }else{
        await Permission.storage.request();
        if(await Permission.storage.isGranted) {
          filePath = path.join(
              '/storage/emulated/0/$applicationName',
              directoryName,
              innerDirectoryName,
              innerDirectoryName2,
              innerDirectoryName3);
          break;
        }else{
          break;
        }
      }
    case PreferredDirectoryLocation.androidDataFolder:
      Directory? directory = await getExternalStorageDirectory();
      filePath = path.join(
        directory!.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3
      );
      break;
    case PreferredDirectoryLocation.hiddenFolder:
      Directory directory = await getApplicationDocumentsDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3
      );
      break;
    case PreferredDirectoryLocation.temporaryFolder:
      Directory directory = await getTemporaryDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3
      );
      break;
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

Future<List<File?>> getFiles(
    {
      required PreferredDirectoryLocation preferredLocation,
      String? applicationName,
      String? directoryName,
      String? innerDirectoryName,
      String? innerDirectoryName2,
      String? innerDirectoryName3,
    }
    ) async {
  List<File?> files = [];
  String filePath = '';
  switch(preferredLocation){
    case PreferredDirectoryLocation.newFolder:
      if(await Permission.storage.isGranted){
        filePath = path.join(
            '/storage/emulated/0/$applicationName',
            directoryName,
            innerDirectoryName,
            innerDirectoryName2,
            innerDirectoryName3);
        break;
      }else{
        await Permission.storage.request();
        if(await Permission.storage.isGranted) {
          filePath = path.join(
              '/storage/emulated/0/$applicationName',
              directoryName,
              innerDirectoryName,
              innerDirectoryName2,
              innerDirectoryName3);
          break;
        }else{
          break;
        }
      }
    case PreferredDirectoryLocation.androidDataFolder:
      Directory? directory = await getExternalStorageDirectory();
      filePath = path.join(
          directory!.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3
      );
      break;
    case PreferredDirectoryLocation.hiddenFolder:
      Directory directory = await getApplicationDocumentsDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3
      );
      break;
    case PreferredDirectoryLocation.temporaryFolder:
      Directory directory = await getTemporaryDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3
      );
      break;
  }
  try{
    if(Directory(filePath).existsSync()) {
      final dir = Directory(filePath);
      final List entities = dir.listSync().toList();
      for (var entity in entities) {
        files.add(File(entity.path));
      }
    }
  }catch (e){
    debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
  }
  return files;
}

Future<File?> getFile(
    {
      required PreferredDirectoryLocation preferredLocation,
      String? applicationName,
      required String directoryName,
      String? innerDirectoryName,
      String? innerDirectoryName2,
      String? innerDirectoryName3,
      required String fileName,
    }
    ) async {
  File? file;
  String filePath = '';
  switch(preferredLocation){
    case PreferredDirectoryLocation.newFolder:
      if(await Permission.storage.isGranted){
        filePath = path.join(
            '/storage/emulated/0/$applicationName',
            directoryName,
            innerDirectoryName,
            innerDirectoryName2,
            innerDirectoryName3);
        break;
      }else{
        if(await Permission.storage.request().isGranted) {
          filePath = path.join(
              '/storage/emulated/0/$applicationName',
              directoryName,
              innerDirectoryName,
              innerDirectoryName2,
              innerDirectoryName3);
          break;
        }else{
          break;
        }
      }
    case PreferredDirectoryLocation.androidDataFolder:
      Directory? directory = await getExternalStorageDirectory();
      filePath = path.join(
          directory!.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3
      );
      break;
    case PreferredDirectoryLocation.hiddenFolder:
      Directory directory = await getApplicationDocumentsDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3
      );
      break;
    case PreferredDirectoryLocation.temporaryFolder:
      Directory directory = await getTemporaryDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3
      );
      break;
  }
  try{
    if(File(path.join(filePath, fileName)).existsSync()){
      return File(path.join(filePath, fileName));
    }else{
      return null;
    }
  }catch (e){
    debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
  }
  return file;
}


Future<Image?> getImage(
{
  required PreferredDirectoryLocation preferredLocation,
  String? applicationName,
  required String directoryName,
  String? innerDirectoryName,
  String? innerDirectoryName2,
  String? innerDirectoryName3,
  required String fileName
}
    ) async {
  String filePath = '';
  switch(preferredLocation){
    case PreferredDirectoryLocation.newFolder:
      if(await Permission.storage.isGranted){
        filePath = path.join(
            '/storage/emulated/0/$applicationName',
            directoryName,
            innerDirectoryName ?? '',
            innerDirectoryName2 ?? '',
            innerDirectoryName3 ?? '',
            fileName);
        break;
      }else{
        await Permission.storage.request();
        if(await Permission.storage.isGranted) {
          filePath = path.join(
              '/storage/emulated/0/$applicationName',
              directoryName,
              innerDirectoryName ?? '',
              innerDirectoryName2 ?? '',
              innerDirectoryName3 ?? '',
              fileName);
          break;
        }else{
          break;
        }
      }
    case PreferredDirectoryLocation.androidDataFolder:
      Directory? directory = await getExternalStorageDirectory();
      filePath = path.join(
          directory!.path,
          directoryName,
          innerDirectoryName ?? '',
          innerDirectoryName2 ?? '',
          innerDirectoryName3 ?? '',
          fileName
      );
      break;
    case PreferredDirectoryLocation.hiddenFolder:
      Directory directory = await getApplicationDocumentsDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName ?? '',
          innerDirectoryName2 ?? '',
          innerDirectoryName3 ?? '',
          fileName
      );
      break;
    case PreferredDirectoryLocation.temporaryFolder:
      Directory directory = await getTemporaryDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName ?? '',
          innerDirectoryName2 ?? '',
          innerDirectoryName3 ?? '',
          fileName
      );
      break;
  }
  try{
    Image image = Image.file(File(filePath));
    return image;
  }catch (e){
    debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
  }
  return null;
}


void deleteImageByName(
{
  required PreferredDirectoryLocation preferredLocation,
  String? applicationName,
  required String directoryName,
  String? innerDirectoryName,
  String? innerDirectoryName2,
  String? innerDirectoryName3,
  required String fileName
}
    ) async {
  String filePath = '';
  switch(preferredLocation){
    case PreferredDirectoryLocation.newFolder:
      if(await Permission.storage.isGranted){
        filePath = path.join(
            '/storage/emulated/0/$applicationName',
            directoryName,
            innerDirectoryName ?? '',
            innerDirectoryName2 ?? '',
            innerDirectoryName3 ?? '',
            fileName);
        break;
      }else{
        await Permission.storage.request();
        if(await Permission.storage.isGranted) {
          filePath = path.join(
              '/storage/emulated/0/$applicationName',
              directoryName,
              innerDirectoryName ?? '',
              innerDirectoryName2 ?? '',
              innerDirectoryName3 ?? '',
              fileName);
          break;
        }else{
          break;
        }
      }
    case PreferredDirectoryLocation.androidDataFolder:
      Directory? directory = await getExternalStorageDirectory();
      filePath = path.join(
          directory!.path,
          directoryName,
          innerDirectoryName ?? '',
          innerDirectoryName2 ?? '',
          innerDirectoryName3 ?? '',
          fileName
      );
      break;
    case PreferredDirectoryLocation.hiddenFolder:
      Directory directory = await getApplicationDocumentsDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName ?? '',
          innerDirectoryName2 ?? '',
          innerDirectoryName3 ?? '',
          fileName
      );
      break;
    case PreferredDirectoryLocation.temporaryFolder:
      Directory directory = await getTemporaryDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName ?? '',
          innerDirectoryName2 ?? '',
          innerDirectoryName3 ?? '',
          fileName
      );
      break;
  }
  try{
    File file = File(filePath);
    file.delete();
  }catch (e){
    debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
  }
  return null;
}

void deleteFolder(
{
  required PreferredDirectoryLocation preferredLocation,
  String? applicationName,
  required String directoryName,
  String? innerDirectoryName,
  String? innerDirectoryName2,
  String? innerDirectoryName3
}
    ) async {
  String filePath = '';
  var androidInfo = await DeviceInfoPlugin().androidInfo;
  int? sdkVersion = androidInfo.version.sdkInt;
  switch(preferredLocation){
    case PreferredDirectoryLocation.newFolder:
      if((sdkVersion ?? 0) < 29){
        if(await Permission.storage.isGranted){
          filePath = path.join(
              '/storage/emulated/0/$applicationName',
              directoryName,
              innerDirectoryName,
              innerDirectoryName2,
              innerDirectoryName3);
          break;
        }else{
          await Permission.storage.request();
          if(await Permission.storage.isGranted) {
            filePath = path.join(
                '/storage/emulated/0/$applicationName',
                directoryName,
                innerDirectoryName,
                innerDirectoryName2,
                innerDirectoryName3);
            break;
          }else{
            break;
          }
        }
      }else{
        if(await Permission.manageExternalStorage.isGranted){
          filePath = path.join(
              '/storage/emulated/0/$applicationName',
              directoryName,
              innerDirectoryName,
              innerDirectoryName2,
              innerDirectoryName3);
          break;
        }else{
          await Permission.manageExternalStorage.request();
          if(await Permission.manageExternalStorage.isGranted) {
            filePath = path.join(
                '/storage/emulated/0/$applicationName',
                directoryName,
                innerDirectoryName,
                innerDirectoryName2,
                innerDirectoryName3);
            break;
          }else{
            break;
          }
        }
      }
    case PreferredDirectoryLocation.androidDataFolder:
      Directory? directory = await getExternalStorageDirectory();
      filePath = path.join(
          directory!.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3);
      break;
    case PreferredDirectoryLocation.hiddenFolder:
      Directory directory = await getApplicationDocumentsDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3);
      break;
    case PreferredDirectoryLocation.temporaryFolder:
      Directory directory = await getTemporaryDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3);
      break;
  }
  try{
    Directory dir = Directory(filePath);
    await dir.delete(recursive: true);
  }catch (e){
    debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
  }
  return null;
}

void createFolder(
    {
      required PreferredDirectoryLocation preferredLocation,
      String? applicationName,
      required String directoryName,
      String? innerDirectoryName,
      String? innerDirectoryName2,
      String? innerDirectoryName3
    }
    ) async {
  String filePath = '';
  var androidInfo = await DeviceInfoPlugin().androidInfo;
  int? sdkVersion = androidInfo.version.sdkInt;
  switch(preferredLocation){
    case PreferredDirectoryLocation.newFolder:
      if((sdkVersion ?? 0) < 29){
        if(await Permission.storage.isGranted){
          filePath = path.join(
              '/storage/emulated/0/$applicationName',
              directoryName,
              innerDirectoryName,
              innerDirectoryName2,
              innerDirectoryName3);
          break;
        }else{
          await Permission.storage.request();
          if(await Permission.storage.isGranted) {
            filePath = path.join(
                '/storage/emulated/0/$applicationName',
                directoryName,
                innerDirectoryName,
                innerDirectoryName2,
                innerDirectoryName3);
            break;
          }else{
            break;
          }
        }
      }else{
        if(await Permission.manageExternalStorage.isGranted){
          filePath = path.join(
              '/storage/emulated/0/$applicationName',
              directoryName,
              innerDirectoryName,
              innerDirectoryName2,
              innerDirectoryName3);
          break;
        }else{
          await Permission.manageExternalStorage.request();
          if(await Permission.manageExternalStorage.isGranted) {
            filePath = path.join(
                '/storage/emulated/0/$applicationName',
                directoryName,
                innerDirectoryName,
                innerDirectoryName2,
                innerDirectoryName3);
            break;
          }else{
            break;
          }
        }
      }
    case PreferredDirectoryLocation.androidDataFolder:
      Directory? directory = await getExternalStorageDirectory();
      filePath = path.join(
          directory!.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3);
      break;
    case PreferredDirectoryLocation.hiddenFolder:
      Directory directory = await getApplicationDocumentsDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3);
      break;
    case PreferredDirectoryLocation.temporaryFolder:
      Directory directory = await getTemporaryDirectory();
      filePath = path.join(
          directory.path,
          directoryName,
          innerDirectoryName,
          innerDirectoryName2,
          innerDirectoryName3);
      break;
  }
  try{
    Directory dir = Directory(filePath);
    await dir.create(recursive: true);
  }catch (e){
    debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
  }
  return null;
}

void deleteByPath(
{
  required String path
}
    ) async {
  try{
    if(await Permission.storage.isGranted){
      File file = File(path);
      file.delete(recursive: true);
    }else{
      await Permission.storage.request();
      if(await Permission.storage.isGranted){
        File file = File(path);
        file.delete(recursive: true);
      }else{
      }
    }
  }catch (e){
    debugPrint('==== FILE STORAGE EXCEPTION ===> $e');
  }
  return null;
}

