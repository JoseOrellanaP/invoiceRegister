


import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:invoice_register/Screens/compras_consult.dart';
import 'package:invoice_register/Screens/selling.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_porter/sqflite_porter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:share_extend/share_extend.dart';

import 'package:invoice_register/Database/databaseHandler.dart';

import 'compras.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate;
  DatabaseHandler handler = new DatabaseHandler();

  

  @override
  void initState() {
    selectedDate = DateTime.now();

    
    

  }

 

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeigth = MediaQuery.of(context).size.height;
    

    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
                height: screenHeigth * .7,
                child: Image.asset('assets/invoice_image.png'), 
                    ),
          
          
          ),
          Container(
            height: screenHeigth * .1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Nueva factura'),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)
                      )
                    )
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('   Consultas    '),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)
                      )
                    ),
                  ),
                  onPressed: () {
                    selectDate();
                  },
                )
              ],
            ),
          ),
          SizedBox(height: 15.0,),
          ElevatedButton(
            child: Text('Exportar datos'),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white)
                )
              )
            ),
            onPressed: (){
              setState(() {
                
                exportData();
                
              });
            },
          ),
        ],
      ),
    );
  }



  exportData() async{


    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();




    var tableD = await DatabaseHandler().getAllData();
    print(tableD.length);

    List<List<dynamic>> rows = [];
    List<dynamic> row = [];

    row.add('id');
    row.add('invoiceNumber');
    row.add('type');
    row.add('storeName');
    row.add('subtotal');
    row.add('date');
    row.add('concept');
    row.add('dayR');
    row.add('monthR');
    row.add('yearR');

    rows.add(row);
    

    for(int i=0; i<tableD.length; i++){
      List<dynamic> row = [];
      row.add(i+1);
      row.add(tableD[i]['invoiceNumber']);
      row.add(tableD[i]['type']);
      row.add(tableD[i]['storeName']);
      row.add(tableD[i]['subtotal']);
      row.add(tableD[i]['date']);
      row.add(tableD[i]['concept']);
      row.add(tableD[i]['dayR']);
      row.add(tableD[i]['monthR']);
      row.add(tableD[i]['yearR']);

      rows.add(row);
    }


    String csv = const ListToCsvConverter().convert(rows);

    String dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
    print('dir $dir');

    String file = "$dir";
    File f = File(file + '/filename.csv');
    f.writeAsString(csv);


    showAlertDialog(context, f);
    //shareFile(f);
    

  }



showAlertDialog(BuildContext context, File f) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancelar"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Compartir"),
    onPressed:  () {
      shareFile(f);
      
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Exportado a descargas"),
    content: Text("¿Te gustaría compartir el archivo exportado?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

}




  void shareFile(File f) async{
    //Directory dir = await getApplicationDocumentsDirectory();
    if(!await f.exists()){
      await f.create(recursive: true);
      f.writeAsString('Text');
    }
    ShareExtend.share(f.path, 'file');
    
    
    Navigator.pop(context);
    
  }

  void selectDate() {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: selectedDate ?? selectedDate,
      locale: Locale("es"),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          print('Year: ${selectedDate.year}\nMonth: ${selectedDate.month}');

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => invoiceConsult(
                initialDate: selectedDate,
              )));


              
        });
      }
    });
  }
}





Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: Text(
      'Nuevo registro',
      style: TextStyle(),
      textAlign: TextAlign.center,
    ),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => compras()));
              },
              child: Text('Compras'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => selling()));
              },
              child: Text('Ventas'),
            )
          ],
        ),
      ],
    ),
  );
}
