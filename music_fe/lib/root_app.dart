import 'package:flutter/material.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';
import 'package:music_app/presentation/screens/add/pages/add_screen.dart';
import 'package:music_app/presentation/screens/home/pages/home_screen.dart';
import 'package:music_app/presentation/screens/library/pages/library_screen.dart';
import 'package:music_app/presentation/screens/premium/pages/premium_screen.dart';
import 'package:music_app/presentation/screens/search/pages/search_screen.dart';
import 'package:music_app/presentation/widgets/now_playing_bar/now_playing_bar.dart';

import 'common/widgets/appbar/app_bar_drawer.dart';
import 'common/widgets/drawer/drawer.dart';
import 'common/widgets/navigation_bar/bottom_navigation_bar.dart';
import 'core/configs/theme/app_colors.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int activeTab = 0;
  bool showDetail = false;
  bool showArtistDetail = false;

  void _updateTab(int index) {
    setState(() {
      activeTab = index;
      showDetail = false;
      showArtistDetail = false;
    });
  }

  void openDetail() {
    setState(() {
      showDetail = true;
      showArtistDetail = false;
    });
  }

  void closeDetail() {
    setState(() {
      showDetail = false;
    });
  }

  void openArtistDetail() {
    setState(() {
      showArtistDetail = true;
      showDetail = false;
    });
  }

  void closeArtistDetail() {
    setState(() {
      showArtistDetail = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = "";
    List<Widget>? appBarActions;

    switch (activeTab) {
      case 0:
        appBarTitle = "";
        appBarActions = null;
        break;
      case 1:
        appBarTitle = "Tìm kiếm";
        appBarActions = [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {},
              icon: const ClipOval(
                child: Icon(Icons.camera_alt_outlined, size: 30, color: Colors.white),
              ),
            ),
          ),
        ];
        break;
      case 2:
        appBarTitle = "Thư viện";
        appBarActions = [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {},
              icon: const ClipOval(
                child: Icon(Icons.add, size: 30, color: Colors.white),
              ),
            ),
          ),
        ];
        break;
      default:
        appBarTitle = "";
        appBarActions = null;
    }

    // Ẩn AppBarHome khi showDetail hoặc showArtistDetail
    final bool hideAppBar = (activeTab == 3 || activeTab == 4 || (activeTab == 0 && (showDetail || showArtistDetail)));

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: context.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: hideAppBar
          ? null
          : AppBarHome(
              scaffoldKey: scaffoldKey,
              title: appBarTitle,
              actions: appBarActions,
            ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Body(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: NowPlayingBar(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        activeTab: activeTab,
        onTabSelected: _updateTab,
      ),
    );
  }

  Widget Body() {
    return IndexedStack(
      index: activeTab,
      children: [
        HomePage(
          showDetail: showDetail,
          openDetail: openDetail,
          closeDetail: closeDetail,
          showArtistDetail: showArtistDetail,
          openArtistDetail: openArtistDetail,
          closeArtistDetail: closeArtistDetail,
        ),
        SearchPage(),
        LibraryPage(),
        PremiumPage(),
        AddPage(),
      ],
    );
  }
}
