import 'package:flutter/material.dart';
import 'package:fusion_news/providers/provider_news_channel.dart';

class CategoriesTabBar extends StatefulWidget {
  final TabController tabController;
  final NewsChannelProvider newsProvider;
  final ScrollController scrollController;
  const CategoriesTabBar(
      {super.key,
      required this.tabController,
      required this.newsProvider,
      required this.scrollController});

  @override
  State<CategoriesTabBar> createState() => _CategoriesTabBarState();
}

class _CategoriesTabBarState extends State<CategoriesTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar.secondary(
      isScrollable: true,
      controller: widget.tabController,
      tabAlignment: TabAlignment.start,

      // Switch the news category when a tab is tapped
      onTap: (value) {
        widget.newsProvider.activeChannel(context).setCurrentCategory(value);
        if (mounted) {
          setState(() {
            widget.newsProvider.activeChannel(context).getNews();
            widget.newsProvider.setCurrentCategory(value);
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

      // Create the news categories
      tabs: [
        for (int i = 0; i < 10; i++)
          Tab(
            text: widget.newsProvider.getCategories()[i],
          )
      ],
    );
  }
}
