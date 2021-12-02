import 'dart:io';

class CrankHndlRegModel{
  List<String> sList1 = [] ;
  List<String> ynList1 = [];
  List<String> whyNoRsn = [];
  String rmrks1 = "" ;

  CrankHndlRegModel(this.sList1,this.ynList1,this.whyNoRsn,this.rmrks1);

  Map<String, dynamic> toJson() => {
    "paramList": [{
      "cList": ynList1,
      "rmkrs": rmrks1
    }
    ]
  };


}

