import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ti/commonutils/logger.dart';
import 'package:ti/commonutils/mydatetime_picker.dart';
import 'package:ti/commonutils/size_config.dart';
import 'package:ti/commonutils/ti_constants.dart';
import 'package:ti/commonutils/ti_utilities.dart';
import 'package:ti/model/ProfileModel.dart';
import 'package:http/http.dart' as http;

class user_profiledetails extends StatefulWidget {
  String userId;

  user_profiledetails({@required this.userId, Key key}) : super(key: key);

  @override
  _user_profiledetailsState createState() => _user_profiledetailsState();
}

class _user_profiledetailsState extends State<user_profiledetails> {
  final log = getLogger('user_profiledetails');
  var jsonResultList;

  String userMob,
      userName,
      userMobile,
      userMailid,
      userDOB,
      userDOA,
      userDOJ,
      userHQ,
      userDvsn,
      userSection,
      userDesignation;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedValue = "Select";
  TextEditingController usernameController = TextEditingController();
  TextEditingController usermobileController = TextEditingController();
  TextEditingController usermailIdController = TextEditingController();
  TextEditingController userDOBController = TextEditingController();
  TextEditingController userDOAController = TextEditingController();
  TextEditingController userDOJController = TextEditingController();
  TextEditingController userNextDOJController = TextEditingController();
  TextEditingController userHQController = TextEditingController();
  TextEditingController userDvsnController = TextEditingController();

  TextEditingController userSectionController = TextEditingController();
  TextEditingController userDesignationController = TextEditingController();
  //TextEditingController systemTimeController = TextEditingController();
  double width, height, font, headingFont, homeIconAlign;
  var padding;
  profileModel _userprofilemodel = new profileModel();

  //final date = FocusNode();
  final userNameControllerFocus = FocusNode();
  final userMobileControllerFocus = FocusNode();
  final usermailControllerFocus = FocusNode();
  final userDOBControllerFocus = FocusNode();
  final userDOAControllerFocus = FocusNode();
  final userDOJControllerFocus = FocusNode();
  final userNextDOJControllerFocus = FocusNode();
  final userHQControllerFocus = FocusNode();
  final userDvsnControllerFocus = FocusNode();
  final userSectionControllerFocus = FocusNode();
  final userDesignationControllerFocus = FocusNode();
  final regenStartControllerFocus = FocusNode();

  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  bool _loading = false;

  List<String> zoneList = [
    'Select',
    'CR',
    'ER',
    'EC',
    'ECO',
    'NC',
    'NE',
    'NF',
    'NR',
    'NW',
    'SC',
    'SE',
    'SEC',
    'SEC',
    'SR',
    'SW',
    'WC',
    'WR'
  ];
  List<String> zoneSubheadList = ['Select'];

