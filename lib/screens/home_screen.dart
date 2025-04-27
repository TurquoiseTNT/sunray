import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';
import 'tabs/downloads.dart';
import 'tabs/settings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected tab index

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3, // Number of tabs
      initialIndex: _selectedIndex, // Sync with the selected index
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = constraints.maxWidth < constraints.maxHeight;
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: Image.asset(
                  isDarkMode
                      ? 'assets/images/worddark.png'
                      : 'assets/images/wordlight.png',
                  height: 40,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.cast),
                  tooltip: 'Cast Content',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.group),
                  tooltip: 'Group Play',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search',
                  onPressed: () {},
                ),
              ],
            ),
            body: Row(
              children: [
                if (!isPortrait)
                  NavigationRail(
                    selectedIndex: _selectedIndex, // Sync with the selected tab
                    onDestinationSelected: (index) {
                      setState(() {
                        _selectedIndex = index; // Update the selected index
                      });
                      DefaultTabController.of(context)?.animateTo(index); // Switch tabs
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.video_library),
                        label: Text('Downloads'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                    ],
                  ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Center(child: HomeTab()),
                      Center(child: DownloadManager()),
                      Center(child: Settings()),
                    ],
                    // Update the selected tab when swiping
                    physics: NeverScrollableScrollPhysics(), // Optional: Disable swipe if needed
                  ),
                ),
              ],
            ),
            bottomNavigationBar: isPortrait
                ? BottomAppBar(
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index; // Update the selected index
                        });
                      },
                      tabs: [
                        Tab(icon: Icon(Icons.home), text: 'Home'),
                        Tab(icon: Icon(Icons.video_library), text: 'Downloads'),
                        Tab(icon: Icon(Icons.settings), text: 'Settings'),
                      ],
                    ),
                  )
                : null, // No bottom navigation bar in landscape mode
          );
        },
      ),
    );
  }
}