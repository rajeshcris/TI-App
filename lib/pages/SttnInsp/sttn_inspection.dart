import 'package:flutter/material.dart';
import 'package:ti/commonutils/ti_utilities.dart';
import 'package:ti/model/SttnInspModels/sttnInspModel.dart';
////import 'package:fois_mobileapp/Pages/home.dart';
//import
import 'package:ti/model/SttnInspModels/cautionOrdRegModel.dart';
import 'caution_or_reg.dart';
import 'package:ti/commonutils/commonUtilities.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class SttnInspection extends StatefulWidget {
  @override
  _SttnInspectionState createState() => _SttnInspectionState();
}

class _SttnInspectionState extends State<SttnInspection> {
  final items = ['item1', 'item2'];
  var selectedItemValue = [];
  var pageLinks = ['caution_or_reg', 'train_failure'];
  var links;

  Future<List<String>> getData() async {
    print("In get data .");

    //var data = await http.get(Uri.parse("http://172.16.4.58:8080/DemoService/webapi/demoservice/getIt4"));
    var data = await SttnInspectionModel.getData();
    print("In get data .2");
    print(data);

    links = await SttnInspectionModel.getLinks();
    //var jsonData = json.decode(data.body);
    //List<SttnInsp> sttninsp = [] ;
    //for(var s in jsonData){
    //  SttnInsp sttn = SttnInsp(s["index"], s["options"]);
    //  sttninsp.add(sttn);
    //}
    print(data.length);
    return data;
  }

  //final List<String> entries = SttnInspectionModel.getData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TiUtilities.tiAppBar(context, "Station Inspection"),
        body: Container(
          child: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text('Loading....'),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      //   for(int i = 0;i < snapshot.data.length ; i++ ){
                      //      selectedItemValue.add("item1");
                      // }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 4.0),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              print('/caution_or_reg:::::' +
                                  snapshot.data[index] +
                                  links[index]);
                              Navigator.pushNamed(context, '/' + links[index]);
                              //Navigator.pushNamed(context, '/cmra' );
                            },
                            title: Text(snapshot.data[index]),
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Icon(
                                Icons.navigate_next_outlined,
                                color: Colors.white,
                              ),
                            ),
                            /*   trailing: DropdownButton<String>(
                            value: selectedItemValue[index].toString(),
                            items: items.map((String dropDownStringItem){
                              return DropdownMenuItem<String>(
                                   value:  dropDownStringItem,
                                   child:  Text(dropDownStringItem)
                              );
                            }).toList(),
                            onChanged: (newSelectedValue){
                              setState(() {
                                this.selectedItemValue[index] = newSelectedValue ;
                              });
                            },

                          ),*/
                          ),
                          color: Colors.grey[100],
                        ),
                      );
                    });
              }
            },
          ),
        ));
  }
}

class SttnInsp {
  final int index;
  final String options;

  SttnInsp(this.index, this.options);
}
