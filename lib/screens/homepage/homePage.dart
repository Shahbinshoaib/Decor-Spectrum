import 'dart:io';

import 'package:csv/csv.dart';
import 'package:decor_spectrum/screens/models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  double w1 = 0;
  bool isNextButtonPressed = false;
  bool isLoading = false;

  Customer customer = Customer(invoice: '',billTo: '',address: '',phone: '',
      fax: '',email: '',subTotal: 0,product: [Product(description: '',sku: '',color: '',quantity: 0,
          unitPrice: 0,total: 0)]);
  //List<Product> productList = [];
  Product product = Product(description: '',sku: '',color: '',quantity: 0,
      unitPrice: 0,total: 0);



  @override
  Widget build(BuildContext context) {

    final pdf = pw.Document();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    if(w<700) {
      w1 = w*1.9;
    }else{
      w1 = w;
    }

    getCsv2() async {

      var now = new DateTime.now();
      var formatter = new DateFormat('dd-MM-yyyy');
      String formattedDate = formatter.format(now);


      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.letter,
          build: (pw.Context context) {
            return pw.Container(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  //pw.Image(netImage,height: 100),
                  pw.Center(child: pw.Text('Decor Spectrum',style:
                  const pw
                      .TextStyle
                    (fontSize: 25))),
                  pw.SizedBox(height: 20),
                  pw.Center(child: pw.Text('Invoice #${customer.invoice}',style:
                  const pw
                      .TextStyle
                    (fontSize: 18))),
                  pw.SizedBox(height: 50),
                  pw.Text('Invoice Date: $formattedDate'),
                  pw.SizedBox(height: 3),
                  pw.Text('Bill To: ${customer.billTo}'),
                  pw.SizedBox(height: 3),
                  pw.Text('Address: ${customer.address}'),
                  pw.SizedBox(height: 3),
                  pw.Text('Phone: ${customer.phone}'),
                  pw.SizedBox(height: 3),
                  pw.Text('Fax: ${customer.fax}'),
                  pw.SizedBox(height: 3),
                  pw.Text('Email: ${customer.email}'),
                  pw.SizedBox(height: 15),
                  pw.Table(
                            defaultColumnWidth: const pw.FixedColumnWidth(60.0),
                            border: pw.TableBorder.all(
                                color: PdfColors.black,
                                style: pw.BorderStyle.solid,
                                width: 1),
                            children: [
                              pw.TableRow( children: [
                                pw.Padding(
                                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                                  child: pw.Column(children:[pw.Text('DESCRIPTION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))]),
                                ),
                                pw.Padding(
                                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                                    child: pw.Column(children:[pw.Text('SKU', style:  pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))]),

                                ),
                                pw.Padding(
                                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                                    child: pw.Column(children:[pw.Text('COLOR /GLOBE', style:  pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))]),

                                ),
                                pw.Padding(
                                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                                    child:pw.Column(children:[pw.Text('QUANTITY', style:  pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))]),

                                ),
                                 pw.Padding(
                                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                                    child:pw.Column(children:[pw.Text('UNIT PRICE', style:  pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))]),

                                 ),
                                pw.Padding(
                                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                                    child: pw.Column(children:[pw.Text('Total', style:  pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))]),

                                ),
                               ]),
                            ],
                          ),
                  pw.ListView.builder(
                    itemCount: customer.product.length,
                    itemBuilder: (context,index){
                      return pw.Table(
                        defaultColumnWidth: const pw.FixedColumnWidth(60.0),
                        border: pw.TableBorder.all(
                            color: PdfColors.black,
                            style: pw.BorderStyle.solid,
                            width: 1),
                        children: [
                          pw.TableRow( children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Center(child:pw.Text(customer.product[index].description)),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Center(child:pw.Text(customer.product[index].sku)),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Center(child:pw.Text(customer.product[index].color)),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Center(child:pw.Text(customer.product[index].quantity.toString())),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Center(child:pw.Text(customer.product[index].unitPrice.toString())),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Center(child:pw.Text(customer.product[index].total.toString())),
                            ),
                          ]),
                        ],
                      );
                    }
                  ),
                  pw.Table(
                    defaultColumnWidth: const pw.FixedColumnWidth(60.0),
                    border: pw.TableBorder.all(
                        color: PdfColors.black,
                        style: pw.BorderStyle.solid,
                        width: 1),
                    children: [
                      pw.TableRow( children: [
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 2),
                          child: pw.Center(child:pw.Text('Subtotal', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 2),
                          child: pw.Center(child:pw.Text(customer.subTotal.toStringAsFixed(2))),
                        ),
                      ]),
                      pw.TableRow( children: [
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 2),
                          child: pw.Center(child:pw.Text('HST 13%', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 2),
                          child: pw.Center(child:pw.Text((customer.subTotal*0.13).toStringAsFixed(2))),
                        ),
                      ]),
                      pw.TableRow( children: [
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 2),
                          child: pw.Center(child:pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 2),
                          child: pw.Center(child:pw.Text((customer.subTotal+(customer.subTotal*0.13)).toStringAsFixed(2))),
                        ),
                      ]),
                      pw.TableRow( children: [
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 2),
                          child: pw.Center(child:pw.Text('30% Deposit', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 2),
                          child: pw.Center(child:pw.Text(((customer.subTotal+(customer.subTotal*0.13))*0.3).toStringAsFixed(2))),
                        ),
                      ]),
                      pw.TableRow( children: [
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 2),
                          child: pw.Center(child:pw.Text('Balance due', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 2),
                          child: pw.Center(child:pw.Text(((customer.subTotal+(customer.subTotal*0.13))-((customer.subTotal+(customer.subTotal*0.13))*0.3)).toStringAsFixed(2))),
                        ),
                      ]),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('Note: Orders once confirmed and deposit received, CANNOT BE CANCELED. '
                      'DELIVERIES 90-100 DAYS AFTER ORDER CONFIRMATION. Shipping charges are'
                      ' to be borne by the buyer. Balance due upon shipment dispatch.',
                     style: pw.TextStyle(fontSize: 7)),
                ]
              )
            );
          })); //
      // String dir = "${(awaitgetExternalStorageDirectory())!.absolute.path}/documents";
      // final file = File("${customer.invoice}/example.pdf");
      //var file = "$dir";
      //print( " FILE " + file);
      //File f = new File("_EQuiz_quiz.csv");
      //await f.writeAsBytes(await pdf.save());

      // var file = "$dir";
      // print( " FILE " + file);
      // File f = new File("_EQuiz_quiz.csv");
      // String csv = const ListToCsvConverter().convert(rows);
      // f.writeAsString(csv);

      // OpenFile.open("${customer.invoice}/example.pdf");
      // final output = await getTemporaryDirectory();
      // final file = File("${output.path}/example.pdf");
      String dir = "${(await getExternalStorageDirectory())!.absolute.path}/invoice";
      var file = dir;
      File f = File("$file ${customer.invoice}.pdf");
      //String csv = const ListToCsvConverter().convert(rows);
      await f.writeAsBytes(await pdf.save());
      OpenFile.open("$file ${customer.invoice}.pdf");
      setState((){
        isLoading = false;
        customer.subTotal = 0;
        customer = Customer(invoice: '',billTo: '',address: '',phone: '',
            fax: '',email: '',subTotal: 0,product: [Product(description: '',sku: '',color: '',quantity: 0,
                unitPrice: 0,total: 0)]);
        product = Product(description: '',sku: '',color: '',quantity: 0,
            unitPrice: 0,total: 0);
      });
    }

    return isLoading ? Center(child: const CircularProgressIndicator()) : Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: h,
            width: w,
            child: Image.asset('assets/IMG_4640-scaled.jpg',fit:
            BoxFit.cover,),
          ),
          SingleChildScrollView(
            child: Container(
             // height: h*0.9,
              width: w1*0.5,
              child: Card(
                color: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isNextButtonPressed ? Container() :
                        SizedBox(height: h*0.04,),
                        isNextButtonPressed ? Container() :
                        Image.asset('assets/ic_launcher.png',
                        height: 150,),
                        isNextButtonPressed ? Container() :
                        const SizedBox(height: 15,),
                        isNextButtonPressed ? Container() :
                        const Text('Invoice Form',style: TextStyle(fontSize: 25,
                            fontWeight:
                            FontWeight.bold,
                          color: Colors.white70
                        ),),
                        const SizedBox(height: 20,),
                        isNextButtonPressed ?
                        Container(
                          //width: w1*0.4,
                          height: h*0.83,
                          child: ListView.builder(
                            itemCount: customer.product.length ,
                            itemBuilder: (context,index){
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Product ${index+1}',style:
                                    const TextStyle
                                      (color: Colors.orangeAccent,
                                        fontSize: 20),),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: w1*0.32,
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          onChanged: (value) {
                                            setState(() {
                                              customer.product[index]
                                              .description = value;
                                            });
                                          },
                                          style: const TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            focusColor: Colors.white70,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide:
                                              const BorderSide(color: Colors.white54, width: 1.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                              const BorderSide(color: Colors.orangeAccent,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            fillColor: Colors.white,
                                            labelText: 'Description',
                                            labelStyle: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5,),
                                      Expanded(
                                        child: Container(
                                          //width: w1*0.15,
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            onChanged: (value) {
                                              setState(() {
                                                customer.product[index].sku =
                                                    value;
                                              });
                                            },
                                            style: const TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              focusColor: Colors.white70,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide:
                                                const BorderSide(color: Colors.white54, width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                const BorderSide(color: Colors.orangeAccent,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              fillColor: Colors.white,
                                              labelText: 'SKU',
                                              labelStyle: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: TextFormField(
                                            keyboardType: TextInputType.name,
                                            onChanged: (value) {
                                              setState(() {
                                                customer.product[index].color = value;
                                              });
                                            },
                                            style: const TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              focusColor: Colors.white70,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide:
                                                const BorderSide(color: Colors.white54, width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                const BorderSide(color: Colors.orangeAccent,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              fillColor: Colors.white,
                                              labelText: 'Color/Globe',
                                              labelStyle: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5,),
                                      Expanded(
                                        child: Container(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              setState(() {
                                                customer.product[index].quantity = double.parse(value);
                                                customer.product[index].total = customer.product[index].unitPrice * customer.product[index].quantity;

                                              });
                                            },
                                            style: const TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              focusColor: Colors.white70,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide:
                                                const BorderSide(color: Colors.white54, width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                const BorderSide(color: Colors.orangeAccent,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              fillColor: Colors.white,
                                              labelText: 'Quantity',
                                              labelStyle: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5,),
                                      Expanded(
                                        child: Container(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              setState(() {
                                                customer.product[index].unitPrice = double.parse(value);
                                                customer.product[index].total = customer.product[index].unitPrice * customer.product[index].quantity;
                                              });
                                            },
                                            style: const TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              focusColor: Colors.white70,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide:
                                                const BorderSide(color: Colors.white54, width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                const BorderSide(color: Colors.orangeAccent,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              fillColor: Colors.white,
                                              labelText: 'Unit Price',
                                              labelStyle: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  customer.product.length != index+1 ? Container() :
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      Row(
                                        children: [
                                          customer.product.length < 2 ?
                                          Container() :
                                          ButtonTheme(
                                            minWidth: 50,
                                            height: 50,
                                            shape: RoundedRectangleBorder(borderRadius:
                                            BorderRadius.circular(10)),
                                            child: RaisedButton(
                                              onPressed: (){
                                                setState(() {
                                                  customer.product.removeAt(customer.product.length-1);
                                                });
                                              },
                                              color: Colors.orangeAccent,
                                              child:  const Text('-',style:
                                              TextStyle(color:
                                              Colors.black,fontWeight: FontWeight.bold,
                                                  fontSize: 20),),
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          ButtonTheme(
                                            minWidth: 50,
                                            height: 50,
                                            shape: RoundedRectangleBorder(borderRadius:
                                            BorderRadius.circular(10)),
                                            child: RaisedButton(
                                              onPressed: (){
                                                setState(() {
                                                  customer.product.add(product);

                                                });
                                              },
                                              color: Colors.orangeAccent,
                                              child:  const Text('+',style:
                                              TextStyle(color:
                                              Colors.black,fontWeight: FontWeight.bold,
                                                  fontSize: 20),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  isNextButtonPressed && customer.product.length != index+1 ? Container() :
                                  ButtonTheme(
                                    minWidth: 350,
                                    height: 50,
                                    shape: RoundedRectangleBorder(borderRadius:
                                    BorderRadius.circular(10)),
                                    child: RaisedButton(
                                      onPressed: ()async{
                                        setState((){
                                          isNextButtonPressed = false;
                                          isLoading = true;

                                        });

                                        for(int i = 0;i < customer.product.length ; i++){
                                          customer.subTotal += customer.product[i].total;
                                        }

                                        getCsv2();

                                      },
                                      color: Colors.orangeAccent,
                                      child: const Text('Submit',style: TextStyle
                                        (color:
                                      Colors.black,fontWeight: FontWeight.bold,
                                          fontSize: 20),),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  isNextButtonPressed && customer.product.length != index+1 ? Container() :
                                  ButtonTheme(
                                    minWidth: 350,
                                    height: 50,
                                    shape: RoundedRectangleBorder(borderRadius:
                                    BorderRadius.circular(10)),
                                    child: RaisedButton(
                                      onPressed: (){
                                        setState(() {
                                          isNextButtonPressed = !isNextButtonPressed;
                                        });
                                      },
                                      color: isNextButtonPressed ? Colors.white38 :
                                      Colors.orangeAccent,
                                      child:  Text( isNextButtonPressed ? 'Back' : 'N'
                                          'ext',
                                        style: const TextStyle
                                          (color:
                                        Colors.black,fontWeight: FontWeight.bold,
                                            fontSize: 20),),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                ],
                              );
                            },
                          ),
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 350,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    customer.invoice = value;
                                  });
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  focusColor: Colors.white70,
                                  prefixIcon: const Icon(
                                    Icons.numbers,
                                    color: Colors.white70,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                    const BorderSide(color: Colors.white54, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.orangeAccent,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: Colors.white,
                                  hintText: "000000",
                                  //make hint text
                                  hintStyle:  const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  labelText: 'Invoice number',
                                  labelStyle: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              width: 350,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  setState(() {
                                    customer.billTo = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusColor: Colors.white70,
                                  prefixIcon: const Icon(
                                    Icons.person_outline_rounded,
                                    color: Colors.white70,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                    const BorderSide(color: Colors.white54, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.orangeAccent, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: Colors.white54,
                                  hintText: "Mr.",
                                  //make hint text
                                  hintStyle:  const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  labelText: 'Bill to',
                                  labelStyle: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              width: 350,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.streetAddress,
                                onChanged: (value) {
                                  setState(() {
                                    customer.address = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusColor: Colors.white70,
                                  prefixIcon: const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white70,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                    const BorderSide(color: Colors.white54, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.orangeAccent, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: Colors.white54,
                                  hintText: "House #",
                                  //make hint text
                                  hintStyle:  const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  labelText: 'Address',
                                  labelStyle: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              width: 350,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  setState(() {
                                    customer.phone = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusColor: Colors.white70,
                                  prefixIcon: const Icon(
                                    Icons.phone_android,
                                    color: Colors.white70,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                    const BorderSide(color: Colors.white54, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.orangeAccent, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: Colors.white54,
                                  hintText: "03",
                                  //make hint text
                                  hintStyle:  const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  labelText: 'Phone',
                                  labelStyle: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              width: 350,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  setState(() {
                                    customer.fax = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusColor: Colors.white70,
                                  prefixIcon: const Icon(
                                    Icons.fax,
                                    color: Colors.white70,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                    const BorderSide(color: Colors.white54, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.orangeAccent, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: Colors.white54,
                                  hintText: "#",
                                  //make hint text
                                  hintStyle:  const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  labelText: 'Fax',
                                  labelStyle: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              width: 350,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {
                                    customer.email = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusColor: Colors.white70,
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.white70,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                    const BorderSide(color: Colors.white54, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.orangeAccent, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: Colors.white54,
                                  hintText: "abc@gmail.com",
                                  //make hint text
                                  hintStyle:  const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        isNextButtonPressed ? Container() :
                        ButtonTheme(
                          minWidth: 350,
                          height: 50,
                          shape: RoundedRectangleBorder(borderRadius:
                          BorderRadius.circular(10)),
                          child: RaisedButton(
                            onPressed: (){
                              setState(() {
                                isNextButtonPressed = !isNextButtonPressed;
                              });
                            },
                            color: isNextButtonPressed ? Colors.white54 :
                            Colors.orangeAccent,
                            child:  Text( isNextButtonPressed ? 'Back' : 'N'
                                'ext',
                              style: const TextStyle
                              (color:
                            Colors.black,fontWeight: FontWeight.bold,
                                fontSize: 20),),
                          ),
                        ),
                        SizedBox(height: h*0.02,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
