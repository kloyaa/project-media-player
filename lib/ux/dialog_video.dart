import 'package:app/controllers/videoPlayerController.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

Future dialogOpenVideo({required BuildContext context, title, action}) async {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            elevation: 0,
            insetPadding: const EdgeInsets.all(0),
            backgroundColor: Colors.black87,
            contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
            content: SizedBox(
              height: Get.height,
              width: Get.width,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    BetterPlayer.file(
                      Get.put(VideoPlayerController()).videoPath,
                      betterPlayerConfiguration:
                          const BetterPlayerConfiguration(
                        fit: BoxFit.contain,
                        // fullScreenByDefault: true,

                        autoPlay: true,
                        controlsConfiguration:
                            BetterPlayerControlsConfiguration(
                          controlsHideTime: Duration(milliseconds: 100),
                          showControlsOnInitialize: false,
                          enableSkips: false,
                          showControls: true,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20.0,
                      right: 20.0,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          AntDesign.close,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
