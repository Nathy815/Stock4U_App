import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/noticiasService.dart';
import 'components/stock4_u_icons.dart' as CustomIcons;
import 'components/webView.dart';
import 'home.dart';
import 'perfil.dart';

class Noticias extends StatefulWidget {
  NoticiasList createState() => NoticiasList();
}

class NoticiasList extends State<Noticias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Notícias"),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(51, 51, 51, 1)
        ),
        automaticallyImplyLeading: false
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.Stock4U.newspaper),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ""
          )
        ],
        onTap: (value) {
          if (value == 0)
          {
            Navigator.of(context).pop();
            Navigator.of(context).push(_createRoute(Home()));
          }
          else if (value == 2)
          {
            Navigator.of(context).pop();
            Navigator.of(context).push(_createRoute(Perfil()));
          }
        },
      ),
      body: FutureBuilder(
        future: NoticiasService().getNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return Center(child: Text("Não há notícias para exibir."));
            else
              return Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Divider(
                        color: index != 0 && index != snapshot.data.length - 1 ? Color.fromRGBO(215, 215, 215, 1) : Colors.transparent
                      )
                    );
                  },
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data[index];
                    if (index % 4 != 0)
                      return ListTile(
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(215, 0, 0, 1)
                          ),
                        ),
                        subtitle: Text(item.subtitle),
                        onTap: () => Navigator.of(context).push(_createRoute(Web(url: item.link))),
                      );
                    else
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(_createRoute(Web(url: item.link))),
                        child: Column(
                          children: [
                            item.image == null ? Container() : Image.network(item.image),
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                item.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(215, 0, 0, 1)
                                ),
                              )
                            ),
                            Text(
                              item.subtitle,
                              textAlign: TextAlign.justify,
                            ),
                            index == 0 ? Divider() : Container()
                          ],
                        )
                      );
                  }
              )
            );
          }
          else if (snapshot.hasError)
            return Center(child: Text("Não foi possível carregar as notícias."));
          else
            return Center(child: CircularProgressIndicator());
        },
      )
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}