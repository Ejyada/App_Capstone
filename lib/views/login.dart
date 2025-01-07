import 'dart:io';

import 'package:breakfast_locator/controller/breakfast.dart';
import 'package:breakfast_locator/main.dart';
import 'package:breakfast_locator/plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:breakfast_locator/controller/account.dart';
import 'package:breakfast_locator/custom/colors.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _teuser ;
  late TextEditingController _tepass;
  late FocusNode _fnuser;
  late FocusNode _fnpass;
  late bool _vpass;
  late dynamic _euser,_epass;
  final _account = Get.put(Account());
  final _breakfast = Get.put(Breakfast());
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _teuser = TextEditingController();
    _tepass = TextEditingController();
    _fnuser = FocusNode();
    _fnpass = FocusNode();
    
    _vpass = true;
    _euser = null;
    _epass = null;
    _isAndroidPermissionGranted();
    _requestPermissions();
  }

  
  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }
   Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }
  
  @override
  void dispose() {
    selectNotificationStream.close();
    super.dispose();
  }

   Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    int diff = DateTime.parse(_breakfast.upcoming[0]['meeting_date_time']).day-DateTime.now().day;
    String message = "";
    String title = "Upcoming event";
    print(diff);
    if(diff<=2){
      if(diff==2){
        title = "Upcoming event in 2 days";
      }
      if(diff==1){
        title = "Upcoming event tomorrow";
      }
      if(diff==0){
        title = "Upcoming event today";
      }
      message = "${_breakfast.upcoming[0]['meeting_topic']} @ ${_breakfast.upcoming[0]['meeting_venue_name']}";
    }
    await flutterLocalNotificationsPlugin.show(
        id++,title, message, notificationDetails,
        payload: 'upcoming');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
    canPop: false,
    child:Scaffold(
      backgroundColor: primary,
      
      body:
      
      SingleChildScrollView(child:Container(
        padding: const EdgeInsets.only(left:16,right:16,top:40,bottom:10),
        
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            const SizedBox(height: 80,),
            Image.asset('assets/logo.png',width: 150,),
            const SizedBox(height:24),
            
            Text("BCBP",style:Theme.of(context).primaryTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800),textAlign: TextAlign.center,),
            const SizedBox(height:8),
            Text("EVENT MANAGEMENT",style:Theme.of(context).primaryTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
            const SizedBox(height:24),
            TextFormField(
              controller:_teuser,
              focusNode:_fnuser,
              style:Theme.of(context).primaryTextTheme.bodyLarge,

              onChanged: (val){},
              decoration:  InputDecoration(
                labelText: "Username",
                labelStyle: Theme.of(context).primaryTextTheme.titleMedium,
                enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0),
                ),
                focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0),
                ),
                errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 0.0),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                ),
                error: _euser!=null?SizedBox():null,

                errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
              ),
            ),
            const SizedBox(height:24),
            TextFormField(
              controller:_tepass,
              focusNode:_fnpass,
              obscureText: _vpass,
              
              style:Theme.of(context).primaryTextTheme.bodyLarge,

              onChanged: (val){},
              decoration:  InputDecoration(
                labelText: "Password",
                labelStyle: Theme.of(context).primaryTextTheme.titleMedium,
                enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0),
                ),
                focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0),
                ),
                errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 0.0),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                ),
                errorText: _epass,
                errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                errorMaxLines: 2,
                suffixIcon: IconButton(onPressed: (){setState(() {
                      _vpass = !_vpass;
                    });},
                    icon: _vpass?const Icon(Icons.visibility_off,color:Colors.white):const Icon(Icons.visibility,color:Colors.white)),    
              ),
            ),
            
            const SizedBox(height:36),
            SizedBox(width: double.infinity,child:FilledButton(style:FilledButton.styleFrom(backgroundColor: Colors.white),onPressed: () async {
              _account.login(_teuser.text,_tepass.text).then((val){
                if(val==true){
                  print(_account.user['user_status']);
                  if(_account.user['user_status']=="Pending Approval"){
                    _euser = "";
                    _epass = "Your account is still under review";
                  }
                  else if(_account.user['user_status']=="Declined"){
                    _euser = "";
                    _epass = "Your account registration request was declined by the admin";
                  }
                  else if(_account.user['user_status']=="Inactive"){
                    _euser = "";
                    _epass = "Your account is Disabled";
                  }
                  else{
                    _euser = null;
                    _epass = null;
                    _breakfast.getAttending(_account.user['user_id']).then((res){
                      
                      if(_breakfast.upcoming.isNotEmpty){
                        _showNotification();
                      }
                    });
                    Get.toNamed('/home');
                  }
                  setState(() {
                    
                  });     
                }
                else{
                  setState(() {
                    _euser = "";
                    _epass = val;
                  });
                }
              });
                        
            }, child: Text('LOG IN',style:Theme.of(context).textTheme.titleMedium))),
            const SizedBox(height:8),
            
            Align(alignment:Alignment.center,child:TextButton(onPressed: (){
              Get.toNamed('/register');
            }, child: Text("NO ACCOUNT YET? REGISTER HERE!",style:Theme.of(context).primaryTextTheme.titleSmall?.copyWith(decoration: TextDecoration.underline,decorationColor: Colors.white))))
           
            ]))
    )));
  }
}
