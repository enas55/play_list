import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:play_list/play_list_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  final List<Audio> playlist = [
    Audio('assets/1.mp3', metas: Metas(title: 'song 1')),
    Audio('assets/2.mp3', metas: Metas(title: 'song 2')),
    Audio('assets/3.mp3', metas: Metas(title: 'song 3')),
  ];

  @override
  void initState() {
    initPlay();
    super.initState();
  }

  void initPlay() {
    assetsAudioPlayer.open(
      Playlist(audios: playlist),
      autoStart: false,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist Player'),
      ),
      body: ListView.builder(
        itemCount: playlist.length,
        itemBuilder: (context, index) {
          return PlayListCard(
            audio: playlist[index],
            assetsAudioPlayer: assetsAudioPlayer,
          );
        },
      ),
    );
  }
}
