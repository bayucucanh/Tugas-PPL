import 'package:flutter/material.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/shared_ui/video_player.dart';

class MediaManager extends StatefulWidget {
  final FileObservable file;
  const MediaManager({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<MediaManager> createState() => _MediaManagerState();
}

class _MediaManagerState extends State<MediaManager> {
  @override
  Widget build(BuildContext context) {
    switch (widget.file.extension) {
      case 'png':
      case 'jpg':
        return Image.file(widget.file.toFile);
      case 'mp4':
        return VideoPlayer(
          isLocal: true,
          file: widget.file.toFile,
        );
    }
    return Container();
  }
}
