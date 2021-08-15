import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeigth = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              height: screenHeigth*.7,
              child: Image.network(
                "https://www.pngitem.com/pimgs/m/332-3329752_invoice-png-hd-new-page-icon-png-transparent.png"
              )
            ),
          ),
          Container(
            height: screenHeigth*.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text(
                    'Enter new invoice'
                  ),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildPopupDialog(context),
                    );
                  },
                ),
                RaisedButton(
                  child: Text(
                      'Consult Invoice'
                  ),
                  onPressed: (){

                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context){
  return new AlertDialog(
    title: Text('Nuevo registro',
      style: TextStyle(

      ),
      textAlign: TextAlign.center,
    ),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              onPressed: () {

              },
              child: Text('Compras'),
            ),
            RaisedButton(
              onPressed: () {

              },
              child: Text('Ventas'),
            )
          ],
        ),

      ],
    ),

  );
}