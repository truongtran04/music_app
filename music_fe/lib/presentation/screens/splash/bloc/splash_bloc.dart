import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/presentation/screens/splash/bloc/splash_event.dart';
import 'package:music_app/presentation/screens/splash/bloc/splash_state.dart';
import '../../../../data/sources/local_storage.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<CheckFirstTime>(_onCheckFirstTime);
  }

  Future<void> _onCheckFirstTime(
      CheckFirstTime event, Emitter<SplashState> emit) async {
    await Future.delayed(const Duration(seconds: 2));

    bool isFirstTime = await LocalStorage.isFirstTime();

    if (isFirstTime) {
      await LocalStorage.setFirstTimeFalse();
      emit(SplashNavigateToOnboarding());
    } else {
      emit(SplashNavigateToHome());
    }
  }
}
