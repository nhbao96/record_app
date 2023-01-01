import 'package:record_application/common/bases/base_event.dart';

class ResumeEvent extends BaseEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

  ResumeEvent();
}

class PauseEvent extends BaseEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

  PauseEvent();
}

class SeekEvent extends BaseEvent{
  late Duration position;
  @override
  // TODO: implement props
  List<Object?> get props => [];

  SeekEvent(this.position);
}