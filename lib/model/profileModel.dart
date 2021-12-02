import 'dart:convert';

class profileModel {
  String userName;
  String userMobile;
  String userMailid;
  String userDOB;
  String userDOA;
  String userDOJ;
  String userHQ;
  String userDvsn;
  String userSection;
  String userDesignation;

  profileModel(
      {this.userName,
      this.userMobile,
      this.userMailid,
      this.userDOB,
      this.userDOA,
      this.userDOJ,
      this.userHQ,
      this.userDvsn,
      this.userSection,
      this.userDesignation});

  factory profileModel.fromJson(Map<String, dynamic> data) {
    // casting as a nullable String so we can do an explicit null check
    final userName = data['userName'] as String;
    final userMobile = data['userMobile'] as String;
    final userMailid = data['userMailid'] as String;
    final userDOB = data['userDOB'] as String;
    final userDOA = data['userDOA'] as String;
    final userDOJ = data['userDOJ'] as String;
    final userHQ = data['userHQ'] as String;
    final userDvsn = data['userDvsn'] as String;
    final userSection = data['userSection'] as String;
    final userDesignation = data['userDesignation'] as String;
    if (userName == null) {
      throw UnsupportedError('Invalid data: $data -> "userName" is missing');
    }
    return profileModel(
        userName: userName,
        userMobile: userMobile,
        userMailid: userMailid,
        userDOB: userDOB,
        userDOA: userDOA,
        userDOJ: userDOJ,
        userHQ: userHQ,
        userDvsn: userDvsn,
        userSection: userSection,
        userDesignation: userDesignation);
  }
}
