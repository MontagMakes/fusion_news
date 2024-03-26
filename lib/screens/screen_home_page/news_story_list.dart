import 'package:flutter/material.dart';
import 'package:fusion_news/providers/provider_news_channel.dart';
import 'package:fusion_news/screens/screen_description/screen_description.dart';
import 'package:fusion_news/screens/screen_home_page/card_stories.dart';

class NewsStoryList extends StatelessWidget {
  final ScrollController scrollController;
  final int categoryIndex;
  final NewsChannelProvider newsProvider;
  final TabController tabController;

  const NewsStoryList({
    super.key,
    required this.categoryIndex,
    required this.newsProvider,
    required this.scrollController,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: newsProvider.activeChannel(context).getNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Create the news stories
            return TabBarView(
                controller: tabController,

                // Loop over the categories to create the news stories
                children:
                    List.generate(newsProvider.getCategories().length, (index) {
                  return Column(
                    children: [
                      //Store the list of stories in a ListView
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: newsProvider
                              .activeChannel(context)
                              .getStories()
                              .length,

                          //Gap between the cards
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 5,
                          ),

                          itemBuilder: (context, index) {
                            return GestureDetector(

                                //Ontap to navigate to the description screen
                                onTap: () => {
                                      (Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                ScreenDescription(
                                              index: index,
                                            ),
                                            transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) =>
                                                SlideTransition(
                                              position: animation.drive(
                                                Tween(
                                                        begin: const Offset(
                                                            1.0, 0.0),
                                                        end: Offset.zero)
                                                    .chain(CurveTween(
                                                        curve:
                                                            Curves.decelerate)),
                                              ),
                                              child: child,
                                            ),
                                          )))
                                    },

                                //Card
                                child: CardStories(
                                  index: index,
                                ));
                          },
                        ),
                      ),
                    ],
                  );
                }));
          }
        });
  }
}
