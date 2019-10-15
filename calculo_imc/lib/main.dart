import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

// Comando para gerar é só colocar stfull que ele auto-completa
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _infoText = "Informe seus dados!";

  // Criando um objeto sem a necessidade do new
  TextEditingController weightController = TextEditingController(); 
  TextEditingController heightController = TextEditingController(); 

  // para validar
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetFilds() {
    //não precisa pois são controladores
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      // para tirar as msg vermelhas
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      print(imc);
      if (imc < 18.6) {
        // informando a quantidade de numeros que irá aparecer
        _infoText = "Abaixo do Peso (${imc.toStringAsPrecision(3)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = "Peso Ideal (${imc.toStringAsPrecision(3)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = "Sobrepeso (${imc.toStringAsPrecision(3)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = "Obesidade Grau 1 (${imc.toStringAsPrecision(3)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = "Obesidade Grau 2 (${imc.toStringAsPrecision(3)})";
      } else {
        _infoText = "Obesidade Grau 3 (${imc.toStringAsPrecision(3)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usa o Scaffold para ter acesso ao drawer, appbar entre outros. olhar -> https://api.flutter.dev/flutter/material/Scaffold-class.html
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora de IMC"),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFilds,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        // adicionou a ScrollView para evitar que o teclado cubra os inputs
        body: SingleChildScrollView(
          // é possivel aplicar o padding pois é uma propriedade do SingleChildScrollView
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              // ele vai esticar todo o eixo horizontal
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // filhos da nossa coluna
              children: <Widget>[
                Icon(
                  Icons.person_outline,
                  size: 120,
                  color: Colors.green,
                ),
                // campo onde podemos digitar algum texto. Nesse caso uma entrada de números
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Peso (Kg)",
                      labelStyle: TextStyle(color: Colors.green)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25),
                  //informando o controlodor do peso
                  controller: weightController, 
                  // propriedade do TextFormField
                  validator: (value) {
                    if(value.isEmpty){
                      return "Insira seu peso!";
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Altura (cm)",
                      labelStyle: TextStyle(color: Colors.green)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25),
                  // para pegar os valores de forma fácil
                  controller: heightController, 
                  validator: (value) {
                    if(value.isEmpty){
                      return "Insira sua altura!";
                    }
                  },
                ),
                // no caso de querer aplicar um padding em um container
                Padding(
                  // outra maneira de add
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  // Funciona como uma div
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          _calculate();
                        }
                      },
                      color: Colors.green,
                      child: Text(
                        "Calcular",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  _infoText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
