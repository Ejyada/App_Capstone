

import 'dart:async';

import 'package:breakfast_locator/controller/account.dart';
import 'package:breakfast_locator/controller/breakfast.dart';
import 'package:breakfast_locator/custom/dialog.dart';
import 'package:breakfast_locator/custom/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:breakfast_locator/custom/colors.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';




class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});


  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  
  Location location = Location();
  
  final _breakfast = Get.put(Breakfast());

  DataSource? _events;
  DateFormat dformat = DateFormat('MMMM dd, yyyy');
  final List<Meeting> meetings = <Meeting>[];  

  List<dynamic> _selected = [];
  
  final _account = Get.put(Account());
  @override
  void initState() {
    super.initState();
    _events = DataSource(meetings);
    get_upcoming();
    get_attending();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> get_attending() async {
    await _breakfast.getAllAttending(_account.user['account_id']).then((res){
      for (var data in _breakfast.attending) {
        Color color = primary;
        if(data['is_cancelled']=="1"){
          color = Colors.red;
        }
        meetings.add(Meeting(data['event_name'],DateTime.parse(data['event_date_time']),DateTime.parse(data['event_date_time']),color, true, data['event_venue_name'],data)); 
       }
       _events!.notifyListeners(CalendarDataSourceAction.reset, meetings);
      setState(() {
      });
    });
  }

  Future<void>  get_upcoming() async {
    await _breakfast.getAttending(_account.user['account_id']).then((res){
          setState(() {
      
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
      appBar: AppBar(iconTheme: IconThemeData(color:Colors.white),title:Text("My Calendar",style:Theme.of(context).primaryTextTheme.titleLarge),backgroundColor: primary,),
      drawer: Drawer(
        child: Column(children:[
          Expanded(child:ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
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
      body: Column(children:[
        Expanded(child:SfCalendar(
          view: CalendarView.month,
          showTodayButton: true,
          showCurrentTimeIndicator: true,
          showDatePickerButton: true,
          showWeekNumber: true,
          maxDate: DateTime(2026),
          dataSource: _events,
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
          onTap: (CalendarTapDetails details){
            _selected = details.appointments!;
            Get.defaultDialog(title:DateFormat('MMMM d').format(details.date!),content: 
                Container(
                  height:300,width: double.maxFinite,child:
                ListView.builder(
                  shrinkWrap: true,

                  padding: const EdgeInsets.only(top:8),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _selected.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    var data = _selected[index].data;
                    return Container(width: double.infinity,padding:EdgeInsets.only(left:8,right:8),child:Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                data['is_cancelled']=='0'?Text('${DateFormat('h:mm a').format(DateTime.parse(data['event_date_time']))} ',style:Theme.of(context).textTheme.bodyMedium):
                Text('${DateFormat('h:mm a').format(DateTime.parse(data['event_date_time']))} - CANCELLED',style:Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red)), 
                Text('${data['event_name']} @ ${data['event_venue_name']}',style:Theme.of(context).textTheme.bodyMedium),
                Text('${data['event_venue_address']}',style:Theme.of(context).textTheme.bodyMedium),
                if(data['is_done']=="0" && data['is_cancelled']==0)Center(child:TextButton(onPressed: () async {
                  await location.getLocation().then((res){
                    var curloc = LatLng(res.latitude!,res.longitude!);
                    Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=${curloc.latitude},${curloc.longitude} &destination=${_breakfast.upcoming[0]['event_venue_latitude']},${_breakfast.upcoming[0]['event_venue_longitude']}&travelmode=driving&dir_action=navigate');
                    _launchURL(url);
                  });

                },child: Text("Get Directions",style:Theme.of(context).textTheme.titleSmall?.copyWith(decoration: TextDecoration.underline,color:primary,decorationColor: primary)))),
                if(data['is_done']=="1")Center(child:TextButton(onPressed: () async {
                  _breakfast.selected_event = data;
                  setState(() {
                    
                  });
                  Get.toNamed('/evaluation');
                },child: Text("Evaluate Event",style:Theme.of(context).textTheme.titleSmall?.copyWith(decoration: TextDecoration.underline,color:primary,decorationColor: primary)))),
                ]));

                }
                ),),
            );
          },

        )),
        Container(width: double.infinity,padding:const EdgeInsets.only(top:16,left:16,right:16,bottom:16),height:280,child:Column(children: [
            Text("Upcoming Event",style:Theme.of(context).textTheme.titleMedium),
            const SizedBox(height:16),
            _breakfast.upcoming.isEmpty?
              Center(child:Text("No upcoming events joined",style:Theme.of(context).textTheme.titleMedium))
            :Container(width: double.infinity,child:Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                _breakfast.upcoming[0]['is_cancelled']=='0'?Text(DateFormat('MMMM d, yyyy h:mm a').format(DateTime.parse(_breakfast.upcoming[0]['event_date_time'])),style:Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.black)): 
                Text('${DateFormat('MMMM d, yyyy h:mm a').format(DateTime.parse(_breakfast.upcoming[0]['event_date_time']))} (Cancelled)',style:Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red)),
                Text('${_breakfast.upcoming[0]['event_name']} @ ${_breakfast.upcoming[0]['event_venue_name']}',style:Theme.of(context).textTheme.bodyMedium),
                Text('${_breakfast.upcoming[0]['event_venue_address']}',style:Theme.of(context).textTheme.bodyMedium),
                Center(child:TextButton(onPressed: () async {
                  await location.getLocation().then((res){
                    var curloc = LatLng(res.latitude!,res.longitude!);
                    Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=${curloc.latitude},${curloc.longitude} &destination=${_breakfast.upcoming[0]['event_venue_latitude']},${_breakfast.upcoming[0]['event_venue_longitude']}&travelmode=driving&dir_action=navigate');
                    _launchURL(url);
                  });

                },child: Text("Get Directions",style:Theme.of(context).textTheme.titleSmall?.copyWith(decoration: TextDecoration.underline,color:primary,decorationColor: primary)),))               
            ],)),
        ],)),
      ])
    ));
  }

}

class DataSource extends CalendarDataSource {
  DataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getNotes(int index) {
   return appointments![index].notes;
  }

  Map<String,dynamic> getData(int index){
    return appointments![index].data;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,this.notes,this.data);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String notes;
  Map<String,dynamic> data;
}