import 'package:fusion_news/models/model_story.dart';

class ModelCategory {
  final String name;
  final List<ModelStory> stories;

  ModelCategory({
    required this.name,
    required this.stories,
  });
}