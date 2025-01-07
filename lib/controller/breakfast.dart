import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as http;
import 'package:get/get.dart';
import 'package:breakfast_locator/custom/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Breakfast extends GetxController {
  List<dynamic> breakfast = [];
  List<dynamic> organization = [];
  List<dynamic> attending = [];
  List<dynamic> check_attending = [];
  List<dynamic> upcoming = [];
  List<dynamic> new_breakfast = [];
  Map selected_event = {};

  dynamic last_meeting = 0;

  Future<dynamic> getNewEvent(type,barangay,organization,sex,unit,cyp,marital) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic saved = prefs.getInt('last');
    if(saved!=null){
      last_meeting = saved;
    }
    try {
      final req = (await Dio()
      .get("$url/get_new_event?user_type=$type&barangay_id=$barangay&last_id=$last_meeting&organization_id=$organization&sex=$sex&unit=$unit&cyp=$cyp&marital=$marital"));
      new_breakfast = jsonDecode(req.data);
      return true;
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }





  Future<dynamic> getNearby(lat,lng) async {
  
    try {
      final req = (await Dio()
      .get("$url/get_event_nearby?latitude=$lat&longitude=$lng"));
      
      print(req.data); 
      breakfast = jsonDecode(req.data);
      return true;
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> getLogNearby(lat,lng,type,barangay,organization,sex,unit,cyp,marital) async {
    

    try {
      final req = (await Dio()
      .get("$url/get_log_event_nearby?latitude=$lat&longitude=$lng&user_type=$type&barangay_id=$barangay&organization_id=$organization&sex=$sex&unit=$unit&cyp=$cyp&marital=$marital"));
      
      print(req.data); 
      breakfast = jsonDecode(req.data);
      return true;
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> getOrganization() async {
    
    organization = [];
    
    try {
      final req = (await Dio()
      .get("$url/get_organization_data"));
      
      print(req.data); 
      organization = jsonDecode(req.data);
      return true;
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 

    
  }

  Future<dynamic> getOrganizationEvent(id,lat,lng) async {
    
    breakfast = [];
    try {
      final req = (await Dio()
      .get("$url/get_event_organization?organization_id=$id&latitude=$lat&longitude=$lng"));
      breakfast = jsonDecode(req.data);
      return true;
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> searchEvent(eventName) async {
    
    breakfast = [];
    try {
      final req = (await Dio()
      .get("$url/search_event?event_name=$eventName"));
      breakfast = jsonDecode(req.data);
      return true;
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> getLogOrganizationEvent(id,lat,lng,type,barangay,organization,sex,unit,cyp,marital) async {
    
    breakfast = [];
    try {
      final req = (await Dio()
      .get("$url/get_log_event_organization?organization_id=$id&latitude=$lat&longitude=$lng&user_type=$type&barangay_id=$barangay&organization_id=$organization&sex=$sex&unit=$unit&cyp=$cyp&marital=$marital"));
      breakfast = jsonDecode(req.data);
      return true;
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> attendMeeting(user,meeting) async {
    
    breakfast = [];
    try {
      final req = (await Dio()
      .post("$url/attend_meeting",data:http.FormData.fromMap({'account_id':user,'event_id':meeting})));
      return true;
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> getAttending(user) async {
    upcoming = [];
  
    try {
      final req = (await Dio()
      .get("$url/get_user_attended_event?account_id=$user"));
      
      print(req.data);
      upcoming = jsonDecode(req.data);
      check_attending = [];
      for(var i in upcoming){
        check_attending.add(i['event_id']);
      }
      return true;
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> getAllAttending(user) async {
    
    attending = [];
    try {
      final req = (await Dio()
      .get("$url/get_user_all_attended_event?account_id=$user"));
      
     
      attending = jsonDecode(req.data);
      return true;
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> submitEvaluation(data) async {
    http.FormData form = http.FormData.fromMap(data);
    try { 
      final req = (await Dio()
      .post("$url/submit_evaluation",data:form));
      return true;
    } on DioException catch (e) {
      return "Server error, please try again later.";
    }
  }


  
}
