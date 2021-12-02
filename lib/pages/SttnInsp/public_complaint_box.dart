import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:ti/commonutils/cameracls.dart';
import 'package:ti/commonutils/ti_utilities.dart';
import 'package:flutter/material.dart';
import 'package:ti/commonutils/commonUtilities.dart';
import 'package:ti/model/SttnInspModels/public_complaint_box_Model.dart';

class PublicComplaintBox extends StatefulWidget {
  @override
  _PublicComplaintBoxState createState() => _PublicComplaintBoxState();
}

class _PublicComplaintBoxState extends State<PublicComplaintBox> {
  File CauimageFile;

  List<String> selectedItemValue = List<String>();
  List<bool> showText = [false, false];

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TextEditingController> whyNocontroller = [];

  TextEditingController rmrkController = TextEditingController();

  PublicComplaintBoxModel accidentregMod = new PublicComplaintBoxModel(
      ['Maintenance of public complaint book ', 'Punishment on Enquiry'],
      ['', ''],
      ['', ''],
      '');

  callbackDropDown(callBackController, selected, show) {
    setState(() {
      whyNocontroller = callBackController;
      selectedItemValue = selected;
      showText = show;
      print("Show:" + showText[0].toString());
      print('callBackController:' +
          accidentregMod.ynList1[0] +
          accidentregMod.ynList1[1] +
          whyNocontroller[0].text +
          whyNocontroller[1].text);
    });
  }

  callbackCamera(imageF) {
    setState(() {
      CauimageFile = imageF;
      print('callback:' + CauimageFile.path.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 2; i++) {
      selectedItemValue.add("YES");
    }

    for (int i = 0; i < 2; i++) whyNocontroller.add(TextEditingController());

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: new Scaffold(
        key: _scaffoldkey,
        appBar: TiUtilities.tiAppBar(context, "Public Complaint Box"),
        body: Builder(
          builder: (context) => new SingleChildScrollView(
            reverse: true,
            child: Form(
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
            Navigator.pushNamed(context, '/Panel_countr_Reg');
          },
          //icon: Icon(Icons.save_outlined),
          //label: Text('Save'),
          child: Icon(Icons.add),
          //color: Colors.white,
          //),

          backgroundColor: Colors.lime,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget FormUI(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: accidentregMod.sList1.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
              child: Card(
                child: dropdowncls(
                    dropdowntextcallback: callbackDropDown,
                    slst: accidentregMod.sList1,
                    ynlst: accidentregMod.ynList1,
                    index: index,
                    selectedItem: selectedItemValue,
                    showTextField: showText,
                    whyNoCont: whyNocontroller),
              ),
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
                  onChanged: (val) {
                    accidentregMod.rmrks1 = rmrkController.text;
                    //print('accidentregMod.rmrks1:' + accidentregMod.rmrks1);
                  })),
        ),
        SizedBox(height: 10.0),
        Center(
          child: CameraCls(
              cameraCallBack: callbackCamera, imageFile: CauimageFile),
        ),
        SizedBox(height: 40.0),
        Container(
          child: ButtonTheme(
            minWidth: 200,
            height: 50,
            child: MaterialButton(
              onPressed: () async {
                _callSavePublicComplaintBoxWebService(accidentregMod)
                    .then((res) {
                  if (res == 'Record Successfully Saved.') {
                    print('Record Successfully Saved.');
                    CommonUtilities.showOKDialog(context, "Success!!")
                        .then((res1) {
                      Navigator.pushNamed(context, '/Panel_countr_Reg');
                    });
                  } else {
                    print('Problem in Sign On. Please Contact to Supervisor');
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
      ],
    );
  }

  Future<String> _callSavePublicComplaintBoxWebService(
      PublicComplaintBoxModel cautOrdReg) async {
    //log.d(alpa);
    print('Inside Callservuce');
    String urlInputString = json.encode(cautOrdReg.toJson());
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
