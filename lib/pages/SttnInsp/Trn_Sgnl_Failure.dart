import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ti/commonutils/ti_utilities.dart';
import 'dart:convert';
import 'package:ti/model/SttnInspModels/TrnSgnlFailureModel.dart';
import 'Trn_sgnl_failure.dart';
import 'package:flutter/material.dart';
import 'package:ti/commonutils/commonUtilities.dart';
import 'package:ti/commonutils/cameracls.dart';
import 'package:image_picker/image_picker.dart';

class TrnSgnlFailure extends StatefulWidget {
  @override
  _TrnSgnlFailureState createState() => _TrnSgnlFailureState();
}

class _TrnSgnlFailureState extends State<TrnSgnlFailure> {
  final items = ['Serial', 'Non-Serial'];
  //final YNitems = ['Yes', 'No'];
  //var selectedItemValue = 'Serial';
  var show = false ;
  File TrnimageFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  String _retrieveDataError;

  List<String> selectedItemValue = List<String>();
  List<bool> showText = [false,false,false] ;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TextEditingController> whyNocontroller = [];

  TextEditingController rmrkController = TextEditingController();

  TrnSgnlFailureModel TrnSgnlFailureMod = new TrnSgnlFailureModel(
      'Serial',
      [
        'Certificate on First Page',
        'Irregularity with Adjoining station',
        'Failure Description'
      ],
      ['', '', ''],['','',''],
      '' );


  callbackDropDown(callBackController , selected , show){
    setState(() {
      whyNocontroller = callBackController;
      selectedItemValue = selected;
      showText = show;
      print("Show:" + showText[0].toString());
       print('callBackController:' + TrnSgnlFailureMod.ynList1[0]+ TrnSgnlFailureMod.ynList1[1] + whyNocontroller[0].text + whyNocontroller[1].text) ;
    });
  }

  callbackCamera(imageF){
    setState(() {
      TrnimageFile = imageF ;
      print('callback:' + TrnimageFile.path.toString()) ;
    });
  }

