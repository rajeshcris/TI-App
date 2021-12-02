import 'dart:convert';

import 'package:ti/commonutils/ti_constants.dart';
import 'package:ti/commonutils/ti_utilities.dart';
import 'package:ti/commonutils/database_helper.dart';
import 'package:ti/commonutils/logger.dart';
import 'package:ti/model/user.dart';
import 'package:http/http.dart' as http;

class LoginBl {
  static final log = getLogger('LoginBl');
  static final dbHelper = DatabaseHelper.instance;
  LoginBl() {
    log.d("LoginBl called---");
  }

  static Future<String> checkLoginStatusAtAppStarting() async {
    log.d('StartAppEvent in StartAppBloc');
    String appLoginStatus;
    try {
      var isSignedIn = await dbHelper.isSignedIn();
      log.d('startapp_bloc isSignedIn()-$isSignedIn');
      if (isSignedIn) {
        log.d('User is already signed in');
        TiUser user = await dbHelper.getCurrentUser();
        TiUtilities.setTiUser(user);
        appLoginStatus = 'LOGGED_IN';
      } else {
        log.d('Login page loading');
        appLoginStatus = 'NOT_LOGGED_IN';
      }
    } catch (e) {
      appLoginStatus = 'NOT_LOGGED_IN';
    }
    return appLoginStatus;
  }

  static Future createPost(dynamic url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return User.fromJson(json.decode(response.body));
    });
  }

  static Future<String> login1(
      String userType, String userId, String password) async {
    var jsonResult;
    Map<String, dynamic> urlinput = {
      'strUserid': userId,
      'strPassword': password
    };
    String urlInputString = json.encode(urlinput);
    var url1 =
        'http://172.16.4.56:7101/FirstRest-RestService-context-root/resources/TiAppService/CheckLogin';
    log.d("url = " + url1);
    log.d("urlInputString = " + urlInputString);
    log.d('1111111111111111111');
    final response = await http.post(Uri.parse(url1),
        headers: TiConstants.headerInput,
        body: urlInputString,
        encoding: Encoding.getByName("utf-8"));
    log.d('22 222222222222222');
    //jsonResult = User.fromJson(jsonDecode(response.body));
    jsonResult = json.decode(response.body);
    log.d('22 333');
    final loginstatus = User.fromJson(jsonResult);
    log.d('22 33311');
    log.d("response code = " + loginstatus.status);
    return loginstatus.status;
  }

  static Future<String> login(
      String userType, String userId, String password) async {
    String loginResult;
    try {
      // TiUser user;
      TiUser user = await dbHelper.callLoginWebService(
          userType, userId.trim().toUpperCase(), password);
      log.d(user.roleid);
      log.d('Role Id in LoginBloc ' + user.roleid);
      log.d('authlevel LoginBloc ' + user.authlevel);
      TiUtilities.setTiUser(user);
      loginResult = 'LOG_IN_SUCCESS';
    } catch (e) {
      loginResult = 'LOG_IN_FAIL';
    }
    return loginResult;
  }

  static Future<String> logOut() async {
    String loginOutResult;
    try {
      final dbHelper = DatabaseHelper.instance;
      dbHelper.deleteLoginUser();
      TiUtilities.user = null;
      loginOutResult = 'LOG_OUT_SUCCESS';
    } catch (e) {
      loginOutResult = 'LOG_OUT_FAIL';
    }
    return loginOutResult;
  }

  static Future<String> changePassword(
      String currentPassword, String newPassword) async {
    String userType, changePasswordResponseMessage = "";
    var jsonResult;
    if (TiUtilities.user.roleid == 'CREW' || TiUtilities.user.roleid == 'LI') {
      userType = TiUtilities.user.roleid;
    } else {
      userType = TiUtilities.user.authlevel;
    }
    try {
      Map<String, dynamic> urlinput = {
        'paramList': [
          TiUtilities.user.loginid,
          currentPassword,
          newPassword,
          userType
        ]
      };
      String urlInputString = json.encode(urlinput);
      var url = TiConstants.webServiceUrl + 'changePassword';
      log.d("url==$url======urlInputString=====$urlInputString");
      final response = await http.post(Uri.parse(url),
          headers: TiConstants.headerInput,
          body: urlInputString,
          encoding: Encoding.getByName("utf-8"));
      jsonResult = json.decode(response.body);
      log.d("response code = " + response.statusCode.toString());
      if (response == null || response.statusCode != 200) {
        throw Exception(
            'HTTP request failed, statusCode: ${response.statusCode}');
      } else {
        log.d("json result = " + jsonResult.toString());
        changePasswordResponseMessage = jsonResult['vosList'][0].toString();
      }
    } catch (e) {
      log.d(e);
    }
    return changePasswordResponseMessage;
  }
}
