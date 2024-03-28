import 'package:fusion_news/models/model_story.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';

class BrecorderApiService {
  Future<List<ModelStory>> getNewsBrecorder(categoriesBrecorder) async {
    List<ModelStory> toReturn = [];
    try {
      const baseURL = "https://www.brecorder.com/feeds/";
      CancelToken cancelToken = CancelToken();
      cancelToken.cancel("cancelled");
      cancelToken = CancelToken();

      var response = await Dio().get("$baseURL$categoriesBrecorder", cancelToken: cancelToken);

      if (response.statusCode == 200) {
        try {
        var document = XmlDocument.parse(response.toString());

        var numberOfStories = document.findAllElements("title").length - 1;

        for (var i = 1; i < numberOfStories; i++) {
          var title = document
              .findAllElements("title")
              .elementAt(i)
              .innerText
              .trimLeft()
              .trimRight();

          var articleLink =
              document.findAllElements("link").elementAt(i).innerText;

          var date = document
              .findAllElements("pubDate")
              .elementAt(i)
              .innerText
              .replaceAll(RegExp("([0-9][0-9]:[0-9][0-9]:[0-9][0-9]).*"), '');

          var content = document
              .findAllElements("content:encoded")
              .elementAt(i - 1)
              .innerText
              .trimLeft()
              .trimRight();

              content = content.toString().replaceAll('''{try{this.style.height=this.contentWindow.document.body.scrollHeight+'px';}catch{}}, 100)"''', "");
              content = content.toString().replaceAll('width="100%" frameborder="0" scrolling="no"', "");
              content = content.toString().replaceAll('style="height:400px;position:relative"', "");
              content = content.toString().replaceAll('sandbox="allow-same-origin allow-scripts allow-popups allow-modals allow-forms">', "");
              content = content.toString().replaceAll('</p>', "\n");
              content = content.toString().replaceAll(RegExp(r'''<[^>]*>|</.*>[^]'''), "");
              content = content.toString().replaceAll('<p>', "");
              content = content.toString().replaceAll('</p>', "\n\n");
              content = content.replaceAll(RegExp(r'/\n/g'), '\n\n\n');
          
          
          var imageURL = document
              .findAllElements("media:content")
              .elementAt(i - 1)
              .getAttribute("url");

          toReturn.add(ModelStory(
              title: title,
              articleLink: articleLink,
              date: date,
              content: content,
              imageURL: imageURL,
              description: "",
              ));
        }
        } on XmlTagException catch (e){
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