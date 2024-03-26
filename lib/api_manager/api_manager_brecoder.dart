import 'package:fusion_news/models/model_story.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import 'package:html/parser.dart';

class BrecorderApiService {
  
  final _cache = <String, Response>{};
  final _dio = Dio();

  Future<Response> _get(String url) async {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    } else {
      var response = await _dio.get(url);
      _cache[url] = response;
      return response;
    }
  }
  int callCount = 0;
  Future<List<ModelStory>> getNewsBrecorder(categoriesBrecorder) async {
    callCount++;
    print("getNewsBrecorder called $callCount times");
    var dio = Dio();
    
    const String baseURL = "https://www.brecorder.com/";
    dio.options.headers['User-Agent'] = 'Mozilla/5.0';
    List<ModelStory> toReturn = [];
    
    // if categoriesBrecorder is home, then we don't need to add it to the URL
    if (categoriesBrecorder == "home") {
      categoriesBrecorder = "";
    }

    var response = await _get("$baseURL$categoriesBrecorder");
    
    print("hello");
    if (response.statusCode == 200) {
      try {
        
        var document = parse(response.data);
        var numberOfStories = 0;
        
        if (categoriesBrecorder == "") {
          numberOfStories = document.querySelectorAll('div.w-full.max-w-screen-md article').length;
        } else {
          numberOfStories = document.querySelectorAll('div.flex.flex-col.w-full article').length;
        }
        

        var title = "";
        var articleLink = "";
        var date = "";
        var content = "";
        var description = "";
        var imageURL = "";
        int limit = 3;
        int storiesToProcess = numberOfStories < limit ? numberOfStories : limit;
        
        
        for (var i = 0; i < storiesToProcess; i++) {
          
          if (categoriesBrecorder == "" || categoriesBrecorder == "br-research") {
            title = document.querySelectorAll("div.w-full.max-w-screen-md article h2 a").elementAt(i).text;  
          } else {
            title = document.querySelectorAll("div.flex.flex-col.w-full article h2 a").elementAt(i).text;
          }
          
          if (categoriesBrecorder == "" || categoriesBrecorder == "br-research") {
            articleLink = document.querySelectorAll("div.w-full.max-w-screen-md article h2 a.story__link").elementAt(i).attributes['href'] ?? "";
          } else {
            articleLink = document.querySelectorAll("div.flex.flex-col.w-full article h2 a.story__link").elementAt(i).attributes['href'] ?? "";
          }
          
          if (categoriesBrecorder == "" || categoriesBrecorder == "br-research") {
            date = document.querySelectorAll("div.w-full.max-w-screen-md article span.story__time span.timeago").elementAt(i).attributes['title'] ?? "";
          } else {
            date = document.querySelectorAll("div.flex.flex-col.w-full article span.story__time span.timeago").elementAt(i).attributes['title'] ?? "";
          }    
          
          content = await getContent(articleLink, i, categoriesBrecorder);
          Future.delayed(const Duration(seconds: 2));
          
          description = await getDescription(articleLink, i, categoriesBrecorder);
          

          if (categoriesBrecorder == "" || categoriesBrecorder == "br-research") {
            imageURL = document.querySelectorAll("div.w-full.max-w-screen-md article img").elementAt(i).attributes['src'] ?? "";
            
          } else {
            imageURL = document.querySelectorAll("div.flex.flex-col.w-full article div.block div.w-full figure.media div.media__item a picture img").elementAt(i).attributes['src'] ?? "";
          }

          toReturn.add(ModelStory(
              id: i,
              title: title,
              articleLink: articleLink,
              date: date,
              content: content,
              imageURL: imageURL,
              description: description,
          ));
        }
      } on XmlTagException catch (e){
        // handle exception using logging framework
        throw Exception(e.toString());
      }
    }  
    return toReturn;
  }
}

Future<String> getContent(String articleLink, int i, categoriesBrecorder) async {
  
  
  var response = await Dio().get(articleLink, options: Options(headers: {'User-Agent': 'Dio'}));
  if (response.statusCode != 200){
    
    await Future.delayed(const Duration(seconds: 2));
    response = await Dio().get(articleLink);
  }
  if (response.statusCode == 200) {
    var document = parse(response.data);
    
    var content = "";

    if (categoriesBrecorder == "") {
      content = document.querySelector('div.w-full.max-w-screen-md div.story__content')!.text;
    } else {
      content = document.querySelector('div.story__content')!.text;
    }

    return content;
    
  } else {
    return "Content not available";
  }
}

Future<String> getDescription(String articleLink, int i, categoriesBrecorder) async {
  
  var response =await Dio().get(articleLink, options: Options(headers: {'User-Agent': 'Dio'}));

  if (response.statusCode != 200){
    
    Future.delayed(const Duration(seconds: 2));
    response = await Dio().get(articleLink);
  }

  if (response.statusCode == 200) {
    var document = parse(response.data);
    var description = "";
    if (categoriesBrecorder == "" || categoriesBrecorder == "br-research") {
      description = document.querySelector('div.story__content p strong')!.text;
    } else {
      description = document.querySelector('div.story__content p strong')!.text;
    }

    return description;
  } else {
    return "description not available";
  }
}