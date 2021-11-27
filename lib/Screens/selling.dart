import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:invoice_register/Database/user.dart';
import 'package:invoice_register/Database/helper.dart';
import 'package:invoice_register/Database/databaseHandler.dart';
import 'package:sqflite/sqflite.dart';

import '../list.dart';
import 'compras_consult.dart';

class selling extends StatefulWidget {
  @override
  _sellingState createState() => _sellingState();
}

class _sellingState extends State<selling> {
  final scaffolKey = GlobalKey<ScaffoldState>();

  DateTime selectedDate = DateTime.now();

  Future _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String dropDownValue = listTypeExpenses[0];
  List<String> elements = listTypeExpenses;

  TextEditingController invoiceNumber = TextEditingController();
  TextEditingController storeName = TextEditingController();
  TextEditingController invoiceSubtotal = TextEditingController();

  DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      //await this.addUsers();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffolKey,
      appBar: AppBar(title: Text("Nueva factura de venta")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10.0),
              child: Text(
                'Numero de factura',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: createTextView(
                  controller: invoiceNumber,
                  height: 50.0,
                  title: 'Factura numero',
                  hint: 'Ingrese un numero',
                  textInputType: TextInputType.number),
            ),
 

            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10.0),
              child: Text(
                'Valor subtotal 12%',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: createTextView(
                  controller: invoiceSubtotal,
                  height: 50.0,
                  title: 'Factura numero',
                  hint: 'Ingrese un numero',
                  textInputType: TextInputType.number),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 17.0),
              child: Text(
                'Fecha de consumo',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${selectedDate.toLocal()}'.split(" ")[0],
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    /*
                    print(invoiceNumber.text);
                    print(storeName.text);
                    print(invoiceSubtotal.text);
                    print('${selectedDate.toLocal()}'.split(" ")[0]);
                    print(dropDownValue);
                    */

                    String number = invoiceNumber.text;
                    String subtotal = invoiceSubtotal.text;
                    String date = '${selectedDate.toLocal()}'.split(" ")[0];
                    
                    String concept = "venta";

                    int dayR = selectedDate.day;
                    int monthR = selectedDate.month;
                    int yearR = selectedDate.year;

                    saveDataInvoice(number, subtotal, date, concept, dayR, monthR, yearR);
                  },
                  child: Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: deleteInfo,
                  child: Text('Borrar'),
                ),
              ],
            ),
            SizedBox(
              height: 25.2,
            ),
          ],
        ),
      ),
    );
  }

  saveDataInvoice(String number, String subtotal, String date,
      String concept, int dayR, int monthR, int yearR) async {
    //await this.addUsers();

    if (invoiceNumber.text == "" ||
        invoiceSubtotal.text == '') {
      showSnackBar("Todos los campos deben ser llenados", scaffolKey, Colors.red);
    } else {
      addUsers(number, subtotal, date, concept, dayR, monthR, yearR);
      showSnackBar("Datos guardados", scaffolKey, Colors.green);
    }
  }

  Future<int> addUsers(String number, String subtotal,
      String date, String concept, int dayR, int monthR, int yearR) async {
    user firstUser = user(
        invoiceNumber: number,
        date: date,
        subtotal: subtotal,
        concept: concept,
        dayR: dayR,
        monthR: monthR,
        yearR: yearR,
        );

    List<user> listOfUser = [firstUser];
    return await this.handler.insertUser(listOfUser);
  }

  deleteInfo() {
    invoiceNumber.text = '';
    storeName.text = '';
    invoiceSubtotal.text = '';
  }
}
