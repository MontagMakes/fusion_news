import 'package:flutter/material.dart';
import 'package:fusion_news/providers/provider_news_channel.dart';
import 'package:fusion_news/screens/screen_description/screen_description.dart';
import 'package:fusion_news/screens/screen_home_page/card_stories.dart';

class NewsStoryList extends StatelessWidget {
  final ScrollController _controller;
  final int categoryIndex;
  final NewsChannelProvider newsProvider;

  const NewsStoryList({
    required Key key,
    required ScrollController controller,
    required this.categoryIndex,
    required this.newsProvider,
  })  : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    print("category text: ${newsProvider.getCategories()[categoryIndex]}");
    return Column(
      children: [
        //Category
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              
              newsProvider.getCategories()[categoryIndex],
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ),
        ),

        //Store the list of stories in a ListView
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _controller,
            shrinkWrap: true,
            itemCount: newsProvider.activeChannel(context).getStories().length,

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
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ScreenDescription(
                                index: index,
                              ),
                              transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) =>
                                  SlideTransition(
                                position: animation.drive(
                                  Tween(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero)
                                      .chain(
                                          CurveTween(curve: Curves.decelerate)),
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
  }
}
