import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as p;

class MediaServices {
  dynamic mediaList = [];


  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }

  multipickFiles(String? filetype) async {
    var size = 20971520;
    mediaList = [];
    switch (filetype) {
      case 'Image':
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(allowMultiple: true, type: FileType.any);
        if (result != null) {
          result?.files.forEach((element) {
            if (element.size == 0) {
              print('your file size is too small');
            }
            if (element.size >= size) {
              print('your file size is too big');
            } else {
              var data = result.files;
              for (var media in data) {
                var result = {
                  "mediaUrl": getBaseUrl(media.path, media.name),
                  "filePath": media.path,
                  "fileName": media.name,
                  "contentType": mime(media.name),
                  "mediaType": media.extension,
                  "thumbnailUrl": getBaseUrl(media.path, media.name),
                  "mediaSize": media.size / 1024 * 1024.ceil(),
                  // "isUploaded": false,
                  "keyName": ''
                };
                mediaList.add(result);
              };
              print('muthu $mediaList');
            }
          });
          return mediaList;
        } else {
          print('No files selected');
        }
        break;

      case 'Video':
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(allowMultiple: true, type: FileType.video);
        result?.files.forEach((element) {
          if (element.bytes == 0) {
            print('your file size is too small');
          } else if (element.bytes == size) {
            print('your file size is too big');
          } else {
            mediaList = result!.files.map((e) {
              return {
                "mediaUrl": e.path,
                "filePath": e.path,
                "fileName": e.name,
                "contentType": mime(e.name),
                "mediaType": e.extension,
                "thumbnailUrl": e.path,
                "mediaSize": e.size / 1024 * 1024.ceil(),
                // "isUploaded": false
              };
            }).toList();
          }
        });
        break;
      case 'Audio':
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(allowMultiple: true, type: FileType.audio);
        result?.files.forEach((element) {
          if (element.bytes == 0) {
            print('your file size is too small');
          } else if (element.bytes == size) {
            print('your file size is too big');
          } else {
            mediaList = result!.files.map((e) {
              return {
                "mediaUrl": e.path,
                "filePath": e.path,
                "fileName": e.name,
                "contentType": mime(e.name),
                "mediaType": e.extension,
                "thumbnailUrl": e.path,
                "mediaSize": e.size / 1024 * 1024.ceil(),
                // "isUploaded": false
              };
            }).toList();
          }
        });
        break;
      case 'pdf':
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.custom,
            allowedExtensions: ['pdf']);

        result?.files.forEach((element) {
          if (element.bytes == 0) {
            print('your file size is too small');
          } else if (element.bytes == size) {
            print('your file size is too big');
          } else {
            var data = result.files;
            for (var media in data) {
              var result = {
                "mediaUrl": getBaseUrl(media.path, media.name),
                "filePath": media.path,
                "fileName": media.name,
                "contentType": mime(media.name),
                "mediaType": media.extension,
                "thumbnailUrl": getBaseUrl(media.path, media.name),
                "mediaSize": media.size / 1024 * 1024.ceil(),
                // "isUploaded": false,
                "keyName": ''
              };
              mediaList.add(result);
            }
            ;
            print('muthu $mediaList');
          }
        });
        return mediaList;
        break;
      case 'doc':
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.custom,
            allowedExtensions: ['doc']);
        result?.files.forEach((element) {
          if (element.bytes == 0) {
            print('your file size is too small');
          } else if (element.bytes == size) {
            print('your file size is too big');
          } else {
            mediaList = result!.files.map((e) {
              return {
                "mediaUrl": getBaseUrl(e.path, e.name),
                "filePath": e.path,
                "fileName": e.name,
                "contentType": '',
                "mediaType": e.extension,
                "thumbnailUrl": getBaseUrl(e.path, e.name),
                "mediaSize": e.size / 1024 * 1024.ceil(),
                // "isUploaded": false
              };
            }).toList();
          }
        });
    }
  }

  singlePickImage() async {
    var size = 20971520;
    Map<String, dynamic>? val;
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      final file = result.files.first;
      print('media is going to select');
      if (file.bytes == 0) {
        print('your file size is too small');
      } else if (file.size >= size) {
        print('your file size is too big');
      } else {
        val = {
          "mediaUrl": file.path,
          "contentType": '',
          "mediaType": file.extension,
          "thumbnailUrl": file.path,
          "mediaSize": file.size / 1024 * 1024.ceil(),
          // "isUploaded": false
        };
        mediaList.add(val);
      }
    } else {
      print('No files selected');
    }
  }
  Future<dynamic> getBaseUrl(path, name) async {
    final bytes = File(path).readAsBytesSync();
    String? mimeType = name.toString().split("/").last;
    String baseUrl = 'data:' + mimeType! + ';base64,' + base64Encode(bytes);
    print(baseUrl);
    return baseUrl;
  }

  cameraFiles(media,name) async {
    var size = 20971520;
    var result = {
      "mediaUrl": await getBaseUrl(media.path, name),
      "filePath": media.path,
      "fileName": name.toString().split("/").last,
      "contentType": name.toString().split("/").last,
      "mediaType":  p.extension(media.path),
      "thumbnailUrl":await getBaseUrl(media.path,name),
      "mediaSize": File(media. path). lengthSync() /  1024.ceil(),
      // "isUploaded": false,
      "keyName": ''
    };
    return result;
  }
}