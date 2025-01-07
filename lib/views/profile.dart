

import 'dart:async';

import 'package:breakfast_locator/controller/account.dart';
import 'package:breakfast_locator/controller/breakfast.dart';
import 'package:breakfast_locator/custom/dialog.dart';
import 'package:breakfast_locator/custom/global.dart';
import 'package:flutter/cupertino.dart';
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




class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
    late TextEditingController _teuser,
                            _tepass,
                            _tecpass,
                            _tefname,
                            _temname,
                            _telname,
                            _tebdate,
                            _tephone,
                            _tesex,
                            _tepurok,
                            _teaddress,
                            _tebarangay,
                            _temunicity,
                            _teprovince,
                            _teregion,
                            _teunit,
                            _teutype,
                            _temarital,
                            _teorganization;

      late FocusNode _fnuser,
                _fnpass,
                _fncpass,
                _fnfname,
                _fnmname,
                _fnlname,
                _fnbdate,
                _fnphone,
                _fnsex,
                _fnpurok,
                _fnaddress,
                _fnbarangay,
                _fnmunicity,
                _fnprovince,
                _fnregion,
                _fnunit,
                _fnutype,
                _fnmarital,
                _fnorganization;
    
      late bool _vpass,_vcpass;

      late dynamic _euser,
              _epass,
              _ecpass,
              _efname,
              _emname,
              _elname,
              _ebdate,
              _ephone,
              _esex,
              _epurok,
              _eaddress,
              _ebarangay,
              _emunicity,
              _eprovince,
              _eregion,
              _eunit,
              _eutype,
              _emarital,
              _eorganization;
    
    bool _notediting = true;
    bool _changepassword = false;
    late bool oloading,rloading,ploading,mloading,bloading;


  final _account = Get.put(Account());
  @override
  void initState() {
    super.initState();


    _fnuser = FocusNode();
    _fnpass = FocusNode();
    _fncpass = FocusNode();
    _fnfname = FocusNode();
    _fnmname = FocusNode();
    _fnlname = FocusNode();
    _fnbdate = FocusNode();
    _fnphone = FocusNode();
    _fnsex = FocusNode();
    _fnpurok = FocusNode();
    _fnaddress = FocusNode();
    _fnbarangay = FocusNode();
    _fnmunicity = FocusNode();
    _fnprovince = FocusNode();
    _fnregion = FocusNode();
    _fnunit = FocusNode();
    _fnutype = FocusNode();
    _fnmarital = FocusNode();
    _fnorganization = FocusNode();
    _vpass = true;
    _vcpass = true;
    

    _euser = null;
    _epass = null;
    _ecpass = null;
    _efname = null;
    _emname = null;
    _elname = null;
    _ebdate = null;
    _ephone = null;
    _esex = null;
    _epurok = null;
    _eaddress = null;
    _ebarangay = null;
    _emunicity = null;
    _eprovince = null;
    _eregion = null;
    _eunit = null;
    _eutype = null;
    _emarital = null;
    _eorganization = null;
    _notediting = true;
    _changepassword = false;

    _teuser = TextEditingController();
    _tepass = TextEditingController();
    _tecpass = TextEditingController();
    _tefname = TextEditingController();
    _temname = TextEditingController();
    _telname = TextEditingController();
    _tebdate = TextEditingController();
    _tephone = TextEditingController();
    _tesex = TextEditingController();
    _tepurok = TextEditingController();
    _teaddress = TextEditingController();
    _tebarangay = TextEditingController();
    _temunicity = TextEditingController();
    _teprovince = TextEditingController();
    _teregion = TextEditingController();
    _teunit = TextEditingController();
    _teutype = TextEditingController();
    _temarital = TextEditingController();
    _teorganization = TextEditingController();

    _teuser.text = _account.user['user_name'];
    _tefname.text = _account.user['first_name'];
    _temname.text = _account.user['middle_name'];
    if(_temname.text==""){
      _temname.text=" ";
    }
    _telname.text = _account.user['last_name'];
    _tebdate.text = _account.user['birthdate'];
    _tephone.text = _account.user['contact_number'];
    _tesex.text = _account.user['sex'];
    _teaddress.text = _account.user['address'];
    
    _teunit.text = _account.user['unit'];
    _teutype.text = _account.user['user_type'];
    _temarital.text = _account.user['marital_status'];

    
    oloading = true;
    rloading = true;
    ploading = true;
    mloading = true;
    bloading = true;

  
    getOrganization();       
    getLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getOrganization() async{
    await _account.getOrganization().then((res){
      if(_account.organization.isNotEmpty){
        _teorganization.text = _account.user['organization_id'];
      }
      oloading = true;


    });
  }

  Future<void> getLocation() async{
    await _account.getRegion().then((res){
        _teregion.text = _account.user['region_id'];
        rloading = false;

    });
    await  _account.getProvince(_account.user['region_id']).then((res){
        _teprovince.text =  _account.user['province_id'];
        ploading = false;

    });
    await _account.getMunicity( _account.user['province_id']).then((res){
       _temunicity.text = _account.user['municity_id'];
        mloading = false;

    });
    await _account.getBarangay( _account.user['municity_id']).then((res){
      _tebarangay.text = _account.user['barangay_id'];
        bloading = false;
        setState(() {
          
        });
    });


   
    

  }




  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
  
    return PopScope(
    canPop: false,
    child:Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(iconTheme: IconThemeData(color:Colors.white),title:Text("My Profile",style:Theme.of(context).primaryTextTheme.titleLarge),backgroundColor: primary,),
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
      body: _changepassword?
          Container(padding:const EdgeInsets.all(16),child:SingleChildScrollView(child:Column(children: [
            Text('Change Password',style:Theme.of(context).textTheme.titleLarge),
            const SizedBox(height:16),
              TextFormField(
                controller:_tepass,
                focusNode:_fnpass,
                obscureText: _vpass,
                
                style:Theme.of(context).textTheme.bodyLarge,

                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "New Password",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  errorText: _epass,
                  errorStyle: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(color:Colors.red),
                  suffixIcon: IconButton(onPressed: (){setState(() {
                        _vpass = !_vpass;
                      });},
                      icon: _vpass?const Icon(Icons.visibility_off,color:primary):const Icon(Icons.visibility,color:primary)),    
                ),
              ),
              const SizedBox(height:16),
              TextFormField(
                  controller:_tecpass,
                  focusNode:_fncpass,
                  obscureText: _vcpass,
                  
                  style:Theme.of(context).textTheme.bodyLarge,

                  onChanged: (val){},
                  decoration:  InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    errorText: _ecpass,
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(color:Colors.red),
                    suffixIcon: IconButton(onPressed: (){setState(() {
                          _vcpass = !_vcpass;
                        });},
                        icon: _vcpass?const Icon(Icons.visibility_off,color:primary):const Icon(Icons.visibility,color:primary)),    
                ),
              ),
              const SizedBox(height:24),
              Container(width: double.infinity,child:FilledButton.icon(onPressed: () async {

              bool check = true;
              if(_tepass.text==""){
                  _epass = "Please enter your password";
                  check = false;
                }
                else if(_tepass.text.length<8){
                  _epass = "Password must be 8 characters";
                  check = false;
                }
                else{
                  _epass = null;
                }
                if(_tecpass.text==""){
                  _ecpass = "Please re-enter your password";
                  check = false;
                }
                else if(_tecpass.text!=_tepass.text){
                  _ecpass = "Does not match with password";
                  check = false;
                }
                else{
                  _ecpass = null;
                }

              if(check){
                Map<String,dynamic> data = {
                  "account_id":_account.user['account_id'],
                  "user_pass":_tepass.text,
                
                };
                
                Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),title: "Processing",content:Text("Please wait for a while your request is being processed!",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),);
                await _account.change_password(data).then((res){
                Get.back();
                
                if(res=="success"){
                  Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){
                    _changepassword=false;
                    setState(() {
                      
                    });
                    Get.back();
                  },titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),title: "Successfully Updated",content:Text("",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"Proceed",buttonColor:primary,confirmTextColor: Colors.white);
                }
                else{
                  Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){Get.back();},titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.red,fontWeight: FontWeight.w600),title: "Change Password Failed",content:Text("an error encountered while processing your registration, please try again later. If problem persists please contact the administrator",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"Okay",buttonColor: primary,confirmTextColor: Colors.white);
                }
                });
              }

              setState(() {
                
              });
          }, icon: Icon(Icons.send_rounded), label: Text("Update"))),
          const SizedBox(height:8),
          if(_notediting)Container(width: double.infinity,child:FilledButton.icon(
            style:FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: (){
            _changepassword = true;
            setState(() {
              
            });
          }, icon: Icon(Icons.cancel), label: Text("Cancel"))),
          const SizedBox(height:16),


          ]))):
          oloading&rloading&ploading&mloading&bloading?Container(child:Center(child:Text("Loading profile, please wait ...."))):Container(padding:const EdgeInsets.all(16),child:SingleChildScrollView(child:Column(children: [
          const SizedBox(height:16),
          TextFormField(
                controller:_teuser,
                focusNode:_fnuser,
                style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                readOnly: _notediting,
                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "Username",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  errorText: _euser,
                  errorStyle: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(color:Colors.red),
                ),
              ),
              const SizedBox(height:16),
              DropdownButtonFormField(
                  value: _teutype.text,
                  style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Are you a member of BCBP?",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    errorText: _eutype,
                    
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(color:Colors.red),
                    
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down,color:primary),
                  items: [{'val':"guest",'text':'I am a guest'},{'val':"member",'text':'I am a member'}].map((items){
                    return DropdownMenuItem(value:items['val'],child:Text(items['text']!));
                  }).toList(),
                  onChanged: _notediting?null:(String? value) {
                      _teutype.text=value!; 
                      setState(() {});
                    },
                ),
              const SizedBox(height:16),
              if(_teutype.text=="member")DropdownButtonFormField(
                  value: _teorganization.text,
                  style:Theme.of(context).textTheme.bodyLarge,
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Organization",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    errorText: _eorganization,
                    
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(color:Colors.red),
                    
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down,color:primary),
                  items: _account.organization.map((items){
                    return DropdownMenuItem(value:items['organization_id'],child:Text(items['organization_name']!));
                  }).toList(),
                  onChanged: _notediting?null:(value) {
                      _teorganization.text=value.toString(); 
                      setState(() {});
                    },
                ),
              if(_teutype.text=="member")const SizedBox(height:16),

              if(_teutype.text=="member")TextFormField(
                controller:_teunit,
                focusNode:_fnunit,
                readOnly: _notediting,
                style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "Unit #",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  errorText: _eunit,
                  errorStyle: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(color:Colors.red),
                ),
              ),
              const SizedBox(height:16),
              TextFormField(
                controller:_tefname,
                focusNode:_fnfname,
                style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                readOnly: _notediting,
                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "First Name",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                ),
                errorText: _efname,
                  errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                  
                ),
              ),
              const SizedBox(height:16),
              TextFormField(
                controller:_temname,
                focusNode:_fnmname,
                style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                readOnly: _notediting,
                enabled: !_notediting,
                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "Middle Name (Optional)",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  
                  
                ),
              ),
              const SizedBox(height:16),
              TextFormField(
                controller:_telname,
                focusNode:_fnlname,
                style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                readOnly: _notediting,
                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "Last Name",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                ),
                errorText: _elname,
                  errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                  
                ),
              ),
              const SizedBox(height:16),
              TextFormField(
                controller:_tebdate,
                focusNode:_fnbdate,
                style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),

                readOnly: _notediting,
                onTap: _notediting?null:()=>{
                  showDatePicker(
                    context:context,
                    firstDate: DateTime(1900,1),
                    lastDate: DateTime.now().subtract(const Duration(days:6574)),
                    initialDate: _tebdate.text==""?DateTime.now().subtract(const Duration(days:6574)):DateTime.parse(_tebdate.text),
                    helpText: "Select your birthdate",
                  
                  ).then((val){
                    if(val!=null){
                      _tebdate.value = TextEditingValue(text:DateFormat('yyyy-MM-dd').format(val).toString()); 
                      _ebdate = null;
                    }
                  })
                  // _bdatepicker()
                },
                
                decoration:  InputDecoration(
                  labelText: "Birthdate",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                ),
                errorText: _ebdate,
                errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                ),
              ),
              const SizedBox(height:16),
              
                DropdownButtonFormField(
                  value: _tesex.text,
                  style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Sex",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    errorText: _esex,
                    
                    errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                    
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down,color:primary),
                  items: ["male","female"].map((String items){
                    return DropdownMenuItem(value:items,child:Text(items));
                  }).toList(),
                  onChanged: _notediting?null:(String? value) {
                      _tesex.text=value!; 
                      setState(() {});
                    },
                ),
                const SizedBox(height:16),
              
                DropdownButtonFormField(
                  value: _temarital.text,
                  style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Marital Status",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    errorText: _emarital,
                    
                    errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                    
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down,color:primary),
                  items: ["single","married","widow"].map((String items){
                    return DropdownMenuItem(value:items,child:Text(items));
                  }).toList(),
                  onChanged: _notediting?null:(String? value) {
                      _temarital.text=value!; 
                      setState(() {});
                    },
                ),
              const SizedBox(height:16),
              TextFormField(
                controller:_tephone,
                focusNode:_fnphone,
                style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                readOnly: _notediting,
                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "Contact Number",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  errorText: _ephone,
                  errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                  
                ),
              ),
          const SizedBox(height:16),
              DropdownButtonFormField(
                  value: _teregion.text,
                  style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Region",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    errorText: _eregion,
                    
                    errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                    
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down,color:primary),
                  items: _account.region.map((items){
                    return DropdownMenuItem(value:items['region_id'].toString(),child:Text(items['region_name']));
                  }).toList(),
                  onChanged: _notediting?null:(String? value) async {
                      _teregion.text=value!; 
                      await _account.getProvince(value).then((res)async {
                        await _account.getMunicity(_account.province[0]['province_id']).then((res)async {
                          await _account.getBarangay(_account.municity[0]['municity_id']).then((res){
                            _teprovince.text = _account.province[0]['province_id'];
                            _temunicity.text = _account.municity[0]['municity_id'];
                            _tebarangay.text = _account.barangay[0]['barangay_id'];
                            setState(() {
                              
                            });
                          });
                          
                        });
                      });
                      setState(() {});
                    },
                ),
              const SizedBox(height:16),
              DropdownButtonFormField(
                  value: _teprovince.text,
                  style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Province",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    errorText: _eregion,
                    
                    errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                    
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down,color:primary),
                  items: _account.province.map((items){
                    return DropdownMenuItem(value:items['province_id'].toString(),child:Text(items['province_name']));
                  }).toList(),
                  onChanged: _notediting?null:(String? value) async {
                      _teprovince.text=value!; 
                      await _account.getMunicity(_account.province[0]['province_id']).then((res)async {
                          await _account.getBarangay(_account.municity[0]['municity_id']).then((res){
                            _temunicity.text = _account.municity[0]['municity_id'];
                            _tebarangay.text = _account.barangay[0]['barangay_id'];
                            setState(() {
                              
                            });
                          });
                          
                        });
                      setState(() {});
                    },
                ),
              const SizedBox(height:16),
              DropdownButtonFormField(
                  value: _temunicity.text,
                  style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Municipality/City",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    errorText: _emunicity,
                    
                    errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                    
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down,color:primary),
                  items: _account.municity.map((items){
                    return DropdownMenuItem(value:items['municity_id'].toString(),child:Text(items['municity_name']));
                  }).toList(),
                  onChanged: _notediting?null:(String? value) async {
                      _temunicity.text=value!; 
                     
                        await _account.getBarangay(_account.municity[0]['municity_id']).then((res){
                         
                          _tebarangay.text = _account.barangay[0]['barangay_id'];
                          setState(() {
                            
                          });
                          
                        });
                      setState(() {});
                    },
                ),
              const SizedBox(height:16),
              DropdownButtonFormField(
                  value: _tebarangay.text,
                  style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Barangay",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    errorText: _eregion,
                    
                    errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                    
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down,color:primary),
                  items: _account.barangay.map((items){
                    return DropdownMenuItem(value:items['barangay_id'].toString(),child:Text(items['barangay_name']));
                  }).toList(),
                  onChanged: _notediting?null:(String? value) async {
                      _tebarangay.text=value!; 
                     
                      setState(() {});
                    },
                ),
                const SizedBox(height:16),
                TextFormField(
                controller:_teaddress,
                focusNode:_fnaddress,
                readOnly: _notediting,
                style:Theme.of(context).textTheme.bodyLarge?.copyWith(color:_notediting?Colors.grey:Colors.black),

                onChanged: _notediting?null:(val){},
                decoration:  InputDecoration(
                  labelText: "House #/Lot #/Block/Street/Zone",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  errorText: _eaddress,
                  errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.red),
                ),
              ),
          const SizedBox(height:24),
          _notediting?Container(width: double.infinity,child:FilledButton.icon(onPressed: (){
              _notediting = false;
              setState(() {
                
              });
          }, icon: Icon(Icons.edit), label: Text("Edit Profile"))):
          Container(width: double.infinity,child:FilledButton.icon(onPressed: () async {

              bool check = true;
              if(_teuser.text==""){
                  _euser = "Please enter your username";
                  check = false;
                }
              else{
                _euser = null;
              }
              
              if(_teutype.text=="member"&&_teunit.text==""){
                _eunit = "Please enter your unit #";
                check = false;
              }
              else{
                _eunit = null;
              }
              
              if(_tefname.text==""){
                _efname = "Please enter your first name";
                check = false;
              }
              else{
                _efname = null;
              }
              if(_telname.text==""){
                _elname = "Please enter your last name";
                check = false;
              }
              else{
                _elname = null;
              }
              if(_tebdate.text==""){
                _ebdate = "Please enter your birthdate";
                check = false;
              }
              else{
                _ebdate = null;
              }
              if(_tephone.text==""){
                _ephone = "Please enter your phone number";
                check = false;
              }
              else if(_tephone.text.length<11){
                _ephone = "Incorrect phone number, please enter your 11 digit phone number";
                check = false;
              }
              else{
                _ephone = null;
              }
              if(_teaddress.text==""){
                  _eaddress = "Please enter your additional address information";
                  check = false;
              }
              else{
                _eaddress = null;
              }

              if(check){
                Map<String,dynamic> data = {
                  "account_id":_account.user['account_id'],
                  "user_name":_teuser.text,
                  "user_type":_teutype.text,
                  "first_name":_tefname.text,
                  "middle_name":_temname.text,
                  "last_name":_telname.text,
                  "birthdate":_tebdate.text,
                  "sex":_tesex.text,
                  "marital_status":_temarital.text,
                  "contact_number":_tephone.text,  
                  "address":_teaddress.text,
                  "barangay_id":_tebarangay.text
                };
                if(_teutype.text=="member"){
                  data['organization_id'] = _teorganization.text;
                  data['unit'] = _teunit.text;
                }
                Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),title: "Processing",content:Text("Please wait for a while your request is being processed!",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),);
                await _account.update_profile(data).then((res){
                Get.back();
                if(res=="exists"){
                  Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){
                    _euser = "Username already taken";
                    Get.back();
                    setState((){});
                  },titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.red,fontWeight: FontWeight.w600),title: "Username already taken!",content:Text("Please change your username",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"I Understand",buttonColor:primary,confirmTextColor: Colors.white);
                }
                else if(res=="success"){
                  Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){
                    _notediting=true;
                  
                    setState(() {
                      
                    });
                    Get.back();
                  },titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),title: "Successfully Updated",content:Text("",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"Proceed",buttonColor:primary,confirmTextColor: Colors.white);
                }
                else{
                  Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){Get.back();},titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.red,fontWeight: FontWeight.w600),title: "Update Profile Failed",content:Text("an error encountered while processing your registration, please try again later. If problem persists please contact the administrator",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"Okay",buttonColor: primary,confirmTextColor: Colors.white);
                }
                });
              }

              setState(() {
                
              });
          }, icon: Icon(Icons.send_rounded), label: Text("Update"))),
          const SizedBox(height:8),
          if(_notediting)Container(width: double.infinity,child:FilledButton.icon(onPressed: (){
            _changepassword = true;
            setState(() {
              
            });
          }, icon: Icon(Icons.change_circle_rounded), label: Text("Change Password"))),
          const SizedBox(height:16),
      ],)
      )
    )));
  }

}