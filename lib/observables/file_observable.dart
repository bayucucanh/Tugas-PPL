import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FileObservable {
  String? name;
  String? path;
  String? extension;
  Uint8List? bytes;
  int? size;

  FileObservable({
    this.name,
    this.path,
    this.extension,
    this.bytes,
    this.size,
  });

  factory FileObservable.multiPickResult(PlatformFile? file) => FileObservable(
        name: file?.name,
        path: file?.path,
        extension: file?.extension,
        bytes: file?.bytes,
        size: file?.size,
      );

  factory FileObservable.filePickerResult(FilePickerResult? file) =>
      FileObservable(
        name: file?.files.single.name,
        path: file?.files.single.path,
        extension: file?.files.single.extension,
        bytes: file?.files.single.bytes,
        size: file?.files.single.size,
      );

      factory FileObservable.xFileResult(XFile? file) {
        return FileObservable(
        name: file?.name,
        path: file?.path,
        extension: file?.mimeType,
      );
      }

  File get toFile => File(path!);

  Future<Uint8List> get asUint8List async => await File(path!).readAsBytes();
  Uint8List? get bytesSync => File(path!).readAsBytesSync();
}
