import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class PlayListCard extends StatefulWidget {
  const PlayListCard({
    super.key,
    required this.audio,
    required this.assetsAudioPlayer,
  });

  final Audio audio;
  final AssetsAudioPlayer assetsAudioPlayer;

  @override
  State<PlayListCard> createState() => _PlayListCardState();
}

class _PlayListCardState extends State<PlayListCard> {
  late bool isPlaying;
  late bool isCurrent;

  @override
  void initState() {
    isPlaying = false;
    isCurrent = false;
    playSongs();
    super.initState();
  }

  void playSongs() {
    widget.assetsAudioPlayer.isPlaying.listen((playing) {
      setState(() {
        isPlaying = playing;
      });
    });

    widget.assetsAudioPlayer.current.listen((playingAudio) {
      setState(() {
        isCurrent = playingAudio?.audio.assetAudioPath == widget.audio.path;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text(
          isCurrent
              ? widget.audio.metas.title ?? 'Add your songs'
              : widget.audio.metas.title ?? '',
        ),
        subtitle: isCurrent
            ? StreamBuilder(
                stream: widget.assetsAudioPlayer.realtimePlayingInfos,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('00:00 / 00:00');
                  }
                  return Text(
                    '${convertToSeconds(snapshot.data!.currentPosition.inSeconds)} / ${convertToSeconds(snapshot.data!.duration.inSeconds)}',
                  );
                },
              )
            : const Text('00:00 / 00:00'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                widget.assetsAudioPlayer.previous();
              },
              icon: const Icon(Icons.skip_previous),
            ),
            IconButton(
              onPressed: () {
                if (isCurrent) {
                  if (isPlaying) {
                    widget.assetsAudioPlayer.pause();
                  } else {
                    widget.assetsAudioPlayer.play();
                  }
                } else {
                  widget.assetsAudioPlayer.open(
                    Playlist(audios: [widget.audio]),
                    autoStart: true,
                  );
                }
              },
              icon: Icon(
                isCurrent && isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
            IconButton(
              onPressed: () {
                widget.assetsAudioPlayer.next();
              },
              icon: const Icon(Icons.skip_next),
            ),
          ],
        ),
      ),
    );
  }

  String convertToSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondStr = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')}:${secondStr.padLeft(2, '0')}';
  }
}
