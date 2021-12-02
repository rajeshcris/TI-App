import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:ti/commonutils/ti_utilities.dart';
import 'dart:convert';
import 'Trn_Sgnl_Failure.dart';
import 'package:flutter/material.dart';
import 'package:ti/model/SttnInspModels/MnthS&TFailureModel.dart';
import 'package:ti/commonutils/commonUtilities.dart';

class MnthSTFailure extends StatefulWidget {
  @override
  _MnthSTFailureState createState() => _MnthSTFailureState();
}

class _MnthSTFailureState extends State<MnthSTFailure> {
  final items = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
  var selectedItemValue = 'JAN';

  MnthSTFailureModel MnthSTFailureMod = new MnthSTFailureModel('JAN', '', '');

  @override
  Widget build(BuildContext context) {
    TextEditingController _ftypeController = TextEditingController();
    _ftypeController.text = MnthSTFailureMod.FType;

    TextEditingController _fcountController = TextEditingController();
    _fcountController.text = MnthSTFailureMod.FCount;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: TiUtilities.tiAppBar(context, "Month wise S&T failures"),
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      return FocusManager.instance.primaryFocus?.unfocus();
                      //CautionOrdRegModel.postData(data);
                    },
                    title: Text('Month'),
                    trailing: DropdownButton<String>(
                      value: MnthSTFailureMod.month,
                      items: items.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem));
                      }).toList(),
                      onChanged: (newSelectedValue) {
                        setState(() {
                          this.MnthSTFailureMod.month =
                              newSelectedValue.toString();
                          print("MnthSTFailureMod.page:" +
                              MnthSTFailureMod.month);
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      return FocusManager.instance.primaryFocus?.unfocus();
                      //CautionOrdRegModel.postData(data);
                    },
                    title: Text('Failure type :'),
                    trailing: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _ftypeController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[0-9a-zA-Z]"))
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          //labelText: 'Remarks(if any)',

                          alignLabelWithHint: true,

                          //suffixIcon: Padding( padding: const EdgeInsets.fromLTRB(10, 20, 20, 90),
                          //  child: Icon(
                          //   Icons.speaker_notes_rounded,
                          //  color: Colors.teal,
                          //  ),
                          //          )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      return FocusManager.instance.primaryFocus?.unfocus();
                      //CautionOrdRegModel.postData(data);
                    },
                    title: Text('Failure Count :'),
                    trailing: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _fcountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          //labelText: 'Remarks(if any)',

                          alignLabelWithHint: true,

                          //suffixIcon: Padding( padding: const EdgeInsets.fromLTRB(10, 20, 20, 90),
                          //  child: Icon(
                          //   Icons.speaker_notes_rounded,
                          //  color: Colors.teal,
                          //  ),
                          //          )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: ButtonTheme(
                  minWidth: 200,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () async {
                      _callSaveMnthSTFailureWebService(MnthSTFailureMod)
                          .then((res) {
                        if (res == 'Record Successfully Saved.') {
                          print('Record Successfully Saved.');
                          CommonUtilities.showOKDialog(context, "Success!!")
                              .then((res1) {
                            Navigator.pushNamed(context, '/crank_hndl_reg');
                          });
                        } else {
                          print(
                              'Problem in Sign On. Please Contact to Supervisor');
                        }
                      });
                    },
                    textColor: Colors.white,
                    color: Colors.teal,
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.save_outlined),
                        Text(
                          "Save & Next",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              )

              /*     Container(
                child: ButtonTheme(
                 // minWidth: width / 3,
                  child: MaterialButton(
                    onPressed: () async {

                      _callSaveCautionOrdRegWebService(
                             widget.cautionOrdMod)
                            .then((res) {
                          Navigator.of(context,
                              rootNavigator: true)
                              .pop();
                          if (res == 'Record Successfully Saved.') {
                            print('Record Successfully Saved.');
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home',
                                      (Route<dynamic> route) => false);

                          } else {

                               print('Problem in Sign On. Please Contact to Supervisor');
                          }
                        });

                    },
                    textColor: Colors.white,
                    color: Colors.teal,
                    child: Text(
                      "Save",
                      style: TextStyle(
                           fontWeight: FontWeight.bold),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              )  */
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              Expanded(
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image_outlined,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
          color: Colors.teal,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/crank_hndl_reg');
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.lime,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Future<String> _callSaveMnthSTFailureWebService(
      MnthSTFailureModel MnthSTFailure) async {
    //log.d(alpa);
    print('Inside Callservuce');
    String urlInputString = json.encode(MnthSTFailure.toJson());
    print("urlInputString:" + urlInputString);
    // var url =
    //    ChalakdalConstants.webServiceUrl + 'saveAlpColpFpAttributesRecord';
    //log.d("url = " + url);
    //log.d("urlInputString = " + urlInputString);
    Map<String, String> headerInput = {
      "Accept": "*/*",
      "Content-Type": "application/json"

      //"application/x-www-form-urlencoded"
    };

    // var data = await http.get(Uri.parse("http://172.16.4.58:8080/DemoService/webapi/demoservice/SttnInspPost"));

    /*  final response = await http.post(Uri.parse("http://172.16.4.58:8080/DemoService/webapi/demoservice/SttnInspPost"),
        headers: headerInput,
        body: urlInputString,
        encoding: Encoding.getByName("utf-8"));

   */

    //log.d("response code = " + response.statusCode.toString());
    //var jsonRes;
    //jsonRes = json.decode(response.body);

    //print('jsonRes' + response.body);
    //log.d("response code = " + response.statusCode.toString());
    /* if (response == null || response.statusCode != 200) {
      throw new Exception(
          'HTTP request failed, statusCode: ${response?.statusCode}');
    } else {
      log.d("json result----- = " + jsonRes.toString());
      return jsonRes['vosList'][0].toString();
    }  */
    return 'Record Successfully Saved.';
  }
}
