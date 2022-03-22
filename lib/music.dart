import 'package:app/colors.dart';
import 'package:app/helpers/destrpy_textfield_focus.dart';
import 'package:app/widgets/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> with WidgetsBindingObserver {
  late AppLifecycleState _appLifecycleState;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final _searchKey = TextEditingController();

  String _prevPath = ""; // Save before clearing
  String _currentPath = "";
  String _songTitle = "";
  int _songLength = 0;
  late Future<List<SongModel>> _listFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listFuture = getSongs();
    requestPermission();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });
    if (state == AppLifecycleState.paused) {
      print('AppLifecycleState state: Paused audio playback');
    }
    if (state == AppLifecycleState.resumed) {
      _listFuture = getSongs();
      print('AppLifecycleState state: Resumed audio playback');
    }
    print('AppLifecycleState state:  $state');
  }

  void requestPermission() {
    Permission.storage.request();
  }

  void play({path, title}) async {
    setState(() {
      _currentPath = path;
      _songTitle = title;
    });

    await _audioPlayer.play(path, isLocal: true);

    if (_currentPath != path) {
      stop();
      await _audioPlayer.play(path, isLocal: true);
    }
  }

  void stop() async {
    _audioPlayer.stop();
    setState(() {
      _currentPath = "";
      _songTitle = "";
      _prevPath = "";
    });
  }

  void pause() async {
    _audioPlayer.pause();
    setState(() {
      _prevPath = _currentPath;
      _currentPath = "";
    });
  }

  void resume() async {
    _audioPlayer.resume();
  }

  void refresh() {
    setState(() {
      _listFuture = getSongs();
    });
  }

  Future<List<SongModel>> getSongs() async {
    var songs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    setState(() {
      _songLength = songs
          .where((element) =>
              !element.data.contains("/storage/emulated/0/Music/ringtone"))
          .length;
    });
    return songs;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => destroyTextFieldFocus(context),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const SizedBox(),
            leadingWidth: 0,
            title: Text(
              "Songs ($_songLength)",
              style: GoogleFonts.roboto(
                color: Colors.black87,
                fontSize: 16.0,
              ),
            ),
            actions: [
              IconButton(
                splashRadius: 20.0,
                onPressed: () {
                  stop();
                  Get.toNamed("/screen-videos");
                },
                icon: const Icon(
                  Entypo.folder_video,
                  color: Colors.black87,
                ),
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 10.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: inputTextFieldSearch(
                        controller: _searchKey,
                        labelText: "Search title",
                        hintStyleStyle: GoogleFonts.manrope(fontSize: 12.0),
                        textFieldStyle: GoogleFonts.manrope(fontSize: 12.0),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            _searchKey.text = "";
                            refresh();
                          },
                          icon: const Icon(
                            AntDesign.close,
                            color: Colors.black87,
                          ),
                        ),
                        onChanged: () => refresh(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: FutureBuilder<List<SongModel>>(
            future: _listFuture,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                print("ConnectionState.none");
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null) {
                print("snapshot.data == null");
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: () async => getSongs(),
                child: Scrollbar(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemBuilder: (context, index) {
                      if (snapshot.data![index].data
                          .contains("/storage/emulated/0/Music/ringtone")) {
                        return const SizedBox();
                      }
                      if (!snapshot.data![index].displayNameWOExt
                          .toLowerCase()
                          .contains(_searchKey.text.trim())) {
                        return const SizedBox();
                      }
                      return Container(
                        margin: EdgeInsets.only(top: index == 0 ? 40.0 : 10.0),
                        child: ListTile(
                          minLeadingWidth: 30,
                          leading: const Icon(
                            MaterialIcons.music_note,
                            color: Colors.black87,
                          ),
                          title: Text(
                              snapshot.data![index].displayNameWOExt.trim()),
                          onTap: _currentPath == snapshot.data![index].data
                              ? () => pause()
                              : () {
                                  destroyTextFieldFocus(context);

                                  play(
                                    path: snapshot.data![index].data,
                                    title:
                                        snapshot.data![index].displayNameWOExt,
                                  );
                                },
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  ),
                ),
              );
            },
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
          bottomNavigationBar: _songTitle.isNotEmpty
              ? BottomAppBar(
                  color: Colors.white,
                  elevation: 10,
                  child: Container(
                    height: Get.height * 0.10,
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width * 0.70,
                          child: Text(
                            _songTitle,
                            style: GoogleFonts.roboto(
                              color: Colors.black87,
                              fontSize: 13.0,
                              height: 1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _currentPath.isNotEmpty
                            ? IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () async {
                                  pause();
                                },
                                icon: const Icon(
                                  AntDesign.pausecircle,
                                  size: 24.0,
                                  color: Colors.black87,
                                ),
                              )
                            : IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () async {
                                  play(
                                    path: _prevPath,
                                    title: _songTitle,
                                  );
                                },
                                icon: const Icon(
                                  AntDesign.play,
                                  size: 24.0,
                                  color: Colors.black87,
                                ),
                              ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
