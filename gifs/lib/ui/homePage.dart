// json
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gifs/ui/gifPage.dart';

import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offSet = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    //quando o app é carregado e não há nenhuma pesquisa
    if (_search == null || _search.isEmpty) {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=LwdJZpqkuetGyn9dDRF9d5RdiJ5pZ6HN&limit=20&rating=G');
    } else {
      //quando temos uma pesquisa
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=LwdJZpqkuetGyn9dDRF9d5RdiJ5pZ6HN&q=$_search&limit=19&offset=$_offSet&rating=G&lang=en');
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
        centerTitle: true,
      ),
      //colocando toda a cor da tela
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Pesquisar',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.justify,
              // quando o botão do teclado enviar for pressionado
              onSubmitted: (text) {
                // sempre que for alterado o FutureBuilder vai ser recarregado e consequentemente a função getGifs será chamada
                setState(() {
                  _search = text;
                  // seta pra zero para reiniciar quando mudar o texto
                  _offSet = 0;
                });
              },
            ),
          ),
          Expanded(
            // para montar quando for carregado
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      //especificando o alinhamento do circulo no centro
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    // caso o usuário ainda não tenha digitado nada
    if (_search == null || _search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //quantidade de itens na horizontal
        crossAxisCount: 2,
        // espaçamento na horizontal
        crossAxisSpacing: 10,
        // espaçamento na vertical
        mainAxisSpacing: 10,
      ),
      // quantidade de item que será mostrado na tela
      itemCount: _getCount(snapshot.data['data']),
      // precisa receber uma função que irá passar a posiçãod e cada item
      // a cada item construido sera chamado essa função
      itemBuilder: (context, index) {
        //se não tiver pesquisando, ou se não é último item, ele mostra:
        if (_search == null || index < snapshot.data['data'].length || _search.isEmpty) {
          // GestureDetector pois é possível clicar na imagem e daí executar uma ação
          // caso queira uma imagem estática apenas retorna um widget com uma imagem dentro do container.
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              //enquanto carrega o efeito, ele coloca essa imagem estática transparente
              placeholder: kTransparentImage,
              image: snapshot.data['data'][index]['images']['fixed_height']['url'],
              height: 300,
              // para cobrir a área
              fit: BoxFit.cover,
            ),
            // quando tocar na imagem. Lembrando que só é possivel pois está dentro do GestureDetector
            onTap: (){
              /**
               * @param context: contexto
               * @param route: caminho para a próxima tela
               */
              Navigator.push(context, MaterialPageRoute(builder: (context) => GifPage(snapshot.data['data'][index])));
            },
            // quando segurar, aparecer a opção de compartilhar
            onLongPress: (){
              Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
            },
          );
          // caso seja o ultimo indice
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                // alinhamento no eixo vertical
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    'Carregar mais...',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )
                ],
              ),
              // quaando clicar ele carrega + 19 de outra página
              onTap: (){
                setState(() {
                  _offSet += 19;
                });
              },
            ),
          );
        }
      },
    );
  }
}
