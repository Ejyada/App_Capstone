

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

class MapPage extends StatefulWidget {
  const MapPage({super.key});


  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  GoogleMapController? mapController;
  Location location = Location();
  LatLng curloc = const LatLng(14.599512,120.984222);
  final _breakfast = Get.put(Breakfast());
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String buttonText = "";
  late BitmapDescriptor customMarker;
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

    
    initiateMarkers();
    
  }

 


  void initiateMarkers()async{
    customMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/marker.png");
    buildMarker();
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await location.getLocation().then((res){
      curloc = LatLng(res.latitude!,res.longitude!);
      setState(() {
        mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target:LatLng(double.parse(_breakfast.selected_event['event_venue_latitude']),double.parse(_breakfast.selected_event['event_venue_longitude'])),zoom:17)));
      });
    });
  } 

  void _getAttended() async {
    await _breakfast.getAttending(_account.user['account_id']);
  }

 
  void buildMarker() {
    for (var data in _breakfast.breakfast) {
        final marker = Marker(
        markerId: MarkerId(data['event_id']),
        position: LatLng(double.parse(data['event_venue_latitude']),double.parse(data['event_venue_longitude'])),
          
        icon: customMarker,
      
        onTap: (){
          Get.dialog( 
            Container(
              padding: const EdgeInsets.only(top:24,left:24,right:24),
              decoration: const BoxDecoration(
                color:primary
              ),
              child:SingleChildScrollView(child:Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,children: [
               
                Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
                  Expanded(flex:2,child:Column(children: [
                    Text("BCBP",style:Theme.of(context).primaryTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900)),
                    Text("${data['organization_name']} ${data['organization_type']}",style:Theme.of(context).primaryTextTheme.titleLarge),
                  ],)),
                  Expanded(flex:1,child:Image.asset('assets/logo.png',width: 100,)),
                ],),
                const SizedBox(height:16),
                Text("${data['event_name']}",style:Theme.of(context).primaryTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                if(data['event_theme']!=null)const SizedBox(height:8),
                if(data['event_theme']!=null)Text("“${data['event_theme']}”",style:Theme.of(context).primaryTextTheme.titleLarge?.copyWith(fontStyle: FontStyle.italic,fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                if(data['event_theme']!=null)Text("Theme",style:Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(),textAlign: TextAlign.center,),
                const SizedBox(height:16),
                _account.user.isEmpty?Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children:[
                  Center(child:Text("Please login to view event information",style: Theme.of(context).primaryTextTheme.titleMedium,textAlign: TextAlign.center,)),
                  const SizedBox(height:24),
                  
                  Container(width:double.infinity,child:TextButton.icon(onPressed: (){
                  
                  Get.toNamed('/login');
                },icon:Icon(Icons.login,color: Colors.white,), label: Text("Click here to login/register",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(decoration: TextDecoration.underline,decorationColor: Colors.white)))),
                ]):Column(children: [
                  
                if(data['speaker_is_visible']=="1")Text("${data['event_speaker']}",style:Theme.of(context).primaryTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                if(data['speaker_is_visible']=="1")Text("Speaker",style:Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(),textAlign: TextAlign.center,),
                const SizedBox(height:16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child:Text("Mode",style:Theme.of(context).primaryTextTheme.titleMedium,textAlign: TextAlign.left,)),
                  Expanded(child:Text("${data['event_mode']}",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.right,)),
                ],),
                const SizedBox(height:8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child:Text("Assessment",style:Theme.of(context).primaryTextTheme.titleMedium,textAlign: TextAlign.left,)),
                  Expanded(child:Text("P ${data['event_assessment']}",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.right,)),
                ],),
                const SizedBox(height:8),
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child:Text("Venue",style:Theme.of(context).primaryTextTheme.titleMedium,textAlign: TextAlign.left,)),
                  Expanded(child:Text("${data['event_venue_name']}",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.right,)),
                ],),
                const SizedBox(height:8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child:Text("Address",style:Theme.of(context).primaryTextTheme.titleMedium,textAlign: TextAlign.left,)),
                  Expanded(child:Text("${data['event_venue_address']}",style:Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.right,)),
                ],),
                const SizedBox(height:8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child:Text("Additional Information",style:Theme.of(context).primaryTextTheme.titleMedium,textAlign: TextAlign.left,)),
                  Expanded(child:Text("${data['event_venue_additional_information']}",style:Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.right,)),
                ],),
                const SizedBox(height:8),
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child:Text("Date",style:Theme.of(context).primaryTextTheme.titleMedium,textAlign: TextAlign.left,)),
                  Expanded(child:Text("${DateFormat('MMMM d, yyyy').format(DateTime.parse(data['event_date_time']))}",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.right,)),
                ],),
                const SizedBox(height:8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child:Text("Time",style:Theme.of(context).primaryTextTheme.titleMedium,textAlign: TextAlign.left,)),
                  Expanded(child:Text("${DateFormat('h:mm a').format(DateTime.parse(data['event_date_time']))}",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.right,)),
                ],),
                const SizedBox(height:8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child:Text("Contact Person",style:Theme.of(context).primaryTextTheme.titleMedium,textAlign: TextAlign.left,)),
                  Expanded(child:Text("${data['first_name']} ${data['last_name']}",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.right,)),
                ],),
                const SizedBox(height:8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child:Text("Contact Number",style:Theme.of(context).primaryTextTheme.titleMedium,textAlign: TextAlign.left,)),
                  Expanded(child:Text("${data['contact_number']}",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),textAlign: TextAlign.right,)),
                ],),
                const SizedBox(height:16),
                Container(width:double.infinity,child:TextButton.icon(onPressed: (){
                  
                  Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=${curloc.latitude},${curloc.longitude} &destination=${data['event_venue_latitude']},${data['event_venue_longitude']}&travelmode=driving&dir_action=navigate');

                  _launchURL(url);
                },icon:Icon(Icons.directions,color: Colors.white,), label: Text("Get Directions",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(decoration: TextDecoration.underline,decorationColor: Colors.white)))),
                const SizedBox(height:8),
                if(_account.user.isNotEmpty)_breakfast.check_attending.contains(data['event_id'])?
                Text("You are attending this event",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(color:Colors.white)):
                Container(width:double.infinity,child:ElevatedButton(onPressed: (){
                  showLoading(context);
                  _breakfast.attendMeeting(_account.user['account_id'], data['event_id']).then((res){
                    Get.back();
                    if(!res){
                      showError(context);
                    }
                    else{

                      Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){
                        _getAttended();
                        Get.back();
                        Get.back();
                      },titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),title: "Successfully Attended",content:Text("The meeting can be seen in your calendar, and you will get notified for the meeting.",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"I Understand",buttonColor:primary,confirmTextColor: Colors.white);

          
                    }
                    
                    setState(() {
                      
                    });
                  });
                }, child: Text("Attend",style:Theme.of(context).primaryTextTheme.titleMedium?.copyWith(color:primary)))),
                const SizedBox(height:16),
              ],),
              ],),

            ),
            )
          );
        }
        );
        markers[MarkerId(data['event_id'])] = marker;  
      }
      
  }


  Future<void> _getUserLocation() async {
     await location.getLocation().then((res){
      curloc = LatLng(res.latitude!,res.longitude!);

    
    setState(() {
      // mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target:curloc,zoom:17)));
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
    canPop: true,
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
      body:  Stack(
          children: <Widget>[GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: true,
            mapType: MapType.values[4],
            // style: mapstyle,
            padding: const EdgeInsets.only(top:40),
            initialCameraPosition: CameraPosition(
              target: curloc,
              zoom: 16,
            ),
            markers: markers.values.toSet(),
          ),
          
      ]))
    );
  }

  
}