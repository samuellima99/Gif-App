import 'package:flutter/material.dart';
import 'package:gif_app/pages/share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var gifController = TextEditingController();
  var _offset = 0;

  Future<Map> _getGifs() async {
    String gif;

    setState(() {
      gif = gifController.text;
    });

    var response = await http.get(Uri.parse(
        'https://api.giphy.com/v1/gifs/search?api_key=7sORftGkTlJk2rF0jLsy7piEV4mObg94&q=$gif&limit=19&offset=$_offset&rating=g&lang=en'));
    return json.decode(response.body);
  }

  void _initState() {
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: snapshot.data["data"].length + 1,
        itemBuilder: (context, index) {
          if (index == snapshot.data["data"].length) {
            return GestureDetector(
              child: Center(
                  child: Text(
                "Carregar mais...",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              )),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
            );
          } else {
            return Expanded(
                child: GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    (context),
                    MaterialPageRoute(
                        builder: (context) =>
                            Details(snapshot.data["data"][index])));
              },
            ));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Image.network(
              "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif")),
      body: FutureBuilder(
          future: _getGifs(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        strokeWidth: 5.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)),
                  ),
                );

                break;
              default:
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: 16.0,
                                    left: 16.0,
                                    top: 16.0,
                                    bottom: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Form(
                                            key: _formKey,
                                            child: TextFormField(
                                                controller: gifController,
                                                validator: (valor) {
                                                  if (valor.isEmpty) {
                                                    return 'Informe um gif!';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.text,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        156, 156, 156, 1),
                                                    fontSize: 18.0),
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                    hintText: 'Gif',
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Color.fromRGBO(
                                                            168, 168, 179, 1)),
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 14.0,
                                                            bottom: 8.0,
                                                            top: 8.0),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              41, 41, 46, 1)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        new OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color: Colors.red,
                                                              width: 0.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        new OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color: Colors.red,
                                                              width: 0.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: Color.fromRGBO(
                                                              197,
                                                              197,
                                                              197,
                                                              1)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    labelText: "Nome do gif",
                                                    labelStyle: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Color.fromRGBO(
                                                            156,
                                                            156,
                                                            156,
                                                            1)))))),
                                    Container(
                                      margin: EdgeInsets.only(left: 8.0),
                                      width: 60,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(0, 222, 255, 1),
                                            Color.fromRGBO(0, 166, 255, 1)
                                          ],
                                          begin: FractionalOffset.centerLeft,
                                          end: FractionalOffset.centerRight,
                                        ),
                                      ),
                                      child: TextButton(
                                        child: Icon(
                                          Icons.search,
                                          size: 32.0,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          _getGifs();
                                        },
                                      ),
                                    ),
                                  ],
                                )))
                      ],
                    ),
                    Expanded(
                        child: snapshot.data["data"].isEmpty == false
                            ? _createGifTable(context, snapshot)
                            : Center(
                                child: Text(
                                'Você não buscou nenhum gif!',
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ))),
                  ],
                );
            }
          }),
    ));
  }
}
