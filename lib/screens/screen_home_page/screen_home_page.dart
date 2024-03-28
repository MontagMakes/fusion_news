// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:fusion_news/globals/globals.dart';
import 'package:fusion_news/providers/provider_news_channel.dart';
import 'package:fusion_news/screens/screen_home_page/appbar_changer.dart';
import 'package:fusion_news/screens/screen_home_page/categories_tab_bar.dart';
import 'package:fusion_news/screens/screen_home_page/drawer_categories.dart';
import 'package:fusion_news/screens/screen_home_page/news_story_list.dart';
import 'package:fusion_news/service_locator.dart';
import 'package:fusion_news/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

// Main screen of the application
class ScreenHomePage extends StatefulWidget {
  const ScreenHomePage({super.key});

  @override
  State<ScreenHomePage> createState() => _ScreenHomePageState();
}

class _ScreenHomePageState extends State<ScreenHomePage>
    with TickerProviderStateMixin {
  // Controller for the TabBar
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    // Initialize the TabController
    tabController = TabController(length: 4, vsync: this);

    // Add a listener to the TabController to switch the news channel
    tabController.addListener(() {
        getIt<NewsChannelProvider>()
          .switchChannel(newsChannels[tabController.index]);
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the NewsChannelProvider
    final newsProvider =
        Provider.of<NewsChannelProvider>(context, listen: false);

    // Build the UI
    return 
          DefaultTabController(
            initialIndex: 0,
            length: 4,
            child: Scaffold(
              // TabBar for news channels
              bottomNavigationBar: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorColor:
                    Global.getTabIndicatorColor(newsProvider.currentChannel),

                // Switch the news channel when a tab is tapped
                onTap: (value) {
                  if (mounted) {
                    newsProvider.activeChannel(context).getNews();
                    setState(() {
                      getIt<NewsChannelProvider>()
                          .switchChannel(newsChannels[value]);
                      newsProvider.switchChannel(newsChannels[value]);
                      newsProvider.activeChannel(context).setCurrentCategory(0);
                    });
                  }
                },
                tabs: const [
                  Tab(
                    text: 'ProPakistani',
                  ),
                  Tab(
                    text: 'Dawn',
                  ),
                  Tab(
                    text: 'The Express Tribune',
                  ),
                  Tab(
                    text: 'Brecorder',
                  )
                ],
              ),

              // TabBarView for the news stories
              body: const TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  NestedTabBar(),
                  NestedTabBar(),
                  NestedTabBar(),
                  NestedTabBar(),
                ],
              ),
            ),
          );
        }
      }
    
  


// NestedTabBar class to display the news stories
class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key});
  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  // Variable to store the category name
  int categoryIndex = 0;

  // ScrollController for the ListView
  final ScrollController scrollController = ScrollController();

  // Controller for the TabBar
  late final TabController tabController;

  @override
  void initState() {
    super.initState();

    // Initialize the TabController
    tabController = TabController(length: 10, vsync: this);

    // Add a listener to the TabController to switch the news category
    tabController.addListener((){
        getIt<NewsChannelProvider>().activeChannel(context).getNews();

        getIt<NewsChannelProvider>()
          .activeChannel(context)
          .setCurrentCategory(tabController.index);

        
        setState(() {
          
        });
      
      
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the NewsChannelProvider
    final newsProvider = Provider.of<NewsChannelProvider>(context);

    // Build the UI
    return DefaultTabController(
        length: newsProvider.getCategories().length,
        child: Scaffold(
            drawerDragStartBehavior: DragStartBehavior.start,

            //Drawer
            drawer: DrawerCategories(
                newsProvider: newsProvider, scrollController: scrollController, tabController: tabController,),

            //AppBar
            appBar: AppBarChanger(newsProvider: newsProvider),
            bottomNavigationBar: CategoriesTabBar(
                tabController: tabController,
                newsProvider: newsProvider,
                scrollController: scrollController),

            //NewsStoryList
            body: NewsStoryList(
                categoryIndex: categoryIndex,
                newsProvider: newsProvider,
                scrollController: scrollController,
                tabController: tabController)));
  }
}
