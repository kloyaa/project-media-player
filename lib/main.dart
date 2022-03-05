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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(),
      ),
      initialRoute: "/screen-musics",
      getPages: [
        GetPage(
          name: "/screen-musics",
          page: () => const MusicPage(),
        ),
        GetPage(name: "/screen-videos", page: () => const ScreenVideos()),
        GetPage(
          name: "/screen-video-preview",
          page: () => const PreviewVideo(),
        ),
      ],
    );
  }
}
