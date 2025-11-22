import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:music_app/core/configs/theme/app_theme.dart';
import 'package:music_app/core/navigations/app_router.dart';
import 'package:music_app/presentation/bloc/track/track_bloc.dart';
import 'package:music_app/presentation/bloc/track/track_event.dart';
import 'package:music_app/presentation/screens/splash/bloc/splash_event.dart';
import 'package:music_app/presentation/screens/splash/bloc/splash_bloc.dart';
import 'package:music_app/presentation/widgets/now_playing_bar/bloc/now_playing_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/service_locator.dart';
import 'presentation/bloc/search/search_bloc.dart';
import 'presentation/bloc/theme/theme_cubit.dart';
import 'presentation/bloc/album/album_bloc.dart';
import 'presentation/bloc/album/album_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppRouter.setupRouter(); // Khởi tạo Router trước khi chạy app

  // Khởi tạo Hydrated Bloc để lưu trạng thái
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  await initializeDependencies();

  runApp(const MyApp()); // Chạy ứng dụng
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()), // Quản lý theme
        BlocProvider(
            create: (_) => SplashBloc()..add(CheckFirstTime())), // Splash logic
        BlocProvider(
            create: (_) =>
                SongBloc(getAllSongs: sl())..add(FetchAllSongsEvent())),
        BlocProvider(create: (_) => PlayingSongBloc()),
        BlocProvider(create: (_) => AlbumBloc()..add(FetchAlbums())), // Thêm dòng này
        BlocProvider(create: (_) => SearchBloc()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/', // Định nghĩa route ban đầu
          onGenerateRoute: AppRouter.router.generator, // Fluro route generator
        ),
      ),
    );
  }
}
