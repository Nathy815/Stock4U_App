import 'package:http/http.dart' as http;
import '../models/noticiaModel.dart';
import 'dart:convert';

class NoticiasService {

  Future<List<NoticiaModel>> getNews() async {
    var to = new DateTime.now();
    var from = new DateTime.now().subtract(new Duration(hours: 24));
    
    var url = "http://newsapi.org/v2/everything?apiKey=1b0f9867c1ff40368fd5a69b83b1cfb2&pageSize=20&page=1&domains=bloomberg.com.br,valor.com.br,exame.abril.com.br,infomoney.com.br,empiricus.com.br,elevenfinancial.com.br,sunoreseach.com.br,blog.guiainvest.com.br&sortBy=publishedAt&from=" + from.toString() + "&to=" + to.toString();
    var response = await http.get(url);
    var news = new List<NoticiaModel>();
    
    if (response.statusCode == 200)
    {
      var body = json.decode(response.body);
      if (body["status"] == "ok")
      {
        for (var item in body["articles"])
        {
          news.add(NoticiaModel(
            title: item["title"], 
            subtitle: item["description"].toString().replaceFirst("Leia mais", "").split("The post")[0], 
            image: item["urlToImage"], 
            link: item["url"],
            place: item["source"]["name"]
          ));
        }
      }
    }

    return news;
  }
}