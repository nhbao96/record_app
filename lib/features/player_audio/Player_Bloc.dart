import 'dart:async';

import 'package:record_application/common/bases/base_bloc.dart';
import 'package:record_application/common/bases/base_event.dart';
import 'package:record_application/features/player_audio/player_event.dart';

class PlayerBloc extends BaseBloc{
  StreamController<Duration> _streamController = StreamController.broadcast();

  @override
  void dispatch(BaseEvent event) {
    // TODO: implement dispatch
    switch(event.runtimeType){
      case ResumeEvent:
        handleResumeEvent(event as ResumeEvent);
        break;
      case PauseEvent:
        handlePauseEvent(event as PauseEvent);
        break;
      case SeekEvent:
        handleSeekEvent(event as SeekEvent);
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }

  void handleResumeEvent(ResumeEvent event) async{
    try{
      progressSink.add(event);
    }catch(e){
      print(e.toString());
    }
  }

  void handlePauseEvent(PauseEvent event) {
    try{
      progressSink.add(event);
    }catch(e){
      print(e.toString());
    }
  }

  void handleSeekEvent(SeekEvent event) {
    try{
      _streamController.add(event.position);
    }catch(e){
      print(e.toString());
    }
  }
}