import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> handlePermissions(int mediaType) async {
  if (Platform.isAndroid) {
    PermissionStatus permissionStatus;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      if (mediaType == 1) {
        permissionStatus = await Permission.photos.status;
        if (permissionStatus == PermissionStatus.granted) {
          return true;
        } else if (permissionStatus == PermissionStatus.denied) {
          permissionStatus = await Permission.photos.request();
          if (permissionStatus == PermissionStatus.permanentlyDenied) {
            toast(
              'Permissions denied, change app settings',
              duration: Toast.LENGTH_LONG,
            );
            return false;
          } else if (permissionStatus == PermissionStatus.granted) {
            return true;
          } else {
            return false;
          }
        }
      } else {
        permissionStatus = await Permission.videos.status;
        if (permissionStatus == PermissionStatus.granted) {
          return true;
        } else if (permissionStatus == PermissionStatus.denied) {
          permissionStatus = await Permission.videos.request();
          if (permissionStatus == PermissionStatus.permanentlyDenied) {
            toast(
              'Permissions denied, change app settings',
              duration: Toast.LENGTH_LONG,
            );
            return false;
          } else if (permissionStatus == PermissionStatus.granted) {
            return true;
          } else {
            return false;
          }
        }
      }
    } else {
      permissionStatus = await Permission.storage.status;
      if (permissionStatus == PermissionStatus.granted) {
        return true;
      } else {
        permissionStatus = await Permission.storage.request();
        if (permissionStatus == PermissionStatus.granted) {
          return true;
        } else if (permissionStatus == PermissionStatus.denied) {
          return false;
        } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
          toast(
            'Permissions denied, change app settings',
            duration: Toast.LENGTH_LONG,
          );
          return false;
        }
      }
    }
  } else {
    Map<Permission, PermissionStatus> statues = await [
      Permission.camera,
      Permission.storage,
      Permission.photos
    ].request();
    PermissionStatus? statusCamera = statues[Permission.camera];
    PermissionStatus? statusStorage = statues[Permission.storage];
    PermissionStatus? statusPhotos = statues[Permission.photos];
    bool isGranted = statusCamera == PermissionStatus.granted &&
        statusStorage == PermissionStatus.granted &&
        statusPhotos == PermissionStatus.granted;
    if (isGranted) {
      return true;
    }
    bool isPermanentlyDenied =
        statusCamera == PermissionStatus.permanentlyDenied ||
            statusStorage == PermissionStatus.permanentlyDenied ||
            statusPhotos == PermissionStatus.permanentlyDenied;
    if (isPermanentlyDenied) {
      toast(
        'Permissions denied, change app settings',
        duration: Toast.LENGTH_LONG,
      );
      openAppSettings();
      return false;
    }
  }
  return true;
}
