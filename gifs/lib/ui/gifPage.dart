import 'package:flutter/material.dart';
import 'package:share/share.dart';



class GifPage extends StatelessWidget {

  final Map _gifData;

  // Construtor iniciando o gitData
  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData['title']),
        backgroundColor: Colors.black,
        // colocando botão de compartilhamento
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            // precisa de uma dependência!
            onPressed: (){
              // Compartilhando um link da imagem
              Share.share(_gifData['images']['fixed_height']['url']);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData['images']['fixed_height']['url']),
      ),
    );
  }
}