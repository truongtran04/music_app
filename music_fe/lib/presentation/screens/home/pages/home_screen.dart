import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/presentation/screens/home/pages/body_home.dart';
import 'package:music_app/presentation/widgets/album_detail/album_detail.dart';
import 'package:music_app/presentation/screens/home/widgets/artist_detail.dart';

import '../../../widgets/album_detail/bloc/album_detail_bloc.dart';
import '../../../widgets/album_detail/bloc/album_detail_event.dart';

class HomePage extends StatefulWidget {
  final bool showDetail;
  final VoidCallback openDetail;
  final VoidCallback closeDetail;
  final bool showArtistDetail;
  final VoidCallback openArtistDetail;
  final VoidCallback closeArtistDetail;

  const HomePage({
    super.key,
    required this.showDetail,
    required this.openDetail,
    required this.closeDetail,
    required this.showArtistDetail,
    required this.openArtistDetail,
    required this.closeArtistDetail,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AlbumDetailBloc? _albumDetailBloc;
  String? _currentAlbumId;

  void _handleAlbumTap(String albumId) {
    setState(() {
      _currentAlbumId = albumId;
      _albumDetailBloc?.close();
      _albumDetailBloc = AlbumDetailBloc()..add(FetchAlbumDetail(albumId));
    });
    widget.openDetail();
  }

  @override
  void dispose() {
    _albumDetailBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showDetail && _albumDetailBloc != null) {
      return BlocProvider.value(
        value: _albumDetailBloc!,
        child: AlbumDetailPage(onBack: () {
          widget.closeDetail();
          _albumDetailBloc?.close();
          _albumDetailBloc = null;
          _currentAlbumId = null;
        }),
      );
    }
    
    if (widget.showArtistDetail) {
      return ArtistDetailPage(onBack: widget.closeArtistDetail);
    }
    
    return BodyHomePage(
      onAlbumTap: _handleAlbumTap,
      onArtistTap: widget.openArtistDetail,
    );
  }
}