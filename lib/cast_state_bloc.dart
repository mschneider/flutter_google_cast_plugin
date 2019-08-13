import 'package:bloc/bloc.dart';
import 'package:flutter_google_cast_plugin/session_manager.dart';
import 'package:logging/logging.dart';

enum CastState { noDevicesAvailable, notConnected, connecting, connected }

class CastStateBloc extends Bloc<int, CastState> {

  final Logger log = new Logger('CastStateBloc');

  CastStateBloc() {
    SessionManager.castEventStream().listen((nativeEvent) {
      log.info("CastStateBloc received $nativeEvent");
      if (nativeEvent is int) {
        dispatch(nativeEvent - 1);
      }
    }, onError: (error) {
      dispatch(CastState.noDevicesAvailable.index);
    });
  }

  @override
  CastState get initialState => CastState.noDevicesAvailable;

  @override
  Stream<CastState> mapEventToState(int event) async* {
    yield CastState.values[event];
  }
}
