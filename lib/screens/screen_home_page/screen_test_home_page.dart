import 'package:flutter/material.dart';
import 'package:fusion_news/globals/globals.dart';
import 'package:fusion_news/providers/provider_news_channel.dart';
import 'package:fusion_news/screens/screen_home_page/appbar_changer.dart';
import 'package:fusion_news/screens/screen_home_page/drawer_header_changer.dart';
import 'package:fusion_news/screens/screen_home_page/news_story_list.dart';
import 'package:fusion_news/service_locator.dart';
import 'package:fusion_news/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

/// Flutter code sample for [TabBar].

class TabBarExample extends StatefulWidget {
  const TabBarExample({super.key});

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample> {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsChannelProvider>(context, listen: false);

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            onTap: (value) {
              if (mounted) {
                newsProvider.activeChannel(context).getNews();
                setState(() {
                  getIt<NewsChannelProvider>()
                      .switchChannel(newsChannels[value]);
                  newsProvider
                      .switchChannel(newsChannels[value]);
                  newsProvider
                      .activeChannel(context)
                      .setCurrentCategory(0);
                  
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
            ],
          ),
        body: const TabBarView(
          children: <Widget>[
            NestedTabBar(),
            NestedTabBar(),
            NestedTabBar(),
          ],
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key});
  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  // Category Variable to store the category name
  int categoryIndex = 0;

  double drawerWidthFactor = 0.77;

  final ScrollController _controller = ScrollController();

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);

    _tabController.addListener(() {
      getIt<NewsChannelProvider>()
          .activeChannel(context)
          .setCurrentCategory(_tabController.index);
      setState(() {
        getIt<NewsChannelProvider>().setCurrentCategory(_tabController.index);
        getIt<NewsChannelProvider>().activeChannel(context).getNews();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsChannelProvider>(context);

    return DefaultTabController(
        length: newsProvider.getCategories().length,
        child: Scaffold(
            drawerDragStartBehavior: DragStartBehavior.start,

            //EndDrawer
            endDrawer: SizedBox(
              height: MediaQuery.of(context).size.width * 1.8,
              child: Drawer(
                width: MediaQuery.of(context).size.width * drawerWidthFactor,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: newsChannels.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizedBox(
                            height: 80,
                            child: DrawerHeader(
                              decoration: BoxDecoration(
                                color: Global.kColorPrimary,
                              ),
                              child: Center(
                                child: Text(
                                  "Channels",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          index -= 1;
                          return ListTile(
                            title: Text(
                              newsChannels[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                            ),
                            onTap: () {
                              if (mounted) {
                                newsProvider.activeChannel(context).getNews();
                                setState(() {
                                  getIt<NewsChannelProvider>()
                                      .switchChannel(newsChannels[index]);
                                  newsProvider
                                      .switchChannel(newsChannels[index]);
                                  getIt<NewsChannelProvider>()
                                      .activeChannel(context)
                                      .setCurrentCategory(0);
                                  newsProvider
                                      .activeChannel(context)
                                      .setCurrentCategory(0);
                                  _tabController.index = 0;

                                  Navigator.pop(context);
                                });
                              }
                            },
                          );
                        }
                      }),
                ),
              ),
            ),

            //Drawer
            drawer: SizedBox(
              height: MediaQuery.of(context).size.width * 1.8,
              child: Drawer(
                width: MediaQuery.of(context).size.width * drawerWidthFactor,
                //ListView to create a list of Categories
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      DrawerHeaderChanger(newsProvider: newsProvider),

                      //Looping over the Category List to create a list of Categories
                      for (int i = 0;
                          i < newsProvider.getCategories().length;
                          i++)
                        ListTile(
                          title: Text(
                            newsProvider.getCategories()[i],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                          ),
                          onTap: () {
                            newsProvider
                                .activeChannel(context)
                                .setCurrentCategory(i);
                            if (mounted) {
                              setState(() {
                                newsProvider.activeChannel(context).getNews();
                                Navigator.pop(context);
                                newsProvider.setCurrentCategory(i);
                                void scrollToTopInstantly(
                                    ScrollController controller) {
                                  controller.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }

                                scrollToTopInstantly(_controller);
                              });
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),

            //AppBar
            appBar: AppBarChanger(newsProvider: newsProvider),
            bottomNavigationBar: TabBar.secondary(
              isScrollable: true,
              controller: _tabController,
              tabAlignment: TabAlignment.start,
              onTap: (value) {
                newsProvider.activeChannel(context).setCurrentCategory(value);

                if (mounted) {
                  setState(() {
                    newsProvider.activeChannel(context).getNews();
                    newsProvider.setCurrentCategory(value);
                    void scrollToTopInstantly(ScrollController controller) {
                      controller.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }

                    scrollToTopInstantly(_controller);
                  });
                }
              },
              tabs: [
                for (int i = 0; i < 10; i++)
                  Tab(
                    text: newsProvider.getCategories()[i],
                  )
              ],
            ),
            body: FutureBuilder(
                future: newsProvider.activeChannel(context).getNews(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return TabBarView(
                        controller: _tabController,
                        children: List.generate(
                            newsProvider.getCategories().length, (index) {
                          return NewsStoryList(
                            key: UniqueKey(),
                            controller: _controller,
                            categoryIndex: index,
                            newsProvider: newsProvider,
                          );
                        }));
                  }
                })));
  }
}
