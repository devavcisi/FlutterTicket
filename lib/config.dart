

import 'dart:convert';

getApiUrl() {
  //canliya gecince bu linki al
  //"http://192.168.105.41:8080/easycoProCloudKocaeliKaya/v1"
  // "https://212.12.144.87:8181/easycoProCloudKocaeliKaya-0.0.1/v1";
  // "http://212.12.144.87:8181/easycoProCloudKocaeliKaya-0.0.1/v1";
  //   http://172.18.87.12:5000/swagger/index.html
  return "http://172.16.20.57:5000/api";
}


getbase64Authentication()
{


  String authettusername = "ibrahim";
  String authettpass = "41";
  return 'Basic ' + base64Encode(utf8.encode('$authettusername:$authettpass'));

}