import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/notasService.dart';
import 'nota.dart';

class Notas extends StatefulWidget {
  String equityID;
  Notas(this.equityID);

  NotasForm createState() => NotasForm();
}

class NotasForm extends State<Notas> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notas"),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(_createRoute(Nota(equityID: widget.equityID)));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
      ),
      body: FutureBuilder(
        future: NotasService().list(widget.equityID),
        builder: (context2, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return Center(child: Text("Essa ação não possui notas."));
            else
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context3, index) {
                  var item = snapshot.data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(_createRoute(Nota(equityID: widget.equityID, notaID: item.id)));
                    },
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 7,
                              color: Colors.red
                            )
                          )
                        ),
                        child: ListTile(
                          title: Text(item.title),
                          subtitle: Text(
                            item.comments,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: item.alert == null ? Text("") : Center(
                            child: Icon(
                              Icons.alarm,
                              color: Colors.red,
                            )
                          ),
                        )
                      )
                    )
                  );
                }
              );
          }
          else if (snapshot.hasError)
            return Center(child: Text("Não foi possível carregar as notas."));
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