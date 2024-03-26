
import 'package:fusion_news/models/model_category.dart';

class ModelChannel {
  final String name;
  final List<ModelCategory> categories;
  
  ModelChannel({
    required this.name,
    required this.categories,
  });
}