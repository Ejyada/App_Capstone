

import 'dart:async';
import 'dart:io';

import 'package:breakfast_locator/controller/account.dart';
import 'package:breakfast_locator/controller/breakfast.dart';
import 'package:breakfast_locator/custom/dialog.dart';
import 'package:breakfast_locator/custom/global.dart';
import 'package:breakfast_locator/custom/map_style.dart';
import 'package:breakfast_locator/main.dart';
import 'package:breakfast_locator/plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:breakfast_locator/custom/colors.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage(notificationAppLaunchDetails, {super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  GoogleMapController? mapController;
  Location location = Location();
  LatLng curloc = const LatLng(14.599512,120.984222);
  final _breakfast = Get.put(Breakfast());
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String buttonText = "";
  late BitmapDescriptor customMarker;
  late TextEditingController _tesevent; 
  String _filterOrg = "";
  bool _fetching = true;
  bool _search = false;
  bool _new = false;
  String last_click = "";

  final _account = Get.put(Account());
  @override
  void initState() {
    super.initState();
    // print(_account.user);

    _fetching=true;
    _search = false;
    _tesevent = TextEditingController();
    _getOrganization();
    getNewEvent();
    _configureSelectNotificationSubject();
    if(_account.user.isNotEmpty){
        _getUserLocation().then((value) => _getLogNearby());
        setState(() {
          
        });

      }
      else{
        
        _getUserLocation().then((value) => _getNearby());
        setState(() {
          
        });
      }
    if(!is_enabled){
      if(_account.user.isNotEmpty){
        is_enabled = true;
        timer1 = Timer.periodic(Duration(seconds: 20), (timer) async{
          getNewEvent();
        });    
        
    

      timer2 = Timer.periodic(const Duration(seconds: 20), (timer) {
      
        _getUserLocation().then((value) => _getLogNearby());
        setState(() {
          
        });
      });
      }
      else{
        timer2= Timer.periodic(const Duration(seconds: 20), (timer) {
        
          _getUserLocation().then((value) => _getNearby());
          setState(() {
            
          });
        });
      }
    }
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream
        .listen((NotificationResponse? response) async {
          if(response!.payload=="new"){
            Get.toNamed('/home');
          }
          if(response!.payload=="upcoming"){
            Get.toNamed('/calendar');
          }
    });
  }

   Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('new_event', 'Event',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        id++,"New upcoming event", "Check it out, to join!", notificationDetails,
        payload: 'new');
  }


  void getNewEvent()async{
    String fsex = "";
    if(_account.user['sex']=="male"){
      fsex = "Men";
    }
    else{
      fsex = "Ladies";
    }
    String funit = "Unit na";
    if(_account.user['unit']!=null){
      funit = "Unit ${_account.user['unit']}";
    }
    String cyp = "na";
    if(_account.user['marital_status']=="single"){
      DateTime now = DateTime.now();
      Duration age = now.difference(DateTime.parse(_account.user['birthdate']));
      int years = age.inDays ~/ 365;
      if(years>=22&&years<=35){
        cyp = "CYP";
      }
    }

    _breakfast.getNewEvent(_account.user['user_type'],_account.user['barangay_id'],_account.user['organization_id'],fsex,funit,cyp,_account.user['marital_status']).then((res) async {
      if(_breakfast.new_breakfast.isNotEmpty){
        _new = true;
        _breakfast.breakfast = _breakfast.new_breakfast;
        setState(() {
          
        });
        _showNotification();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('last',int.parse(_breakfast.new_breakfast.last['event_id']));
      }
    });
  }



  void _getAttended() async {
    await _breakfast.getAttending(_account.user['account_id']);
  }

  void _getOrganization() async {
    _fetching = true;
    setState((){});
    await _breakfast.getOrganization().then((val){
      if(_breakfast.breakfast.isNotEmpty){
        _filterOrg = _breakfast.breakfast[0]['organization_name'];
      }
      _fetching = false;
      setState((){});
    });
  }

  Future<bool> _getNearby() async {
    _fetching = true;
    last_click = "nearby";
    if(_search){
      return true;
    }
    setState(() {});
    _breakfast.getNearby(curloc.latitude,curloc.longitude).then((val) async {
      _fetching = false;
      setState(() {});
      return true;
    });
    return false;
  }

  Future<void> _filterOrganization(val)async {
    showLoading(context);
          Get.back();
    _breakfast.getOrganizationEvent(val.toString(),curloc.latitude,curloc.longitude).then((val){
      _fetching = false;
      setState((){});
    });
  }

  Future<bool> _getLogNearby() async {
    _fetching = true;
    last_click = "nearby";
    String fsex = "";
    
    if(_search){
      return true;
    }
    if(_account.user['sex']=="male"){
      fsex = "Men";
    }
    else{
      fsex = "Ladies";
    }
    String funit = "Unit na";
    if(_account.user['unit']!=null){
      funit = "Unit ${_account.user['unit']}";
    }
    String cyp = "na";
    if(_account.user['marital_status']=="single"){
      DateTime now = DateTime.now();
      Duration age = now.difference(DateTime.parse(_account.user['birthdate']));
      int years = age.inDays ~/ 365;
      if(years>=22&&years<=35){
        cyp = "CYP";
      }
    }
    _getAttended();
    setState(() {});
    _breakfast.getLogNearby(curloc.latitude,curloc.longitude,_account.user['user_type'],_account.user['barangay_id'],_account.user['organization_id'],fsex,funit,cyp,_account.user['marital_status']).then((val) async {
      _fetching = false;
      setState(() {});
      return true;
    });
    return false;
  }

  Future<void> _filterLogOrganization(val)async {
    String fsex = "";
    if(_account.user['sex']=="male"){
      fsex = "Men";
    }
    else{
      fsex = "Ladies";
    }
    String funit = "Unit na";
    if(_account.user['unit']!=null){
      funit = "Unit ${_account.user['unit']}";
    }
    String cyp = "na";
    if(_account.user['marital_status']=="single"){
      DateTime now = DateTime.now();
      Duration age = now.difference(DateTime.parse(_account.user['birthdate']));
      int years = age.inDays ~/ 365;
      if(years>=22&&years<=35){
        cyp = "CYP";
      }
    }
    showLoading(context);
    _getAttended();
    _breakfast.getLogOrganizationEvent(val.toString(),curloc.latitude,curloc.longitude,_account.user['user_type'],_account.user['barangay_id'],_account.user['organization_id'],fsex,funit,cyp,_account.user['marital_status']).then((val){
      Get.back();
      _fetching = false;
      setState((){});
    });
  }
  

  Future<void> _getUserLocation() async {
     await location.getLocation().then((res){
      curloc = LatLng(res.latitude!,res.longitude!);

    
    setState(() {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target:curloc,zoom:17)));
    }); 
    });
    
  }



  

  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
  
    return PopScope(
    canPop: false,
    child:Scaffold(
      key: _scaffoldKey,
      drawer: _account.user.isEmpty?null:Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Column(children:[
          Expanded(child:ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: primary,
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children:
              [
                Image.asset('assets/logo.png',width: 100,),
                Text("BCBP EVENT MANAGEMENT",style:Theme.of(context).primaryTextTheme.titleMedium),
              ]),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded,color:primary),
              title: Text('Home',style:Theme.of(context).textTheme.titleMedium?.copyWith(color:primary)),
              onTap: () {

                Get.toNamed('/home');
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.calendar_month,color:primary),
              title: Text('Calendar',style:Theme.of(context).textTheme.titleMedium?.copyWith(color:primary)),
              onTap: () {
                
                Get.toNamed('/calendar');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person,color:primary),
              title: Text('Profile',style:Theme.of(context).textTheme.titleMedium?.copyWith(color:primary)),
              onTap: () {
                timer1!.cancel();
                timer2!.cancel();
                is_enabled = false;
                setState(() {
                  
                });
                Get.toNamed('/profile');
              },
            ),
          ],
        )),
        Container(
              // This align moves the children to the bottom
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  // This container holds all the children that will be aligned
                  // on the bottom and should not scroll with the above ListView
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                          onTap: (){
                            _account.user = {};
                            setState(() {
                              
                            });
                            timer1!.cancel();
                            timer2!.cancel();
                            is_enabled = false;
                            setState(() {
                              
                            });
                            Get.toNamed('/login');
                          },
                          leading: Icon(Icons.logout,color:primary),
                          title: Text('LOGOUT',style:Theme.of(context).textTheme.titleMedium?.copyWith(color:primary))),
                      
                    ],
                  )
                )
              )
            )
        ])
      ),
      body: Container(child:Column(children: [  
          Align(alignment: Alignment.topLeft,child:
            Container(height: _search?150:95,padding: const EdgeInsets.only(left:8,right:8),color:primary.withOpacity(0.9),child:Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children:[
              const SizedBox(height: 40,),
              Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[
                _account.user.isEmpty?TextButton.icon(onPressed: (){
                  timer2!.cancel();
                  Get.toNamed('/login');
                }, icon: Icon(Icons.login_rounded,color:Colors.white),label:Text("Login",style:Theme.of(context).primaryTextTheme.titleMedium)):
                IconButton(onPressed: (){
                  _scaffoldKey.currentState!.openDrawer();
                }, icon: Icon(Icons.menu_rounded,color:Colors.white)),
                if(_search)Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.center,children:[
                  Column(children: [
                    DropdownButton(
                    iconEnabledColor: Colors.white,
                    hint: Text("Organization",style: Theme.of(context).primaryTextTheme.titleMedium,),
                    
                    dropdownColor: primary,
                    padding: EdgeInsets.only(left:10,right:10),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color:Colors.white),
                  
                    items: _breakfast.organization.map((item) {
                      return DropdownMenuItem(
                        value: item['organization_id'],
                        child: Text(item['organization_name']),
                      );
                    }).toList(),
                    onChanged: (newValue){
                      _filterOrg = newValue.toString();
                      last_click = "org";
                      if(_account.user.isEmpty){
                        _filterOrganization(newValue);
                      }
                      else{
                        _filterLogOrganization(newValue);
                      }
                      setState(() {
                        
                      });
                      
                  },),
                  const SizedBox(height:4),
                  Container(width: 120,child:TextField(
                      controller:_tesevent,
                      style:Theme.of(context).primaryTextTheme.bodyLarge,
                      decoration: InputDecoration(hintText: "Event Name",hintStyle: Theme.of(context).primaryTextTheme.titleMedium),

                      onEditingComplete: () async {
                        showLoading(context);
                        await _breakfast.searchEvent(_tesevent.text).then((res){
                          _getAttended();
                          Get.back();
                          setState(() {
                            
                          });
                        });
                      },
                    )),
                  ],),
                  
                IconButton(onPressed: (){
                  _search = false;
                  setState(() {
                    
                  });
                }, icon: Icon(Icons.close_rounded,color:Colors.white))
                ])),
                if(!_search)TextButton.icon(onPressed: (){
                  _search = true;
                  setState(() {
                    
                  });
                }, icon: Icon(Icons.search,color:Colors.white), label: Text("Search",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(color:Colors.white)))
              ]),
              
              
  
              
            )]),
          )),
          
        _breakfast.breakfast.length==0&&_fetching==false?Expanded(child: Center(child:Text("No upcoming event found.",style:Theme.of(context).textTheme.bodyMedium)),):Expanded(child:ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _breakfast.breakfast.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context,int index){
                      var data = _breakfast.breakfast[index];
                      bool attending = false;
                      
                      print(_breakfast.check_attending);
                      if(_breakfast.check_attending.contains(data['event_id'])){
                        attending = true;
                      }
                      return Container(margin:const EdgeInsets.only(bottom:2),padding:const EdgeInsets.symmetric(vertical: 12,horizontal:12),width: double.infinity
                  ,decoration:BoxDecoration(color:primary,border: Border.all(color:Colors.white,width:1),borderRadius: BorderRadius.circular(8))
                  ,child:Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children:[
                              Text('${DateFormat('MMMM d, yyyy h:mm a').format(DateTime.parse(data['event_date_time']))}',style:Theme.of(context).primaryTextTheme.bodyMedium), 
                              const SizedBox(height:2),
                              Row(children:[Icon(Icons.meeting_room_rounded,color:Colors.white),Expanded(child:Text("${data['event_name']}@ ${data['event_venue_name']}",style:Theme.of(context).primaryTextTheme.bodyMedium))]), 
                              const SizedBox(height:2),
                              Text("Mode: ${data['event_mode']}",style:Theme.of(context).primaryTextTheme.bodyMedium),
                              const SizedBox(height:8),

                              Center(child:TextButton.icon(onPressed: (){
                                _breakfast.selected_event = data;
                                Get.toNamed('/map');
                                
                              },icon:Icon(Icons.map,color:Colors.white),label:Text("View",style:Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(decoration: TextDecoration.underline,decorationColor: Colors.white)))),

                              if(_account.user.isNotEmpty)attending?Center(child:Container(padding: EdgeInsets.all(8),decoration: BoxDecoration(border: Border.all(color:Colors.white),borderRadius: BorderRadius.circular(16)),child:Text("You are attending this event",style:Theme.of(context).primaryTextTheme.titleMedium))):Container(width:double.infinity,child:ElevatedButton(onPressed: (){
                                showLoading(context);
                                _breakfast.attendMeeting(_account.user['account_id'], data['event_id']).then((res){
                                  Get.back();
                                  if(!res){
                                    showError(context);
                                  }
                                  else{

                                    Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){
                                      _getAttended();
                                      _getLogNearby();
                                      Get.back();
                                      setState(() {
                                        
                                      });
                                    },titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),title: "Successfully Attended",content:Text("The meeting can be seen in your calendar, and you will get notified for the meeting.",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"I Understand",buttonColor:primary,confirmTextColor: Colors.white);

                        
                                  }
                                  
                                  setState(() {
                                    
                                  });
                                });
                              }, child: Text("Attend",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(color:primary)))),
                        ]));
                    },
                  ))
        
      ]))
    ));
  }
}