import 'package:app/controllers/videoPlayerController.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PreviewVideo extends StatefulWidget {
  const PreviewVideo({Key? key}) : super(key: key);

  @override
  State<PreviewVideo> createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        actions: [],
      ),
      body: Container(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer.file(
            Get.put(VideoPlayerController()).videoPath,
            betterPlayerConfiguration: const BetterPlayerConfiguration(
              fit: BoxFit.contain,
              fullScreenByDefault: true,
              controlsConfiguration: BetterPlayerControlsConfiguration(
                enableSkips: false,
                showControls: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
