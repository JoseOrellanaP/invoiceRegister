import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:invoice_register/Database/user.dart';
import 'package:invoice_register/Database/helper.dart';
import 'package:invoice_register/Database/databaseHandler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'dart:math';

import '../list.dart';

class invoiceConsult extends StatefulWidget {
  final DateTime initialDate;
  const invoiceConsult({Key key, this.initialDate}) : super(key: key);

  @override
  _invoiceConsult createState() => _invoiceConsult();
}

class _invoiceConsult extends State<invoiceConsult> {
  DatabaseHandler handler = new DatabaseHandler();

  DateTime selectedDate;

  @override
  void initState() {
    selectedDate = widget.initialDate;
  }

  String total(snapshot){
    
    return snapshot.data[1].subtotal;
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;

    double totalSel =0.0;
    double totalBuy = 0.0;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: this
              .handler
              .retrieveUsers(selectedDate.year, selectedDate.month),
          builder: (BuildContext context,
              AsyncSnapshot<List<user>> snapshot) {
            if (snapshot.hasData) {

              String totalSell =totalSells(snapshot, 'venta');
              String totalBuy = totalSells(snapshot, 'compra');
              double different = diferencia(totalSell, totalBuy);
              double ivaPagar = valorIva(different);

              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4.0,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Resumen de consumos',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),),
                              trailing: Icon(Icons.fact_check),
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total ventas:'),
                                      Text("\$ "+totalSell)
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Compras:'),
                                      Text("\$ "+totalBuy)
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Diferencia:'),
                                      Text("\$ "+"$different")
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Iva a pagar 12%:'),
                                      Text("\$ "+"$ivaPagar")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Historial',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold
                            ),),
                  ),
                  Expanded(
                    child: Container(
                      height: screen_height * .8,
                      width: screen_width,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(Icons.delete_forever),
                            ),
                            key: ValueKey<int>(snapshot.data[index].id),
                            onDismissed:
                                (DismissDirection direction) async {
                              await this
                                  .handler
                                  .deleteUser(snapshot.data[index].id);
                              setState(() {
                                snapshot.data
                                    .remove(snapshot.data[index]);
                              });
                            },
                            child: Card(
                              elevation: 3.0,
                              child: ListTile(
                                contentPadding: EdgeInsets.all(8.0),
                                title: Text(snapshot.data[index].date),
                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8,),
                                    Text('Factura Nro: '+snapshot.data[index].invoiceNumber),
                                    SizedBox(height: 5,),
                                    Text('Subtotal: \$'+snapshot.data[index].subtotal),
                                    SizedBox(height: 5,),
                                    Text('Concepto: '+snapshot.data[index].concept),
                                    /*
                                    Text("${snapshot.data[index].monthR}"),
                                    Text("${snapshot.data[index].yearR}"),
                                    Text("${snapshot.data[index].dayR}"),
                                    */
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }


  String totalSells(AsyncSnapshot snapshot, String concept){
    int leng = snapshot.data.length;
    String subtotalBuy;
    double subtotalSell = 0;
    double subtotalB = 0;

    for (int i=0; i<leng; i++){
      if(snapshot.data[i].concept == concept){
        subtotalBuy = double.parse(snapshot.data[i].subtotal).toStringAsFixed(2);
        subtotalB = double.parse(subtotalBuy);
        
        
        
        // Convert it to string
        subtotalSell = subtotalB + subtotalSell;
      }
    }
    return '$subtotalSell';
  }

  double diferencia(String totalVentas, String totalCompras){
    double totalselling = double.parse(totalVentas);
    double totalbuying = double.parse(totalCompras);
    return (totalselling - totalbuying);
  }

  double valorIva(double baseIVA){
    double ivaEcu = 0.12;
    return double.parse((baseIVA * ivaEcu).toStringAsFixed(2));
  }




}
