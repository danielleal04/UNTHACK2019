import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
//
import 'package:barcode_prototype/main.dart';

class Content extends StatefulWidget {
  @override
  _Content createState() => new _Content();
}

class _Content extends State<Content> {

  String barcode = "";
  String token = "5vd0a9x2aeqtcr42b7nz4tngej773n";
  @override
  initState() {
    super.initState();
  }

  String checkForAllergies (String ingredients) {

    String lowerIngredients = ingredients.toLowerCase(); 
    var entryList = values.entries.toList();
    String allergensFound = ""; 

    for (int i = 0; i < values.length; i++){

      if (lowerIngredients.contains(entryList[i].key) && entryList[i].value) 
      {

        allergensFound = allergensFound + entryList[i].key.toString() + " "; 

      }
        
    }

    if (allergensFound == "")
      allergensFound = "None";

    return allergensFound; 

  }

  Future<Map<String,dynamic>> getData() async {

    var url = "https://api.barcodelookup.com/v2/products?barcode=${barcode}&formatted=y&key=${token}";
    var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var jsondata = jsonDecode(response.body); 

    return jsondata; 

  }

  FutureBuilder<Map<String,dynamic>> displayInfo (Function function) {

    return FutureBuilder(
      future: function(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Container (
              
              decoration: BoxDecoration(

                border: Border(
                  bottom: BorderSide(

                    color: Colors.black12,

                  )
                ),

              ),

              child: Padding (
                padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                child: Row (

                  children: <Widget>[
                    Flexible (

                      child: Container(
                        child: Text.rich(
                          TextSpan(

                            children: <TextSpan> [

                              TextSpan(
                                text: "${snapshot.data['products'][0]['product_name']}\n\n", 
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              
                              TextSpan(
                                text: "Barcode: ${barcode}\n\n",                          
                                style: TextStyle(fontWeight: FontWeight.w400), 
                              ),

                              TextSpan(
                                text: "Description: ${snapshot.data['products'][0]['description']}\n\n",                          
                                style: TextStyle(fontWeight: FontWeight.w400), 
                              ),

                              TextSpan(
                                text: "Ingredients: ${snapshot.data['products'][0]['ingredients']}\n\n",                          
                                style: TextStyle(fontWeight: FontWeight.w400), 
                              ),

                              TextSpan(
                                text: "Allergies: ${checkForAllergies(snapshot.data['products'][0]['ingredients'])}",                          
                                style: TextStyle(fontWeight: FontWeight.w400), 
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                )
              )
            );
          case ConnectionState.none: 
            return Center (child: Text("No information to show"),);
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    ); 

  }

  void _showDialog() {

    showDialog(

      context: context, 
      builder: (BuildContext context) {

        return SingleChildScrollView(

          child: AlertDialog(

            title: Text("Information"),
            content: displayInfo(getData), // displays info 

            actions: <Widget>[

              FlatButton(

                child: Text("ok"), 
                onPressed: () {

                  Navigator.of(context).pop(); 

                },

              ),

            ],

          ),

        );

      }

    );

  }

  // Method for scanning barcode....
Future barcodeScanning() async {
//imageSelectorGallery();

    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      getData(); 
      _showDialog();

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Tap to Scan'),
          ),
          body: Center(

                  child: SizedBox(
                    height: 200.0,
                    width: 200.0,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.camera_alt, size: 200.0),
                      onPressed: () {

                        barcodeScanning(); 

                      },
                    ),
                  ), 

                ), 
                
            ), 
          );
  }
}