import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/qr_code_model.dart';
import '../model/scan_history_model.dart';

///////////////// base uri//////////////
//const baseUri = 'http://194.163.136.227:8087/api/';
//const baseUri = 'https://agility.digifaz.com/api/';
const baseUri = 'https://agility-app.com/api/';

///////////////////////////////////////
///
class RemoteService {
  //////////////////////////////////
  ///initialisation du client http
  var client = http.Client();
  //////////////////////////////
  ///
  ////////////////////////////////////////////////////////////
  /// get all qr code in our BD
  ///////
  Future<List<QrCodeModel>> getQrcodes() async {
    var uri = Uri.parse(baseUri + 'qrcodes');
    var response = await client.get(uri);
    //print('my user Dans remote /////////////////////////// : ${response.body}');
    //print('Dans remote////////////////////////////// : ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = response.body;
      //print(response.body);
      List<QrCodeModel> qrCodeModel = qrCodeModelListFromJson(json);
      print('qr code list : ${qrCodeModel.length}');
      return qrCodeModel;
    }
    return [];
  }

  //////////////////////////////
  ///
  ////////////////////////////////////////////////////////////
  /// get all qr code in our BD
  ///////
  Future<List<ScanHistoryModel>> getScanHistories() async {
    var uri = Uri.parse(baseUri + 'scanCounters');
    var response = await client.get(uri);
    // print('my user Dans remote /////////////////////////// : ${response.body}');
    // print('Dans remote////////////////////////////// : ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = response.body;
      //print(response.body);
      List<ScanHistoryModel> qrCodeModel = scanHistoryModelListFromJson(json);
      print('scan history : ${qrCodeModel.length}');
      return qrCodeModel;
    }
    return [];
  }

  //////////////////////////////// get single user by id //////////////////////
  ///
  /*  Future<MyUserModel?> getSingleUser({required int id}) async {
    var uri = Uri.parse(baseUri + 'visiteurs/$id');
    var response = await client.get(uri);
    //print('my user Dans remote /////////////////////////// : ${response.body}');
    //print('Dans remote////////////////////////////// : ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = response.body;
      //print(response.body);
      MyUserModel user = myUserModelFromJson(json);
      return user;
    }
    return null;
  } */

  //////////////////////////////// get single user by id //////////////////////
  ///
  /* Future<MyUserModel?> getSingleUserByCode(
      {required String CodeVisiteur}) async {
    var uri = Uri.parse(baseUri + 'visiteurs/verifications/$CodeVisiteur');
    var response = await client.get(uri);
    //print('my user Dans remote /////////////////////////// : ${response.body}');
    //print('Dans remote////////////////////////////// : ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = response.body;
      // print(response.body);
      MyUserModel user = myUserModelFromJson(json);
      return user;
    }
    return null;
  } */

  ////////////////////
  ///
  ///////////////// post user detail when otp code is verify//////////////////
  ///
  Future<dynamic> postUserDetails({
    required String api,
    //required MyUser user,
  }) async {
    ////////// parse our url /////////////////////
    var url = Uri.parse(baseUri + api);

    /////////////// encode user to jsn //////////////////////
    // var payload = userToJson(user);

    // http request headers
    var headers = {
      'Content-Type': 'application/json',
    };

    //////////////// post user ////////////
    var response = await client.post(
      url,
      //body: payload,
      headers: headers,
    );

    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 422) {
      //var result = jsonDecode(response.body);
      /* if (result.containsKey("email")) {
        return 'emailError';
      } */
      return null;
    }
  }

  Future<dynamic> postUserCode({
    required String code,
  }) async {
    try {
      var url = Uri.parse(baseUri + 'visiteurs/verifications');
      var data = {
        "code_visite": code,
      };
      var payload = jsonEncode(data);
      var headers = {
        'Content-Type': 'application/json',
      };

      var response = await client.post(
        url,
        body: payload,
        headers: headers,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        //var responseBody = jsonDecode(response.body);
        //print(responseBody);
        return response.body;
      } else if (response.statusCode == 422) {
        return null;
      } else {
        //print('Unexpected status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      //print('Error: $e');
      return null;
    }
  }

  /////////////
  ///
  /////////////////////////////////// edit totine /////////////////////
  ///
  ///
  Future<dynamic> putSomethings({
    required String api,
    required Map<String, dynamic> data,
  }) async {
    ////////// parse our url /////////////////////
    var url = Uri.parse(baseUri + api);
    //var postEmail = {"email": email};
    ///////////// encode email to json objet/////////
    var payload = jsonEncode(data);
    // http request headers
    var headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.put(url, body: payload, headers: headers);
    // print('------------------------///////////////////${response.statusCode}');
    // print('------------------------///////////////////${response.body}');
    //print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      //Tontine tontine = tontineFromJson(response.body);
      var jsdecod = jsonDecode(response.body);
      //print('puuuuut : ${jsdecod['id']}');
      return jsdecod['id'];
    } else {
      return null;
    }
  }

// post new scan history
  Future<dynamic> postScanHistory({
    required ScanHistoryModel scanHistoryModel,
  }) async {
    ////////// parse our url /////////////////////
    var url = Uri.parse('${baseUri}scanCounters');

    /////////////// encode user to jsn //////////////////////
    // var payload = userToJson(user);

    // http request headers
    var headers = {
      'Content-Type': 'application/json',
    };
    String payload = scanHistoryModelToJson(scanHistoryModel);
    //////////////// post user ////////////
    var response = await client.post(
      url,
      body: payload,
      headers: headers,
    );

    //print('postScanHistory : ${response.statusCode}');
    //print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 422) {
      //var result = jsonDecode(response.body);
      /* if (result.containsKey("email")) {
        return 'emailError';
      } */
      return null;
    }
  }
}