  @override
  Widget build(BuildContext context) {

    for (int i = 0; i < 3; i++) {
      selectedItemValue.add("YES");
    }

    for (int i = 0; i < 3; i++) whyNocontroller.add(TextEditingController());

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: new Scaffold(
      key: _scaffoldkey,
        appBar: TiUtilities.tiAppBar(context, "Train Signal  Failure Register"),
        body: Builder(
          builder: (context) => new SingleChildScrollView(
          reverse: true,
          child:  Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: FormUI(context),
          ),
        ),
      ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              Expanded(
                child: IconButton(
                    onPressed: () {

                    },
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
            Navigator.pushNamed(context, '/sgnl_failure');
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

  Widget FormUI(BuildContext context) {
    return new Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    return FocusManager.instance.primaryFocus?.unfocus();
                    //CautionOrdRegModel.postData(data);
                  },
                  title: Text('Page'),
                  trailing: SizedBox(
                    width: 150,

                    child:  DropdownButtonFormField<String>(
                      decoration: const InputDecoration(

                        enabledBorder: OutlineInputBorder(
                          //borderRadius : const BorderRadius.all(Radius.circular(4.0)),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                      ),
                      value: TrnSgnlFailureMod.page,
                      items: items.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem)
                        );
                      }).toList(),
                      onChanged: (newSelectedValue) {
                        setState(() {
                          this.TrnSgnlFailureMod.page =
                              newSelectedValue.toString();
                          print("TrnSgnlFailureMod.page:" +
                              TrnSgnlFailureMod.page);

                        });
                      },

                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: TrnSgnlFailureMod.sList1.length,
          itemBuilder: (BuildContext context, int index) {


            return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 5.0, horizontal: 4.0),
                child: Card(
                  child: dropdowncls(dropdowntextcallback: callbackDropDown,slst: TrnSgnlFailureMod.sList1,ynlst: TrnSgnlFailureMod.ynList1,index: index,selectedItem: selectedItemValue, showTextField: showText,whyNoCont: whyNocontroller),


                  /*  Column(
                          children: [
                            ListTile(
                                onTap: () {
                                  return FocusManager.instance.primaryFocus
                                      ?.unfocus();
                                  //CautionOrdRegModel.postData(data);
                                },
                                title: Text(TrnSgnlFailureMod.sList1[index]),
                                trailing: getDropdownlst(TrnSgnlFailureMod.sList1 , index ) ,

                                SizedBox(
                                  width: 150,

                                  child:  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(

                                      enabledBorder: OutlineInputBorder(
                                        //borderRadius : const BorderRadius.all(Radius.circular(4.0)),
                                        borderSide: const BorderSide(color: Colors.teal),
                                      ),
                                    ),
                                    value: selectedItemValue[index].toString(),
                                    items:  _dropDownItem(),
                                    onChanged: (newSelectedValue) {
                                      setState(() {
                                        selectedItemValue[index] =
                                            newSelectedValue.toString();
                                        TrnSgnlFailureMod.ynList1[index] = newSelectedValue.toString();
                                        print("TrnSgnlFailureModdddd.:" + index.toString() + TrnSgnlFailureMod.ynList1[index]);
                                         if(newSelectedValue.toString() == 'NO'){
                                            _showTextField[index] = true;
                                            print("_showTextField:"  + _showTextField[index].toString());
                                            show = true;
                                         }
                                        else{
                                          _showTextField[index] = false;
                                          print("_showTextField:" + _showTextField[index].toString() );

                                         }

                                      });
                                    },

                                  ),
                                ),

                       ),
                         Visibility(
                          visible: _showTextField[index],
                          child: Container(
                          child: SizedBox(
                          //width: 200,
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                              controller: _whyNocontroller[index],
                              inputFormatters: [
                              FilteringTextInputFormatter.allow(
                              RegExp("[0-9a-zA-Z]"))
                              ],
                              decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Please mention Reason',

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
                              )
                            ),
                          ],
                        ),  */
                )
            );
          },
        ),
        SizedBox(
          height: 2.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: TextFormField(
                controller: rmrkController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Remarks(if any)',

                  alignLabelWithHint: true,

                  //suffixIcon: Padding( padding: const EdgeInsets.fromLTRB(10, 20, 20, 90),
                  //  child: Icon(
                  //   Icons.speaker_notes_rounded,
                  //  color: Colors.teal,
                  //  ),
                  //          )
                ),
                maxLines: 5,
                onChanged: (val){
                  TrnSgnlFailureMod.rmrks1 = rmrkController.text;
                  //print('TrnSgnlFailureMod.rmrks1:' + TrnSgnlFailureMod.rmrks1);
                }

              )),
        ),

        SizedBox(height: 10.0),
        Center(
          child: CameraCls(cameraCallBack: callbackCamera,imageFile: TrnimageFile),
          /* Container(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 90,
                                height: 70,
                                child: _previewImage(),
                              ),
                            ],
                          ),
                          onTap: () async {
                            _openPreviewDialogBox();
                          },
                        ),
                        Container(
                          child: GestureDetector(
                            child: Column(
                              children: <Widget>[
                                new Container(
                                    child: Image.asset(
                                      'assets/camera_icon.png',
                                      width: 90,
                                      height: 70,
                                    )),
                              ],
                            ),
                            onTap: () async {
                              _optionsDialogBox();
                            },
                          ),
                        )
                      ],
                    ),
                  ), */
        ),
        SizedBox(height: 40.0),

        Container(
          child: ButtonTheme(
            minWidth: 200,
            height: 50,
            child: MaterialButton(
              onPressed: () async {
                _callSaveTrnSgnlFailureWebService(TrnSgnlFailureMod)
                    .then((res) {
                  if (res == 'Record Successfully Saved.') {
                    print('Record Successfully Saved.');
                    CommonUtilities.showOKDialog(context, "Success!!")
                        .then((res1) {
                      Navigator.pushNamed(context, '/sgnl_failure');
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
        ),


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
    );
  }

  Future<String> _callSaveTrnSgnlFailureWebService(
      TrnSgnlFailureModel trnsgnlfailure) async {
    //log.d(alpa);
    print('Inside Callservuce');
    String urlInputString = json.encode(trnsgnlfailure.toJson());
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

