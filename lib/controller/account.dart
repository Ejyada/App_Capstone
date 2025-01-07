import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as http;
import 'package:get/get.dart';
import 'package:breakfast_locator/custom/url.dart';

class Account extends GetxController {
  Map user = {}; 
  List<dynamic> region = [];
  List<dynamic> province = [];
  List<dynamic> municity = [];
  List<dynamic> barangay = [];
  List<dynamic> organization = [];


  Future<dynamic> login(username, password) async {
    
    user = {};
    
    try {
      
      final login = (await Dio()
      .post("$url/user_login",data:http.FormData.fromMap({"user_name":username,"user_pass":password})
      ));
      login.data = jsonDecode(login.data);
      print(login.data);
      if(login.data.length == 0){
        return "Incorrect Username or Password";
      }
      else{
        if(login.data[0]['user_status'] == 'Inactive'){
          return "User not allowed, your account is currently inactive";
        }
      }
      user = login.data[0];
      return true;
    } on DioException catch (e) {
      print(e.response?.data);
      return "Server error, please try again later.";
      
    }
  }

  Future<dynamic> register(data) async{
    http.FormData fd = http.FormData.fromMap(data);
    
    try {
      final reg = (await Dio()
      .post("$url/user_register",data:fd)
      );
      return reg.data;
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.message);
      return "error";      
    }
  }

  Future<dynamic> update_profile(data) async{
    http.FormData fd = http.FormData.fromMap(data);
    
    try {
      final reg = (await Dio()
      .post("$url/update_profile",data:fd)
      );
      if(reg.data=="exists"){
        return "exists";
      }
      else{
        user = jsonDecode(reg.data)[0];
        return "success"; 
      }
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.message);
      return "error";      
    }
  }

  Future<dynamic> change_password(data) async{
    http.FormData fd = http.FormData.fromMap(data);
    
    try {
      final reg = (await Dio()
      .post("$url/change_password",data:fd)
      );
      return reg.data;
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.message);
      return "error";      
    }
  }


  Future<dynamic> getRegion() async {
    
    region = [];
    try {
      final req = (await Dio()
      .get("$url/get_region"));
      region = jsonDecode(req.data);
      
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> getProvince(id) async {
    
    province = [];
    try {
      final req = (await Dio()
      .get("$url/get_province?region_id=$id"));
      province = jsonDecode(req.data);
      
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> getMunicity(id) async {
    
    municity = [];
    try {
      final req = (await Dio()
      .get("$url/get_municity?province_id=$id"));
      municity = jsonDecode(req.data);
      
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

  Future<dynamic> getBarangay(id) async {
    
    barangay = [];
    try {
      final req = (await Dio()
      .get("$url/get_barangay?municity_id=$id"));
      barangay = jsonDecode(req.data);
      
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
      .get("$url/get_organization?"));
      organization = jsonDecode(req.data);
      
    }
    on DioException catch (e) {
        print(e.response?.data);
        print(e.response?.statusCode);
      return false;
    } 
  }

}



