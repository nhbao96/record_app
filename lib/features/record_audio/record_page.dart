
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_application/common/bases/base_widget.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
        child: _RecordContainer(),
        providers: [],
        appBar: AppBar(
          title: Text("Demo Audio Recording"),
        ),);
  }
}

class _RecordContainer extends StatefulWidget {
  const _RecordContainer({Key? key}) : super(key: key);

  @override
  State<_RecordContainer> createState() => _RecordContainerState();
}

class _RecordContainerState extends State<_RecordContainer> {
  final recoder = FlutterSoundRecorder();
  bool isRecoderReady = false;
  late PermissionStatus isPermisMicro;

  String _currentFilePath = '', _recordedFilePath = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recoder.closeRecorder();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRecorder();

  }

  Future initRecorder() async{
    print("\n\n\n -------> initRecorder  ,\n\n\n");
    try{
      isPermisMicro = await Permission.microphone.request();
      if(!isPermisMicro.isGranted){
        throw 'Microphone permission not grannted';
      }
      await recoder.openRecorder();
      isRecoderReady = true;
      await recoder.setSubscriptionDuration(const Duration(milliseconds: 50));

    }catch(e){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    print("\n\n\n -------> done func record ,\n\n\n");
  }

  Future record() async{
    if(!isRecoderReady){
      return;
    }
    Directory tempDir = await getApplicationDocumentsDirectory();
    String tempPath = tempDir.path;
    print(tempPath);

    final _fileName = 'DEMO_${DateTime.now().millisecondsSinceEpoch.toString()}.aac';
    _currentFilePath = '$tempPath/$_fileName';
    try{
      await recoder!.startRecorder(toFile: _currentFilePath, codec: Codec.aacMP4);
    }catch(e){
      print("startRecorder failed : ${e.toString()}");
    }

    print("_currentFilePath = $_currentFilePath \n\n");
  }

  Future stop() async{
    if(!isRecoderReady){
      return;
    }
    final path = await recoder.stopRecorder();
    final audioFile = File(path!);
    print("Recorded audio : $audioFile");
  }

  String convert2digits(int num){
    return  num.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<RecordingDisposition>(
              stream: recoder.onProgress,
              builder: (context,snapshot){
                final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                final twoDigitMinutes = convert2digits(duration.inMinutes.remainder(60));
                final twoDigitSecond = convert2digits(duration.inSeconds.remainder(60));

                return Text('$twoDigitMinutes:${twoDigitSecond}s', style: TextStyle(color: Colors.black87,fontSize: 60,fontWeight: FontWeight.bold),);
              }),
          const SizedBox( height : 32),
          ElevatedButton(
            child: Icon(
              recoder.isRecording ? Icons.stop : Icons.mic,
              size: 80,
            ),
            onPressed: () async{
              if(recoder.isRecording){
                await stop();
              }else{
                await record();
              }
            },
          ),
          TextButton(onPressed: (){
            Navigator.pushNamed(context, "player-page");
          }, child: Text("Open Player"))
        ],
      ),
    );
  }
}
