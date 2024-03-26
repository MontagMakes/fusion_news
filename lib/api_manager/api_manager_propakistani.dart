import 'package:fusion_news/models/model_story.dart';
import 'package:dio/dio.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:xml/xml.dart';

class ProPakistaniApiService {
  Future<List<ModelStory>> getNewsProPakistani(categoriesTribune) async {

    const String baseURL = "https://propakistani.pk/";
    List<ModelStory> toReturn = [];
    try {
      //Handling rapid-fire requests  
      CancelToken cancelToken = CancelToken();
      cancelToken.cancel("cancelled");
      cancelToken = CancelToken();

      var response = await Dio().get("$baseURL$categoriesTribune/feed", cancelToken: cancelToken);
      if (response.statusCode == 200) {
        try {
          
          var document = XmlDocument.parse(response.toString()).root;
          
          var numberOfStories = document.findAllElements("item").length;

          for (var i = 1; i < numberOfStories; i++) {
            
            var title = document.findAllElements("title").elementAt(i+1).innerText
                .trimLeft().trimRight();
                
            var articleLink =
                document.findAllElements("link").elementAt(i+1).innerText;

            var date = document
                .findAllElements("pubDate")
                .elementAt(i)
                .innerText
                .replaceAll(RegExp("([0-9][0-9]:[0-9][0-9]:[0-9][0-9]).*"), '');

            var content = document
                .findAllElements("content:encoded")
                .elementAt(i-1)
                .innerText
                .trimLeft().trimRight();

              content = HtmlUnescape().convert(content)
                .replaceAll('</p>', '\n')
                .replaceAll(RegExp(r'<[^>]+>'), '');
          
            var description =
                document.findAllElements("description").elementAt(i).innerText.trimLeft().trimRight();
            description = HtmlUnescape().convert(description)
                .replaceAll(RegExp(r'&([^;]+);'), '')
                .replaceAll(RegExp(r'<[^>]+>'), '');
            var imageURL =
                document.findAllElements("enclosure").elementAt(i-1).getAttribute("url").toString();

            

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

    } catch (e) {
      if (e is DioException && DioExceptionType.cancel != e.type) {
        throw Exception(e.toString());
      }
    }
    return toReturn;
  }
}