  List<String> onZoneHeadChange(String zone) {
    log.d('onZoneHeadChange called $zone');
    List<String> list;
    if (zone == 'Select') {
      list = ['Select'];
    } else if (zone == 'NR') {
      list = [
        'Select',
        'DLI',
        'MB',
        'UMB',
        'GZB',
        'FZR',
      ];
    } else if (zone == 'ER') {
      list = [
        'Select',
        'ASN',
        'HWH',
      ];
    } else {
      list = ['Select'];
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getProfileData();
    });
  }

  @override
  _onClear() {
    setState(() {
      _formKey.currentState.reset();
      _autoValidate = AutovalidateMode.disabled;
      usernameController.text = "";
      usermobileController.text = "";
      usermailIdController.text = "";
      userDOAController.text = "";
      userDOJController.text = "";
      userDOBController.text = "";
      userHQController.text = "";
      userDvsnController.text = "";
      userSectionController.text = "";
      userDesignationController.text = "";
    });
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }

  void dispose() {
    super.dispose();
    usernameController.dispose();
    usermobileController.dispose();
    usermailIdController.dispose();
    userDOAController.dispose();
    userDOJController.dispose();
    userDOBController.dispose();
    userHQController.dispose();
    userDvsnController.dispose();
    userSectionController.dispose();
    userDesignationController.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021, 8),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    width = SizeConfig.screenWidth;
    height = SizeConfig.screenHeight;
    padding = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    if (MediaQuery.of(context).orientation.toString() ==
        'Orientation.landscape') {
      font = 14;
      headingFont = font * 1.2;
    } else {
      font = 14;
      headingFont = font * 1.2;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      appBar: TiUtilities.tiAppBar(context, "User Profile"),
      body: Builder(
          builder: (context) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autoValidate,
                      child: _loading
                          ? SizedBox(
                              height: height,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : FormUI(context),
                    ),
                  ),
                ),
              )),
    );
  }

  Widget FormUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(padding: EdgeInsets.all(0)),
        Text(
          "Name",
          style: new TextStyle(color: Colors.teal, fontSize: 10),
          textAlign: TextAlign.end,
        ),
        SizedBox(height: 10.0),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
            child: Container(
              height: 50,
              width: 50.0,
              child: TextFormField(
                // maxLength: 50,
                style: TextStyle(fontSize: font),
                controller: usernameController,

                textCapitalization: TextCapitalization.characters,
                // readOnly: true,

                onSaved: (String val) {
                  _userprofilemodel.userName = val;
                },
                //controller: myController,
                onEditingComplete: () {
                  // content = usernameController.text;
                  //log.d(content);
                },
                //maxLength: 25,
                //maxLengthEnforced: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 5, 2, 5),
                  filled: true,
                  hintText: 'Your Name',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Enter Your Name',
                  labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: font,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]),
        SizedBox(height: 10.0),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
            child: Container(
              height: 50,
              width: 50.0,
              child: TextFormField(
                //maxLength: 50,
                style: TextStyle(fontSize: font),
                controller: usermobileController,
                // readOnly: true,

                onSaved: (String val) {
                  _userprofilemodel.userMobile = val;
                },
                //controller: myController,
                onEditingComplete: () {
                  // content = usernameController.text;
                  //log.d(content);
                },
                //maxLength: 25,
                //maxLengthEnforced: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 5, 2, 5),
                  filled: true,
                  hintText: 'Your Mobile',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Enter Mobile No.',
                  labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: font,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
            child: Container(
              height: 50,
              width: 50.0,
              child: TextFormField(
                // maxLength: 50,
                style: TextStyle(fontSize: 10),
                controller: userDesignationController,
                // readOnly: true,

                onSaved: (String val) {
                  _userprofilemodel.userDesignation = val;
                },
                //controller: myController,
                onEditingComplete: () {
                  // content = usernameController.text;
                  //log.d(content);
                },
                //maxLength: 25,
                //maxLengthEnforced: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 5, 2, 5),
                  filled: true,
                  hintText: 'Your Designation',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Enter Your Designation',
                  labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          // SizedBox(width: 10.0),
        ]),
        SizedBox(height: 10.0),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
            child: Container(
              height: 50,
              width: 50.0,
              child: TextFormField(
                //  maxLength: 50,
                style: TextStyle(fontSize: font),
                controller: usermailIdController,
                // readOnly: true,

                onSaved: (String val) {
                  _userprofilemodel.userMailid = val;
                },
                //controller: myController,
                onEditingComplete: () {
                  // content = usernameController.text;
                  //log.d(content);
                },
                //maxLength: 25,
                //maxLengthEnforced: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 5, 2, 5),
                  filled: true,
                  hintText: 'Your Mailid',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Enter Your Mailid',
                  labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: font,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          //SizedBox(width: 10.0),
        ]),
        SizedBox(height: 10.0),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
            child: Container(
              height: 50,
              width: 50.0,
              child: TextFormField(
                style: TextStyle(fontSize: font),
                controller: userDOBController,
                focusNode: userDOBControllerFocus,
                // readOnly: true,
                validator: (val) {
                  if (val == null || val == '') {
                    return '';
                  }
                },
                onSaved: (String val) {
                  _userprofilemodel.userDOB = val;
                },
                //controller: myController,
                onEditingComplete: () {
                  //content = myController.text;
                  //log.d(content);
                },
                //maxLength: 25,
                //maxLengthEnforced: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  errorStyle: TextStyle(height: 0),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.date_range,
                      size: 30,
                      color: Colors.teal,
                    ),
                    onPressed: () async {
                      userDOBController.text =
                          await MyDateTimePicker.myDatePicker(context);
                      FocusScope.of(context)
                          .requestFocus(userDOJControllerFocus);
                    },
                  ),
                  contentPadding: new EdgeInsets.fromLTRB(20, 5, 2, 5),
                  filled: true,
                  hintText: 'Select DOB ',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Date of Birth',
                  labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: headingFont,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          //  SizedBox(width: 10.0),
        ]),
        SizedBox(height: 10.0),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
            child: Container(
              height: 50,
              width: 50.0,
              child: TextFormField(
                style: TextStyle(fontSize: font),
                controller: userDOJController,
                focusNode: userDOJControllerFocus,
                readOnly: true,
                validator: (val) {
                  if (val == null || val == '') {
                    return '';
                  }
                },
                onSaved: (String val) {
                  _userprofilemodel.userDOJ = val;
                },
                //controller: myController,
                onEditingComplete: () {
                  //content = myController.text;
                  //log.d(content);
                },
                //maxLength: 25,
                //maxLengthEnforced: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  errorStyle: TextStyle(height: 0),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.date_range,
                      size: 30,
                      color: Colors.teal,
                    ),
                    onPressed: () async {
                      userDOJController.text =
                          await MyDateTimePicker.myDatePicker(context);
                      FocusScope.of(context)
                          .requestFocus(userDOJControllerFocus);
                    },
                  ),
                  contentPadding: new EdgeInsets.fromLTRB(20, 5, 2, 5),
                  filled: true,
                  hintText: 'Select DOJ ',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Joing Date',
                  labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: headingFont,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]),
        SizedBox(height: 10.0),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
            child: Container(
              height: 50,
              width: 50.0,
              child: TextFormField(
                style: TextStyle(fontSize: font),
                controller: userDOAController,
                focusNode: userDOAControllerFocus,
                // readOnly: true,
                validator: (val) {
                  if (val == null || val == '') {
                    return '';
                  }
                },
                onSaved: (String val) {
                  _userprofilemodel.userDOA = val;
                },
                //controller: myController,
                onEditingComplete: () {
                  //content = myController.text;
                  //log.d(content);
                },
                //maxLength: 25,
                //maxLengthEnforced: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  errorStyle: TextStyle(height: 0),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.date_range,
                      size: 30,
                      color: Colors.teal,
                    ),
                    onPressed: () async {
                      userDOAController.text =
                          await MyDateTimePicker.myDatePicker(context);
                      FocusScope.of(context)
                          .requestFocus(userDOAControllerFocus);
                    },
                  ),
                  contentPadding: new EdgeInsets.fromLTRB(20, 5, 2, 5),
                  filled: true,
                  hintText: 'Select DOA ',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Apointment Date',
                  labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: headingFont,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]),
        SizedBox(height: 10.0),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
            child: Container(
              height: 50,
              width: 50.0,
              child: DropdownButtonFormField(
                //  maxLength: 50,
                isDense: true,
                isExpanded: true,
                style: TextStyle(fontSize: font),
                validator: (args) {
                  if (args == null || args == 'Select') {
                    return '';
                  }
                },
                // readOnly: true,

                onSaved: (String val) {
                  //  _userprofilemodel.userHQ = val;
                },
                //controller: myController,
                //maxLength: 25,
                //maxLengthEnforced: true,
                // textAlign: TextAlign.left,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 5, 2, 5),
                  filled: true,
                  hintText: 'Select  HQ',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Enter HQ Name',
                  labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: headingFont,
                      fontWeight: FontWeight.bold),
                ),
                items: zoneList.map((String item) {
                  return new DropdownMenuItem<String>(
                      child: Text(item,
                          style: new TextStyle(
                              color: Colors.teal, fontSize: font)),
                      value: item);
                }).toList(),
                value: 'Select',
                onChanged: (newValue) {
                  log.d(newValue);
                  setState(() {
                    // _reportAbnormalityModel.abnormalityHead = newValue;
                    // _reportAbnormalityModel.abnormalitySubhead = "Select";
                    zoneSubheadList = onZoneHeadChange(newValue);
                    //  _isButtonDisabled = true;
                  });
                },
              ),
            ),
          ),
          //SizedBox(width: 10.0),
        ]),
        SizedBox(height: 10.0),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
            child: Container(
              height: 50,
              width: 50.0,
              child: DropdownButtonFormField(
                isDense: true,
                isExpanded: true,
                validator: (args) {
                  if (args == null || args == 'Select') {
                    return '';
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 5, 2, 5),
                  filled: true,
                  hintText: 'Your Divsion',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Enter Divsion Code',
                  labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: font,
                      fontWeight: FontWeight.bold),
                ),
                items: zoneSubheadList.map((String item) {
                  return new DropdownMenuItem<String>(
                      child: Text(item,
                          style: new TextStyle(
                              color: Colors.teal, fontSize: font)),
                      value: item);
                }).toList(),
                value: selectedValue,
                onChanged: (newValue) {
                  log.d('Divsion selected  value $newValue');
                  setState(() {
                    selectedValue =
                        newValue; // _reportAbnormalityModel.abnormalitySubhead = newValue;
                  });
                },
              ),
            ),
          ),
          // SizedBox(width: 10.0),
        ]),
        SizedBox(height: 10.0),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
            child: Container(
              height: 50,
              width: 50.0,
              child: TextFormField(
                //   maxLength: 50,
                style: TextStyle(fontSize: 10),
                controller: userSectionController,
                // readOnly: true,

                onSaved: (String val) {
                  _userprofilemodel.userSection = val;
                },
                //controller: myController,
                onEditingComplete: () {
                  // content = usernameController.text;
                  //log.d(content);
                },
                //maxLength: 25,
                //maxLengthEnforced: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 5, 2, 5),
                  filled: true,
                  hintText: 'Your Section',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Enter Section Name',
                  labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          // SizedBox(width: 10.0),
        ]),
        SizedBox(height: 10.0),
        SizedBox(height: 20.0),
        Center(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ButtonTheme(
                  //elevation: 4,
                  //color: Colors.green,
                  minWidth: width / 3,
                  child: MaterialButton(
                    onPressed: () => _onClear(),
                    textColor: Colors.white,
                    color: Colors.teal,
                    child: Text(
                      "Reset",
                      style: TextStyle(
                          fontSize: font, fontWeight: FontWeight.bold),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: width / 3,
                  child: MaterialButton(
                    onPressed: () async {
                      log.d(DateFormat('dd-MM-yyyy HH:mm')
                          .format(DateTime.now()));

                      _formKey.currentState.save();
                      //   _liFootplateRecordModel.liId =
                      //     ChalakdalUtilities.user.loginid;
                      //res = _callCounsellingWebService(counsellingModel);
                    },
                    textColor: Colors.white,
                    color: Colors.teal,
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontSize: font, fontWeight: FontWeight.bold),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void getProfileData() async {
    log.d('Fetching from service getProfileData');
    var url = TiConstants.webServiceUrl + 'getCrewBiodata';
    Map<String, dynamic> urlinput = {
      "user": widget.userId,
      "password": "",
      "logintype": ""
    };
    String urlInputString = json.encode(urlinput);

    log.d("url = " + url);
    log.d("urlInputString = " + urlInputString);

    final responseSubmittedprofile = await http.post(Uri.parse(url),
        headers: TiConstants.headerInput,
        body: urlInputString,
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      jsonResultList = json.decode(responseSubmittedprofile.body);

      final profile = profileModel.fromJson(jsonResultList);
      log.d(profile);

      userMob = profile.userMobile == "" ? "NA" : profile.userMobile;
      userMailid = profile.userMailid == "" ? "NA" : profile.userMailid;
      userDOB = profile.userDOB == "" ? "NA" : profile.userDOB;
      userDOA = profile.userDOA == "" ? "NA" : profile.userDOA;
      userDOJ = profile.userDOJ == "" ? "NA" : profile.userDOJ;
      userHQ = profile.userHQ == "" ? "NA" : profile.userHQ;
      userDvsn = profile.userDvsn == "" ? "NA" : profile.userDvsn;
      userSection = profile.userSection == "" ? "NA" : profile.userSection;
      userDesignation =
          profile.userDesignation == "" ? "NA" : profile.userDesignation;
    });
  }
}
