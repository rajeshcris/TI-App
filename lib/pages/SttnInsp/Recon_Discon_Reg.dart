import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:ti/commonutils/cameracls.dart';
import 'package:ti/commonutils/ti_utilities.dart';
import 'package:ti/model/SttnInspModels/connect_reconnect_Model.dart';
import 'Trn_Sgnl_Failure.dart';
import 'package:flutter/material.dart';
import 'package:ti/commonutils/commonUtilities.dart';

class ReconDisconReg extends StatefulWidget {
  @override
  _ReconDisconRegState createState() => _ReconDisconRegState();
}

class _ReconDisconRegState extends State<ReconDisconReg> {
  File ReconimageFile;

  List<String> selectedItemValue = List<String>();
  List<bool> showText = [false, false, false, false, false];

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TextEditingController> whyNocontroller = [];

  TextEditingController rmrkController = TextEditingController();

  ReconDisconRegModel recondisconMod = new ReconDisconRegModel([
    'Memo Register with SM on Duty',
    'Signal Gear Maintenance Record  with SM on Duty',
    'Verification of  Entry in Connect/ Disconnect Memo',
    'Authorization of Memo by Maintenance staff indicating points /Singal affected',
    'Memo Pasting in Register serially'
  ], [
    '',
    '',
    '',
    '',
    ''
  ], [
    '',
    '',
    '',
    '',
    ''
  ], '');

  callbackDropDown(callBackController, selected, show) {
    setState(() {
      whyNocontroller = callBackController;
      selectedItemValue = selected;
      showText = show;
      print("Show:" + showText[0].toString());
      print('callBackController:' +
          recondisconMod.ynList1[0] +
          recondisconMod.ynList1[1] +
          whyNocontroller[0].text +
          whyNocontroller[1].text);
    });
  }

  callbackCamera(imageF) {
    setState(() {
      ReconimageFile = imageF;
      print('callback:' + ReconimageFile.path.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 5; i++) {
      selectedItemValue.add("YES");
    }

    for (int i = 0; i < 5; i++) whyNocontroller.add(TextEditingController());

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: new Scaffold(
        key: _scaffoldkey,
        appBar: TiUtilities.tiAppBar(
            context, "Reconnection / disconnection memo register"),
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
            Navigator.pushNamed(context, '/bioData_Reg');
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
          physics: NeverScrollableScrollPhysics(),
          itemCount: recondisconMod.sList1.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
              child: Card(
                child: dropdowncls(
                    dropdowntextcallback: callbackDropDown,
                    slst: recondisconMod.sList1,
                    ynlst: recondisconMod.ynList1,
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
                    recondisconMod.rmrks1 = rmrkController.text;
                    //print('cautionOrdMod.rmrks1:' + cautionOrdMod.rmrks1);
                  })),
        ),
        SizedBox(height: 10.0),
        Center(
          child: CameraCls(
              cameraCallBack: callbackCamera, imageFile: ReconimageFile),
        ),
        SizedBox(height: 40.0),
        Container(
          child: ButtonTheme(
            minWidth: 200,
            height: 50,
            child: MaterialButton(
              onPressed: () async {
                _callSaveCautionOrdRegWebService(recondisconMod).then((res) {
                  if (res == 'Record Successfully Saved.') {
                    print('Record Successfully Saved.');
                    CommonUtilities.showOKDialog(context, "Success!!")
                        .then((res1) {
                      Navigator.pushNamed(context, '/bioData_Reg');
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

  Future<String> _callSaveCautionOrdRegWebService(
      ReconDisconRegModel ReconDisconReg) async {
    //log.d(alpa);
    print('Inside Callservuce');
    String urlInputString = json.encode(ReconDisconReg.toJson());
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

    return 'Record Successfully Saved.';
  }
}
