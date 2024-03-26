import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fusion_news/api_manager/api_manager_brecoder.dart';
import 'package:fusion_news/api_manager/api_manager_dawn.dart';
import 'package:fusion_news/api_manager/api_manager_propakistani.dart';
import 'package:fusion_news/api_manager/api_manager_tribune.dart';
import 'package:fusion_news/models/model_category.dart';
import 'package:fusion_news/models/model_channel.dart';
import 'package:fusion_news/models/model_story.dart';
import 'package:fusion_news/utils/utils.dart';

class ProviderStories with ChangeNotifier {

  int currentChannel = 0;
  int currentCategory = 0;
  int currentStory = 0;

  List<ModelStory> _storiesOfDawn = [];
  List<ModelStory> _storiesOfProPakistani = [];
  List<ModelStory> _storiesOfTribune = [];
  List<ModelStory> _storiesOfBrecorder = [];
  final List<ModelStory> _stories = [];

  ModelCategory _category = ModelCategory(name: "", stories: []);

  final List<ModelCategory> _categoriesOfDawn = [];
  final List<ModelCategory> _categoriesOfProPakistani = [];
  final List<ModelCategory> _categoriesOfTribune = [];
  final List<ModelCategory> _categoriesOfBrecorder = [];
  final List _categories = [];
  ModelChannel _channel = ModelChannel(name: "", categories: []);
  final List<ModelChannel> _channels = [];

  List<ModelStory> get storiesOfDawn => _storiesOfDawn;
  List<ModelStory> get storiesOfProPakistani => _storiesOfProPakistani;
  List<ModelStory> get storiesOfTribune => _storiesOfTribune;
  List<ModelStory> get storiesOfBrecorder => _storiesOfBrecorder;

  List<ModelStory> get stories => _stories;
  ModelCategory get category => _category;
  List<ModelCategory> get categoriesOfDawn => _categoriesOfDawn;
  List<ModelCategory> get categoriesOfProPakistani => _categoriesOfProPakistani;
  List<ModelCategory> get categoriesOfTribune => _categoriesOfTribune;
  List<ModelCategory> get categoriesOfBrecorder => _categoriesOfBrecorder;
  List get categories => _categories;

  ModelChannel get channel => _channel;
  List<ModelChannel> get channels => _channels;


  getNews() async {
    print("HELOOOOOOOO");
    for (var i = 0; i < categoriesProPakistani.length; i++) {
      
      try {
        _storiesOfProPakistani = await ProPakistaniApiService().getNewsProPakistani(linkCategoriesProPakistani[i]);
      } catch (e) {
        print('Error getting news from ProPakistani: $e');
      }

      _category = ModelCategory(
        name: categoriesProPakistani[i],
        stories: _storiesOfProPakistani,
      );

      _categoriesOfProPakistani.add(_category);
    }

    _categories.add(_categoriesOfProPakistani);
    print("categoriesOfProPakistani added to _categories: ${_categoriesOfProPakistani}");

    for (var i = 0; i < categoriesDawn.length; i++) {
      print("categoriesDawn: ${categoriesDawn[i]}");
      _storiesOfDawn = (await DawnApiService().getNewsDawn(categoriesDawn[i].toLowerCase()));
      print("storiesOfDawn: ${_storiesOfDawn.length}");
      _category = ModelCategory(
        name: categoriesDawn[i],
        stories: _storiesOfDawn,
      );
      print("category: ${_category}");
      _categoriesOfDawn.add(_category);
      print("categoriesOfDawn: ${_categoriesOfDawn.length}");
    }

    _categories.add(_categoriesOfDawn);
    print("categoriesOfDawn added to _categories: ${_categoriesOfDawn}");
    
    for (var i = 0; i < categoriesTribune.length; i++) {
      _storiesOfTribune = (await TribuneApiService().getNewsTribune(categoriesTribune[i].toLowerCase()));

      _category = ModelCategory(
        name: categoriesTribune[i],
        stories: _storiesOfTribune,
      );

      _categoriesOfTribune.add(_category);
    }

    _categories.add(_categoriesOfTribune);
    print("categoriesOfTribune added to _categories: ${_categoriesOfTribune}");

    for (var i = 0; i < categoriesBrecorder.length; i++) {
      _storiesOfBrecorder = (await BrecorderApiService().getNewsBrecorder(categoriesBrecorder[i].toLowerCase()));


      _category = ModelCategory(
        name: categoriesBrecorder[i],
        stories: _storiesOfBrecorder,
      );

      _categoriesOfBrecorder.add(_category);
    }

    _categories.add(_categoriesOfBrecorder);
    print("categoriesOfBrecorder added to _categories: ${_categoriesOfBrecorder}");

    for (var i = 0; i < newsChannels.length-1; i++) {
      print("newsChannels: ${newsChannels[i]}");
      _channel = ModelChannel(
        name: newsChannels[i],
        categories: _categories[i],
      );
      print("_channel: ${_channel}");

      _channels.add(_channel);
    }
    print("_channels: ${_channels.length}");
    
    notifyListeners();
  }

  getChannels(){
    return _channels[currentChannel];
  }

  getCategories() {
    return _categories[currentCategory];
  }

  getStories(int index) {
    return _channels[currentChannel].categories[currentCategory].stories[index];
  }
  

  switchChannel(int channel) {
    currentChannel = channel;

    notifyListeners();
  }

  setCurrentCategory(int category) {
    currentCategory = category;
    notifyListeners();
  }

  setCurrentStory(int story) {
    currentStory = story;
    notifyListeners();
  }

  
}