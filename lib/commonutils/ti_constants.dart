class TiConstants {
  //static String webServiceUrl ="http://cms.indianrail.gov.in/cmswebservicejar/master/";
  //static String webServiceUrl ="https://cms.indianrail.gov.in/CMSWEBSERVICE/master/";
  static String webServiceUrl =
      "http://172.16.4.56:7101/FirstRest-RestService-context-root/resources/TiAppService/";
  //static String webServiceUrl = "http://172.16.25.45:9081/CMSWEBSERVICE/master/";
  //static String webServiceUrl = "http://10.60.200.168/CMSWEBSERVICE/master/";
  static String contextPath = "https://cms.indianrail.gov.in";
  static String loginUserId = "";
  static const APP_STORE_URL =
      'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=in.org.cris.cmsm&mt=8';
  static const PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.cris.cmsm';
  // static String token ="eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhdmluZXNoIiwiZXhwIjoxNjA2MzI0NTg5LCJpYXQiOjE2MDYzMDY1ODl9.-HMhMqK8VsccfrIxb6liKvDZ3desaG6gHcjkP8Cm8FpHA8Cnk8ZpEgDslM8l_-9zQTH2VZj4oFmEMVbb_Dop7Q";
  static Map<String, String> headerInput = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    //"Access-Control-Allow-Origin": "*",
    // "Authorization": "Bearer $token",
    //"application/x-www-form-urlencoded"
  };
}
