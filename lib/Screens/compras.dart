import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:invoice_register/Database/user.dart';
import 'package:invoice_register/Database/helper.dart';
import 'package:invoice_register/Database/databaseHandler.dart';
import 'package:sqflite/sqflite.dart';

import '../list.dart';
import 'compras_consult.dart';

class compras extends StatefulWidget {
  @override
  _comprasState createState() => _comprasState();
}

class _comprasState extends State<compras> {
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
    String invoiceNumberR, typeInvoiceR, storeNameR, invoiceDateR;
    double subtotalInvoiceR;

    return Scaffold(
      key: scaffolKey,
      appBar: AppBar(title: Text("Nueva factura de compra")),
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
                'Tipo de factura',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: DropdownButton(
                value: dropDownValue,
                iconSize: 24,
                elevation: 16,
                onChanged: (String newValue) {
                  setState(() {
                    dropDownValue = newValue;
                  });
                },
                items: elements.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text("$value"),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 17.0),
              child: Text(
                'Nombre del establecimiento',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: createTextView(
                controller: storeName,
                height: 50.0,
                title: 'Nombre del comercio',
                hint: 'Ingrese un nombre',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10.0),
              child: Text(
                'Valor subtotal 12% (No el total)',
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

                    String number = invoiceNumber.text;
                    String store = storeName.text;
                    String subtotal = invoiceSubtotal.text;
                    String date = '${selectedDate.toLocal()}'.split(" ")[0];
                    String type = dropDownValue;
                    String concept = "compra";

                    int dayR = selectedDate.day;
                    int monthR = selectedDate.month;
                    int yearR = selectedDate.year;

                    saveDataInvoice(number, store, subtotal, date, type, concept,
                                    dayR, monthR, yearR);

                    

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

  saveDataInvoice(String number, String store, String subtotal, String date,
      String type, String concept, int dayR, int monthR, int yearR) async {
    //await this.addUsers();

    if (invoiceNumber.text == "" ||
        storeName.text == '' ||
        invoiceSubtotal.text == '') {
      showSnackBar("Todos los campos deben ser llenados", scaffolKey, Colors.red);
    } else {
      addUsers(number, store, subtotal, date, type, concept,
                dayR, monthR, yearR);
      showSnackBar("Datos guardados", scaffolKey, Colors.green);
    }
  }

  Future<int> addUsers(String number, String store, String subtotal,
      String date, String type, String concept, int dayR, int monthR, int yearR) async {
    user firstUser = user(
        invoiceNumber: number,
        type: type,
        storeName: store,
        date: date,
        subtotal: subtotal,
        concept: concept,
        dayR: dayR,
        monthR: monthR,
        yearR: yearR
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
