

import 'package:breakfast_locator/custom/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future showLoading(context){
  return Get.defaultDialog(
    barrierDismissible: false,
    onWillPop: () async{return false;},
    titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),
    title: "Loading",
    content:const Text("Please wait for a while, we are currently processing your request.",textAlign: TextAlign.center,),
    contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),);
}

Future showError(context){
  return Get.defaultDialog(
    barrierDismissible: false,
    onWillPop: () async{return false;},
    onConfirm: (){Get.back();},
    titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.red,fontWeight: FontWeight.w600),
    title: "Server Error",
    content:const Text("An error was encountered while processing your request, please try again later. If problem persists please contact the administrator",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"Okay",buttonColor: primary,confirmTextColor: Colors.white);                 
}