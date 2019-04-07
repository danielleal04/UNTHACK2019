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
import 'package:barcode_prototype/content.dart'; 

Container textFormat (input, helper) {

  // Format of Both Username and Password 
  return Container (

    width: 325.0,

    child:TextField (

      controller: input,
      maxLines: 1, 

      decoration: InputDecoration(

        border: OutlineInputBorder(

          borderSide: BorderSide(color: Colors.black, width: 1.0),

        ),
        hintText: helper, 
      ),
    )
  );
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {

  ListView listsAllergies () {

    return ListView(
      scrollDirection: Axis.vertical,
        children: values.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: values[key],
            onChanged: (bool value) {
              setState(() {
                values[key] = value;
              });
            },
          );
        }).toList(),
    ); 

  }

  final loginTopBar = new AppBar(
    backgroundColor: Colors.white, 
    centerTitle: true,
    elevation: 1.0,
    title: SizedBox(
        height: 35.0, child: Image.asset("assets/images/CanYouEatItLogo.png")),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: loginTopBar,
          body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text (
                  "Information",
                  style: new TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.w300,
                    fontSize: 50.0,
                    fontFamily: 'Ewert'
                  ),  
                ), 
                SizedBox(height: 20.00),
                textFormat(firstName, "First Name"),
                SizedBox(height: 10.00), 
                textFormat(lastName, "Last Name"),
                SizedBox(height: 30.0), 
                Container(height: 200, width: 300, 
                  child: listsAllergies()
                ),
                SizedBox(height: 30.0,),
                RaisedButton(
                  child: Text("scan"),

                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context) => Content())); 

                  }, 

                ),
              ],
            ),
          ), 
        )

      ), 
      

    );
  }

}