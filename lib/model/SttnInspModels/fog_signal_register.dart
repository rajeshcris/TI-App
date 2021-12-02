import 'dart:io';

class FogSignalRegisterModel {
  List<String> sList1 = [];
  List<String> ynList1 = [];
  List<String> whyNoRsn = [];
  String rmrks1 = "";

  FogSignalRegisterModel(this.sList1, this.ynList1, this.whyNoRsn, this.rmrks1);

  /* static FogSignalRegisterModel getData() {

    return FogSignalRegisterModel([CheckBoxListModel('1.Speed Restriction info',false),
                               CheckBoxListModel('2.Message  Display  on Notice Board',false)
                              ],

     static void postData(FogSignalRegisterModel dt) {
     print('Helo2');
     print(dt.cList[0].check);
     print(dt.rmrks);
     print('Helo4');
  } */

  Map<String, dynamic> toJson() => {
        "paramList": [
          {"cList": ynList1, "rmkrs": rmrks1}
        ]
      };
}
