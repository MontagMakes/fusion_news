import 'package:flutter/material.dart';
import 'package:fusion_news/globals/globals.dart';
import 'package:fusion_news/providers/provider_news_channel.dart';
import 'package:fusion_news/screens/screen_home_page/drawer_header_changer.dart';

class DrawerCategories extends StatefulWidget {
  final NewsChannelProvider newsProvider;
  final ScrollController scrollController;
  final TabController tabController;

  const DrawerCategories(
      {super.key, required this.newsProvider, required this.scrollController, required this.tabController});

  @override
  State<DrawerCategories> createState() => _DrawerCategoriesState();
}

class _DrawerCategoriesState extends State<DrawerCategories> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 1.8,
      child: Drawer(
        width: MediaQuery.of(context).size.width * Global.drawerWidthFactor,

        //ListView to create a list of Categories
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              DrawerHeaderChanger(newsProvider: widget.newsProvider),

              //Looping over the Category List to create a list of Categories
              for (int i = 0;
                  i < widget.newsProvider.getCategories().length;
                  i++)
                ListTile(
                  title: Text(
                    widget.newsProvider.getCategories()[i],
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),

                  // Switch the news category when a category is tapped
                  onTap: () {
                    widget.newsProvider.activeChannel(context).setCurrentCategory(i);
                    
                    if (mounted) {
                      setState(() {
                        widget.newsProvider.activeChannel(context).getNews();
                        widget.newsProvider.setCurrentCategory(i);
                        widget.tabController.animateTo(i);

                        Navigator.pop(context);
                    
                        void scrollToTopInstantly(ScrollController controller) {
                          controller.animateTo(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                        scrollToTopInstantly(widget.scrollController);
                      });
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
