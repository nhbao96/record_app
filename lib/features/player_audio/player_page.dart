import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record_application/common/bases/base_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_application/common/widgets/progress_listener_widget.dart';
import 'package:record_application/features/player_audio/Player_Bloc.dart';
import 'package:record_application/features/player_audio/player_event.dart';
import 'dart:io';

import 'package:volume_controller/volume_controller.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: _PlayerContainer(),
      providers: [Provider<PlayerBloc>(create: (context) => PlayerBloc())],
      appBar: AppBar(
        title: Text("Player Page"),
      ),
    );
  }
}

class _PlayerContainer extends StatefulWidget {
  const _PlayerContainer({Key? key}) : super(key: key);

  @override
  State<_PlayerContainer> createState() => _PlayerContainerState();
}

class _PlayerContainerState extends State<_PlayerContainer> {
  late PlayerBloc _bloc;
  late AudioPlayer _audioPlayer = AudioPlayer();
  late bool _isPlaying;

  late Duration _duration;
  late Duration _position;

  double _volumeListenerValue = 0;
  double _getVolume = 0;
  double _setVolumeValue = 0;

  Future setAudio() async {
    //load audio from local
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      _audioPlayer.setSourceAsset(file.path);
    }
    //  _audioPlayer.setSourceAsset('audio/audio_test.mp3');

    //online
    /*_audioPlayer.setSourceUrl(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3');*/
    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = context.read();
    _audioPlayer = AudioPlayer();
    _isPlaying = false;
    _duration = Duration.zero;
    _position = Duration.zero;
    setAudio();

    //listen state : pause, play,stop
    _audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        _isPlaying = event == PlayerState.playing;
      });
    });

    //listen audio duration
    _audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        _duration = event;
      });
    });

    //listen audio position
    _audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        _position = event;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    VolumeController().removeListener();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "https://phantom-marca.unidadeditorial.es/bd1fe4bec9580bfc6b7324d8c408165a/resize/1320/f/jpg/assets/multimedia/imagenes/2022/12/27/16721764313725.jpg",
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const Text(
                  "Flutter song",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Sarah Abs",
                  style: TextStyle(fontSize: 20),
                ),
                Slider(
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);

                      //optional
                      await _audioPlayer.resume();
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(_position)),
                      Text(formatTime(_duration - _position))
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 35,
                  child: IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 50,
                    onPressed: () async {
                      if (_isPlaying) {
                        await _audioPlayer.pause();
                      } else {
                        await _audioPlayer.resume();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
