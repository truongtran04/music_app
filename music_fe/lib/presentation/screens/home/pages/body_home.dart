import 'package:flutter/material.dart';
import 'package:music_app/presentation/screens/home/widgets/artist.dart';
import 'package:music_app/presentation/screens/home/widgets/propose.dart';

import '../../../../common/widgets/text/text_title.dart';
import '../widgets/song_card_type.dart';
import '../widgets/song_list.dart';

class BodyHomePage extends StatelessWidget {
  final Function(String albumId)? onAlbumTap;
  final VoidCallback? onArtistTap;
  const BodyHomePage({super.key, this.onAlbumTap, this.onArtistTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextTitle(title: "Đề xuất cho bạn", left: 16,),
            Propose(onAlbumTap: onAlbumTap),
            TextTitle(title: "Nghệ sĩ nổi bật", left: 16,),
            ArtistList(onArtistTap: onArtistTap),
            TextTitle(title: "Album được đề xuất", left: 16,),
            Propose(onAlbumTap: onAlbumTap),
            TextTitle(title: "My playlists", left: 16,),
            SongList(cardType: SongCardType.overlay,),
            TextTitle(title: "Popular", left: 16,),
            SongList(cardType: SongCardType.below,),
           ],
        ),
      ),
    );
  }
}