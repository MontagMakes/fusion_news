import 'package:flutter/widgets.dart';
import 'package:fusion_news/providers/provider_news_dawn.dart';
import 'package:fusion_news/providers/provider_news_propakistani.dart';
import 'package:fusion_news/providers/provider_news_tribune.dart';
import 'package:fusion_news/utils/utils.dart';
import 'package:provider/provider.dart';

class NewsChannelProvider with ChangeNotifier {
  String _currentChannel = "default";
  String get currentChannel => _currentChannel;

  List<String> _categories = categoriesProPakistani;
  List<String> get categories => _categories;

  int _categoryIndex = 0;
  int get categoryIndex => _categoryIndex;
  
  // Return the provider of the active channel
  activeChannel(BuildContext context){
      if (currentChannel == newsChannels[0]) {
        return context.read<NewsProviderProPakistani>();
        
      } else if (currentChannel == newsChannels[1]){
        return context.read<NewsProviderDawn>();

      } else if (currentChannel == newsChannels[2]){
        return context.read<NewsProviderTribune>();

      } else if (currentChannel == "default"){
        return context.read<NewsProviderProPakistani>();

      }else {
      throw Exception('Unknown channel: $currentChannel');
      }
  }

  switchChannel(String channel) {
    _currentChannel = channel;
    notifyListeners();
  }

  getCategories () {
    if (currentChannel == "ProPakistani") {
      _categories = categoriesProPakistani;
    } else if (currentChannel == "Dawn") {
      _categories = categoriesDawn;
    } else if (currentChannel == "Tribune") {
      _categories = categoriesTribune;
    } else if (currentChannel == "default") {
      _categories = categoriesProPakistani;
    } else {
      _categories = [];
    }
    return _categories;
  }

  setCurrentCategory(int index) {
    _categoryIndex = index;
    notifyListeners();
  }

  getCurrentCategory() {
    return _categoryIndex;
  }
}