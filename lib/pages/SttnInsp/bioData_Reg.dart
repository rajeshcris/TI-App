import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ti/commonutils/ti_utilities.dart';

import 'package:ti/model/SttnInspModels/bio_data_Model.dart';

import 'package:flutter/material.dart';
import 'package:ti/commonutils/commonUtilities.dart';
import 'package:ti/commonutils/cameracls.dart';
import 'package:image_picker/image_picker.dart';

class BioDataReg extends StatefulWidget {
  @override
  _BioDataRegState createState() => _BioDataRegState();
}

class _BioDataRegState extends State<BioDataReg> {
  final items = ['Overdue', 'Safety camp', 'Periodical medical examination'];
  //final YNitems = ['Yes', 'No'];
  //var selectedItemValue = 'Serial';
  final rmrk = FocusNode();
  var show = false;
  File BioimageFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  String _retrieveDataError;

  List<String> selectedItemValue = List<String>();
  List<bool> showText = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TextEditingController> whyNocontroller = [];

  TextEditingController rmrkController = TextEditingController();

  BioDataRegModel BioDataRegMod = new BioDataRegModel(
      'Overdue',
      [
        'Name of Staff',
        'Date of Birth',
        'Date of Appointment',
        'Date of Posting at Station',
        'Date of Safety Course',
        'Date of Safety Course Due',
        'Bio data Chart',
        'Monthly Summary',
        'Staff Competency Certificates'
      ],
      ['', '', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', '', ''],
      '');

  callbackDropDown(callBackController, selected, show) {
    setState(() {
      whyNocontroller = callBackController;
      selectedItemValue = selected;
      showText = show;
      print("Show:" + showText[0].toString());
      print('callBackController:' +
          BioDataRegMod.ynList1[0] +
          BioDataRegMod.ynList1[1] +
          whyNocontroller[0].text +
          whyNocontroller[1].text);
    });
  }

  callbackCamera(imageF) {
    setState(() {
      BioimageFile = imageF;
      print('callback:' + BioimageFile.path.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 9; i++) {
      selectedItemValue.add("YES");
    }

    for (int i = 0; i < 9; i++) whyNocontroller.add(TextEditingController());

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: new Scaffold(
        key: _scaffoldkey,
        appBar: TiUtilities.tiAppBar(
            context, "Bio-Data Register of operating staff"),
        body: //Builder(
            //builder: (context) => new
            SingleChildScrollView(
          reverse: true,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: FormUI(context),
          ),
        ),
        //  ),
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
            Navigator.pushNamed(context, '/Station_Inspect_Reg');
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
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    return FocusManager.instance.primaryFocus?.unfocus();
                    //CautionOrdRegModel.postData(data);
                  },
                  title: Text('Work type', style: TextStyle(fontSize: 14)),
                  trailing: SizedBox(
                    width: 220,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          //borderRadius : const BorderRadius.all(Radius.circular(4.0)),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                      ),
                      value: BioDataRegMod.worktype,
                      items: items.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem,
                                style: TextStyle(fontSize: 12)));
                      }).toList(),
                      onChanged: (newSelectedValue) {
                        setState(() {
                          this.BioDataRegMod.worktype =
                              newSelectedValue.toString();
                          print("BioDataRegMod.worktype:" +
                              BioDataRegMod.worktype);
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
          physics: NeverScrollableScrollPhysics(),
          itemCount: BioDataRegMod.sList1.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
                child: Card(
                  child: dropdowncls(
                      dropdowntextcallback: callbackDropDown,
                      slst: BioDataRegMod.sList1,
                      ynlst: BioDataRegMod.ynList1,
                      index: index,
                      selectedItem: selectedItemValue,
                      showTextField: showText,
                      whyNoCont: whyNocontroller),
                ));
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
                  keyboardType: TextInputType.text,
                  focusNode: rmrk,
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
                    BioDataRegMod.rmrks1 = rmrkController.text;
                    //print('TrnSgnlFailureMod.rmrks1:' + TrnSgnlFailureMod.rmrks1);
                  })),
        ),
        SizedBox(height: 10.0),
        Center(
          child: CameraCls(
              cameraCallBack: callbackCamera, imageFile: BioimageFile),
        ),
        SizedBox(height: 40.0),
        Container(
          child: ButtonTheme(
            minWidth: 200,
            height: 50,
            child: MaterialButton(
              onPressed: () async {
                _callSaveTrnSgnlFailureWebService(BioDataRegMod).then((res) {
                  if (res == 'Record Successfully Saved.') {
                    print('Record Successfully Saved.');
                    CommonUtilities.showOKDialog(context, "Success!!")
                        .then((res1) {
                      Navigator.pushNamed(context, '/Station_Inspect_Reg');
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
        ),
      ],
    );
  }

  Future<String> _callSaveTrnSgnlFailureWebService(
      BioDataRegModel biodata) async {
    //log.d(alpa);
    print('Inside Callservuce');
    String urlInputString = json.encode(biodata.toJson());
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
