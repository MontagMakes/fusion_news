import 'package:flutter/material.dart';
import 'package:fusion_news/globals/globals.dart';
import 'package:fusion_news/providers/provider_news_channel.dart';
import 'package:fusion_news/service_locator.dart';
import 'package:fusion_news/utils/utils.dart';

class EndDrawer extends StatefulWidget {
  final NewsChannelProvider newsProvider;
  final TabController tabController;

  const EndDrawer(
      {super.key, required this.tabController, required this.newsProvider});

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  @override
  Widget build(BuildContext context) {

    //Drawer to display the list of news channels
    return SizedBox(
      height: MediaQuery.of(context).size.width * 1.8,
      child: Drawer(
        width: MediaQuery.of(context).size.width * Global.drawerWidthFactor,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,

          //ListView to create a list of news channels
          child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: newsChannels.length,
              itemBuilder: (context, index) {

                //DrawerHeader
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

                //List of news channels
                } else {
                  index -= 1;
                  return ListTile(

                    //Title of the news channel
                    title: Text(
                      newsChannels[index],
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),

                    // Switch the news channel when a channel is tapped
                    onTap: () {
                      if (mounted) {
                        widget.newsProvider.activeChannel(context).getNews();
                        setState(() {
                          getIt<NewsChannelProvider>()
                              .switchChannel(newsChannels[index]);
                          widget.newsProvider
                              .switchChannel(newsChannels[index]);
                          getIt<NewsChannelProvider>()
                              .activeChannel(context)
                              .setCurrentCategory(0);
                          widget.newsProvider
                              .activeChannel(context)
                              .setCurrentCategory(0);
                          widget.tabController.index = 0;

                          Navigator.pop(context);
                        });
                      }
                    },
                  );
                }
              }),
        ),
      ),
    );
  }
}
