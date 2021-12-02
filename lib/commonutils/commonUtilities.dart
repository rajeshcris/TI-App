import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'logger.dart';
//import '../Pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class CommonUtilities {
  // static final log = getLogger('ChalakdalUtilities');
  static bool loggedin = false;
  static const platform = const MethodChannel('DownloadChannel');
  static bool loginflag = false;
  static int bbottom = 0;

  //static CmsUser user;
  //static List<dynamic> dataOrganisation;
  static String version = "";
  static String versionCode = "";
  static Random random = new Random();

  static Color getColor() {
    return Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }

  commonUtilities() {
    //log.d("ChalakdalUtilities() called---");
  }

  /* static Future<Position> getUserGeoPosition() async{
    var geoPos = Position(latitude: 0.0, longitude: 0.0);
    bool locationServiceEnabled=await Geolocator.isLocationServiceEnabled();
    if(locationServiceEnabled == null || !locationServiceEnabled){
      log.d(locationServiceEnabled.toString() + ' : locationServiceEnabled Issue');
      locationServiceEnabled = await Geolocator.openLocationSettings();
    }else {
      LocationPermission locationPermission = await Geolocator
          .checkPermission();
      if (!(locationPermission == LocationPermission.whileInUse ||
          locationPermission == LocationPermission.always)) {
        log.d(locationPermission.toString() + ' : locationPermission Issue');
        await Geolocator.requestPermission();
      } else {
        try {
          geoPos = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 5));
          log.d(geoPos);
        } catch (e, stackTrace) {

        }
      }
    }
    return geoPos;
  } */

  static void showInSnackBar(BuildContext context, String value) {
    Widget snackbar = SnackBar(
      content: new Text(value),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.redAccent[100],
    );
    //Scaffold.of(context).showSnackBar(snackbar);
  }

  static Future<void> showOKDialog(BuildContext context, String msg) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return customAlertDialog(context, msg, false);
        });
  }

  /* static Future<bool> showOkDialogWithOkCancelAndReturnBool(
      BuildContext context, String msg) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return customAlertDialog(context, msg, true);
        });
  } */



  static AppBar T1AppBar(BuildContext context, String title) {
    return new AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      backgroundColor: Colors.teal,
      title: new Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(alignment: Alignment.center, child: Text(title)),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              alignment: Alignment.centerRight,
              icon: new Icon(
                Icons.home,
              ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', (Route<dynamic> route) => false);
              },
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }


  static AlertDialog customAlertDialog(
      BuildContext context, String msg, bool cancelButton) {
    return AlertDialog(
      backgroundColor: Colors.teal,
      title: Text(
        'माल परिचालन सूचना प्रणाली (FOIS)',
        style: new TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              msg,
              style: new TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (cancelButton)
                  GestureDetector(
                    child: Text(
                      'CANCEL',
                      style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                SizedBox(
                  width: 25,
                ),
                GestureDetector(
                  child: Text(
                    'OK',
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class dropdowncls extends StatefulWidget {

  List<String> slst ;
  List<String> ynlst ;

  int index ;

  List<String> selectedItem ;

  List<TextEditingController> whyNoCont;


  List<bool> showTextField ;

  final Function dropdowntextcallback;

  dropdowncls({Key key ,this.dropdowntextcallback ,this.slst ,this.ynlst ,this.index ,this.selectedItem ,this.showTextField,this.whyNoCont}) : super(key: key);

  @override
   _dropdownclsState createState() => _dropdownclsState();
}

class _dropdownclsState extends State<dropdowncls> {

//

//

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        ListTile(
          onTap: () {
            return FocusManager.instance.primaryFocus
                ?.unfocus();
            //CautionOrdRegModel.postData(data);
          },
          title: Text(widget.slst[widget.index]),
          trailing: SizedBox(
            width: 150,

            child:  DropdownButtonFormField<String>(
              decoration: const InputDecoration(

                enabledBorder: OutlineInputBorder(
                  //borderRadius : const BorderRadius.all(Radius.circular(4.0)),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
              value: widget.selectedItem[widget.index].toString(),
              items:  _dropDownItem(),
              onChanged: (newSelectedValue) {
                // setState(() async {
                widget.selectedItem[widget.index] =
                    newSelectedValue.toString();
                widget.ynlst[widget.index] = newSelectedValue.toString();
                print("TrnSgnlFailureModdddd.:" + widget.index.toString() + widget.ynlst[widget.index]);
                if(newSelectedValue.toString() == 'NO'){
                  widget.showTextField[widget.index] = true;
                  print("_showTextField:"  + widget.showTextField[widget.index].toString());
                  //show = true;
                }
                else{
                  widget.showTextField[widget.index] = false;
                  print("_showTextField:" + widget.showTextField[widget.index].toString() );

                }
                widget.dropdowntextcallback(widget.whyNoCont ,widget.selectedItem, widget.showTextField);
               // });

              },

            ),
          ),
        ),
        Visibility(
            visible: widget.showTextField[widget.index],
            child: Container(
              child: SizedBox(
                //width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: widget.whyNoCont[widget.index],
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
            )
        ),
      ],
    );
  }

  static List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["NO", "YES"];
    return ddl
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value),
    ))
        .toList();
  }
}

