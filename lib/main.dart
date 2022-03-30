import 'package:app/music.dart';
import 'package:app/video-preview.dart';
import 'package:app/videos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Marju Music',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: "/screen-musics",
      getPages: [
        GetPage(
          name: "/screen-musics",
          page: () => const MusicPage(),
        ),
        GetPage(
          name: "/screen-videos",
          page: () => const VideoPage(),
        ),
        GetPage(
          name: "/screen-video-preview",
          page: () => const PreviewVideo(),
        ),
      ],
    );
  }
}
