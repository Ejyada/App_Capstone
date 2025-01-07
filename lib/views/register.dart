import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:breakfast_locator/controller/account.dart';
import 'package:breakfast_locator/custom/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  
  final _account = Get.put(Account());

  int currentStep = 0;

  late TextEditingController _teuser,
                            _tepass,
                            _tecpass,
                            _tefname,
                            _temname,
                            _telname,
                            _tebdate,
                            _tephone,
                            _tesex,
                            _teaddress,
                            _tebarangay,
                            _temunicity,
                            _teprovince,
                            _teregion,
                            _teunit,
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
                _fnaddress,
                _fnbarangay,
                _fnmunicity,
                _fnprovince,
                _fnregion,
                _fnunit,
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
              _emarital,
              _eorganization;


  @override
  void initState() {
    super.initState();
    _teuser = TextEditingController();
    _tepass = TextEditingController();
    _tecpass = TextEditingController();
    _tefname = TextEditingController();
    _temname = TextEditingController();
    _telname = TextEditingController();
    _tebdate = TextEditingController();
    _tephone = TextEditingController();
    _tesex = TextEditingController();
    _teaddress = TextEditingController();
    _tebarangay = TextEditingController();
    _temunicity = TextEditingController();
    _teprovince = TextEditingController();
    _teregion = TextEditingController();
    _teunit = TextEditingController();
    _temarital = TextEditingController();
    _teorganization = TextEditingController();
    _fnuser = FocusNode();
    _fnpass = FocusNode();
    _fncpass = FocusNode();
    _fnfname = FocusNode();
    _fnmname = FocusNode();
    _fnlname = FocusNode();
    _fnbdate = FocusNode();
    _fnphone = FocusNode();
    _fnsex = FocusNode();
    _fnaddress = FocusNode();
    _fnbarangay = FocusNode();
    _fnmunicity = FocusNode();
    _fnprovince = FocusNode();
    _fnregion = FocusNode();
    _fnunit = FocusNode();
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
    _eaddress = null;
    _ebarangay = null;
    _emunicity = null;
    _eprovince = null;
    _eregion = null;
    _eunit = null;
    _emarital = null;
    _eorganization = null;
    _tesex.text="male";
    _temarital.text = "single";
    currentStep=0;

    getLocation();
    getOrganization();
    
  }

  Future<void> getOrganization() async{
    await _account.getOrganization().then((res){
      if(_account.organization.isNotEmpty){
        _teorganization.text = _account.organization[0]['organization_id'];
      }
      setState(() {
      
      });
    });
  }

  Future<void> getLocation() async {
    await _account.getRegion().then((res) async {
      await _account.getProvince(_account.region[0]['region_id']).then((res)async {
        await _account.getMunicity(_account.province[0]['province_id']).then((res)async {
          await _account.getBarangay(_account.municity[0]['municity_id']).then((res) async {
            _teregion.text = _account.region[0]['region_id'];
            _teprovince.text = _account.province[0]['province_id'];
            _temunicity.text = _account.municity[0]['municity_id'];
            _tebarangay.text = _account.barangay[0]['barangay_id'];
            if(mounted){
            setState(() {
              
            });
            }
          });
          
        });
      });
    }); 
  }




  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return PopScope(
    canPop:  false,
    child:Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: primary,
      appBar: AppBar(
        title: Text("Registration",style:Theme.of(context).primaryTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
        leading: BackButton(color:Colors.white,onPressed: (){
          // still not fixed
          if(currentStep==0){Get.back();}else{currentStep-=1; setState((){});}
          },),backgroundColor:primary),
      body:
      SingleChildScrollView(
      // physics: const NeverScrollableScrollPhysics(),
      child:     
      Container(
        height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 48,  
        padding: const EdgeInsets.only(top:24,),
        child: Form(
            key: formGlobalKey,
            child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
              Container(margin: const EdgeInsets.symmetric(vertical: 0, horizontal:24),child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: {0,1,2}.map((entry) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 52.0,
                    height: 8.0,
                    margin: const EdgeInsets.only(right:8),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.white)
                            .withOpacity(currentStep >= entry ? 1.0 : 0.1)),
                  ),
                );
              }).toList(),
            )),
            currentStep==0?
            Expanded(flex:1,child:Container(margin: const EdgeInsets.symmetric(vertical: 0, horizontal:24),child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
              const SizedBox(height:16),
              Text('Account Information',style:Theme.of(context).primaryTextTheme.titleLarge),
              const SizedBox(height:2),
              Text('Please complete the information below',style:Theme.of(context).primaryTextTheme.bodyMedium),
              const SizedBox(height:16),
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
                  errorText: _euser,
                  errorStyle: Theme.of(context).primaryTextTheme.bodyMedium
                ),
              ),
              const SizedBox(height:16),
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
                  suffixIcon: IconButton(onPressed: (){setState(() {
                        _vpass = !_vpass;
                      });},
                      icon: _vpass?const Icon(Icons.visibility_off,color:Colors.white):const Icon(Icons.visibility,color:Colors.white)),    
                ),
              ),
              const SizedBox(height:16),
              TextFormField(
                  controller:_tecpass,
                  focusNode:_fncpass,
                  obscureText: _vcpass,
                  
                  style:Theme.of(context).primaryTextTheme.bodyLarge,

                  onChanged: (val){},
                  decoration:  InputDecoration(
                    labelText: "Confirm Password",
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
                    errorText: _ecpass,
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    suffixIcon: IconButton(onPressed: (){setState(() {
                          _vcpass = !_vcpass;
                        });},
                        icon: _vcpass?const Icon(Icons.visibility_off,color:Colors.white):const Icon(Icons.visibility,color:Colors.white)),    
                ),
              ),
              
             
              const SizedBox(height:16),
              DropdownButtonFormField(
                  value: _teorganization.text,
                  style:Theme.of(context).primaryTextTheme.bodyLarge,
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Organization",
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
                    errorText: _eorganization,
                    
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    
                  ),
                  dropdownColor: primary,
                  icon: const Icon(Icons.keyboard_arrow_down,color:Colors.white),
                  items: _account.organization.map((items){
                    return DropdownMenuItem(value:items['organization_id'],child:Text(items['organization_name']!));
                  }).toList(),
                  onChanged: (value) {
                      _teorganization.text=value.toString(); 
                      setState(() {});
                    },
                ),
              const SizedBox(height:16),

              TextFormField(
                controller:_teunit,
                focusNode:_fnunit,
                style:Theme.of(context).primaryTextTheme.bodyLarge,
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "Unit #",
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
                  errorText: _eunit,
                  errorStyle: Theme.of(context).primaryTextTheme.bodyMedium
                ),
              ),

              const SizedBox(height:24),
              Align(alignment: Alignment.centerRight,child:ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: Colors.white),onPressed: (){
                bool check = true;
                if(_teuser.text==""){
                  _euser = "Please enter your username";
                  check = false;
                }
                else{
                  _euser = null;
                }
                print(_tepass.text.length);
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
                if(_teunit.text==""){
                  _eunit = "Please enter your unit #";
                  check = false;
                }
                else{
                  _eunit = null;
                }
                if(check){
                 currentStep = 1; 
                }
        
                setState(() {
                  
                });
              }, child: Text("Next",style: Theme.of(context).textTheme.titleMedium),))  
         
         
          

                
            ]))):
            currentStep==1?
            Expanded(flex:1,child:Container(margin: const EdgeInsets.symmetric(vertical: 0, horizontal:24),padding: const EdgeInsets.only(top:24),child:SingleChildScrollView(child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
              Text('Personal Information',style:Theme.of(context).primaryTextTheme.titleLarge),
              const SizedBox(height:2),
              Text('Please complete the information below',style:Theme.of(context).primaryTextTheme.bodyMedium),
              const SizedBox(height:16),
              TextFormField(
                controller:_tefname,
                focusNode:_fnfname,
                style:Theme.of(context).primaryTextTheme.bodyLarge,

                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "First Name",
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
                errorText: _efname,
                  errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                  
                ),
              ),
              const SizedBox(height:16),
              TextFormField(
                controller:_temname,
                focusNode:_fnmname,
                style:Theme.of(context).primaryTextTheme.bodyLarge,

                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "Middle Name (Optional)",
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
                  
                  
                ),
              ),
              const SizedBox(height:16),
              TextFormField(
                controller:_telname,
                focusNode:_fnlname,
                style:Theme.of(context).primaryTextTheme.bodyLarge,

                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "Last Name",
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
                errorText: _elname,
                  errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                  
                ),
              ),
              const SizedBox(height:16),
              TextFormField(
                controller:_tebdate,
                focusNode:_fnbdate,
                enabled: true,
                style:Theme.of(context).primaryTextTheme.bodyLarge,

                readOnly: true,
                onTap: ()=>{
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
                errorText: _ebdate,
                errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
              ),
              const SizedBox(height:16),
              
                DropdownButtonFormField(
                  value: _tesex.text,
                  style:Theme.of(context).primaryTextTheme.bodyLarge,
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Sex",
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
                    errorText: _esex,
                    
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    
                  ),
                  dropdownColor: primary,
                  icon: const Icon(Icons.keyboard_arrow_down,color:Colors.white),
                  items: ["male","female"].map((String items){
                    return DropdownMenuItem(value:items,child:Text(items));
                  }).toList(),
                  onChanged: (String? value) {
                      _tesex.text=value!; 
                      setState(() {});
                    },
                ),
                const SizedBox(height:16),
              
                DropdownButtonFormField(
                  value: _temarital.text,
                  style:Theme.of(context).primaryTextTheme.bodyLarge,
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Marital Status",
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
                    errorText: _emarital,
                    
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    
                  ),
                  dropdownColor: primary,
                  icon: const Icon(Icons.keyboard_arrow_down,color:Colors.white),
                  items: ["single","married","widow"].map((String items){
                    return DropdownMenuItem(value:items,child:Text(items));
                  }).toList(),
                  onChanged: (String? value) {
                      _temarital.text=value!; 
                      setState(() {});
                    },
                ),
              const SizedBox(height:16),
              TextFormField(
                controller:_tephone,
                focusNode:_fnphone,
                style:Theme.of(context).primaryTextTheme.bodyLarge,

                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "Contact Number",
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
                  errorText: _ephone,
                  errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                  
                ),
              ),
              const SizedBox(height:24),
              Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,children:[
                ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: Colors.grey[100]),onPressed: (){currentStep=0;setState(() {
                  
                });}, child: Text("Back",style: Theme.of(context).textTheme.titleMedium),),
                const SizedBox(width:8),
                ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: Colors.white),onPressed: (){
                bool check = true;
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
                
                
                
                if(check){
                currentStep = 2; 
                }
        
                setState(() {
                  
                });
              }, child: Text("Next",style: Theme.of(context).textTheme.titleMedium?.copyWith(color:primary)),)  
              ]),

          
            

                
            ])))):
            Expanded(flex:1,child:Container(margin: const EdgeInsets.symmetric(vertical: 0, horizontal:24),padding: const EdgeInsets.only(top:24),child:SingleChildScrollView(child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
              Text('Home Address Information',style:Theme.of(context).primaryTextTheme.titleLarge),
              const SizedBox(height:2),
              Text('Please complete the information below',style:Theme.of(context).primaryTextTheme.bodyMedium),
              const SizedBox(height:16),
              DropdownButtonFormField(
                  value: _teregion.text,
                  style:Theme.of(context).primaryTextTheme.bodyLarge,
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Region",
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
                    errorText: _eregion,
                    
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    
                  ),
                  dropdownColor: primary,
                  icon: const Icon(Icons.keyboard_arrow_down,color:Colors.white),
                  items: _account.region.map((items){
                    return DropdownMenuItem(value:items['region_id'],child:Text(items['region_name']));
                  }).toList(),
                  onChanged: (value) async {
                      _teregion.text=value.toString(); 
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
                  style:Theme.of(context).primaryTextTheme.bodyLarge,
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Province",
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
                    errorText: _eregion,
                    
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    
                  ),
                  dropdownColor: primary,
                  icon: const Icon(Icons.keyboard_arrow_down,color:Colors.white),
                  items: _account.province.map((items){
                    return DropdownMenuItem(value:items['province_id'],child:Text(items['province_name']));
                  }).toList(),
                  onChanged: (value) async {
                      _teprovince.text=value.toString(); 
                      await _account.getMunicity(value).then((res)async {
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
                  style:Theme.of(context).primaryTextTheme.bodyLarge,
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Municipality/City",
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
                    errorText: _eregion,
                    
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    
                  ),
                  dropdownColor: primary,
                  icon: const Icon(Icons.keyboard_arrow_down,color:Colors.white),
                  items: _account.municity.map((items){
                    return DropdownMenuItem(value:items['municity_id'],child:Text(items['municity_name']));
                  }).toList(),
                  onChanged: (value) async {
                      _temunicity.text=value.toString(); 
                     
                        await _account.getBarangay(value).then((res){
                          
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
                  style:Theme.of(context).primaryTextTheme.bodyLarge,
                  
                  // dropdownColor: ,
                  decoration:  InputDecoration(
                    labelText: "Barangay",
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
                    errorText: _eregion,
                    
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    
                  ),
                  dropdownColor: primary,
                  icon: const Icon(Icons.keyboard_arrow_down,color:Colors.white),
                  items: _account.barangay.map((items){
                    return DropdownMenuItem(value:items['barangay_id'],child:Text(items['barangay_name']));
                  }).toList(),
                  onChanged: (value) async {
                      _tebarangay.text=value.toString(); 
                     
                      setState(() {});
                    },
                ),
                const SizedBox(height:16),
                TextFormField(
                controller:_teaddress,
                focusNode:_fnaddress,
                style:Theme.of(context).primaryTextTheme.bodyLarge,

                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "House #/Lot #/Block/Street/Zone",
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
                  errorText: _eaddress,
                  errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
              ),
              const SizedBox(height:36),
              Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,children:[
                ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: Colors.grey[100]),onPressed: (){currentStep=1;setState(() {
                  
                });}, child: Text("Back",style: Theme.of(context).textTheme.titleMedium?.copyWith(color:primary)),),
                const SizedBox(width:8),
                ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: Colors.white),onPressed: () async {
                bool check = true;
                if(_teaddress.text==""){
                  _eaddress = "Please enter your additional address information";
                  check = false;
                }
                else{
                  _eaddress = null;
                }
                
                
                if(check){
                  Map<String,dynamic> data = {
                    "user_name":_teuser.text,
                    "user_pass":_tepass.text,
                    "user_type":"member",
                    'organization_id':_teorganization.text,
                    'unit':_teunit.text,
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

                  Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),title: "Processing",content:Text("Please wait for a while your registration is being processed!",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),);
                 await _account.register(data).then((res){
                  Get.back();
                  if(res=="exists"){
                    Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){
                      currentStep = 0;
                      _euser = "Username already taken";
                      Get.back();
                      setState((){});
                    },titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.red,fontWeight: FontWeight.w600),title: "Username already taken!",content:Text("Please change your username",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"I Understand",buttonColor:primary,confirmTextColor: Colors.white);
                  }
                  else if(res=="success"){
                    Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){
                      Get.toNamed('/login');
                    },titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),title: "Successfully Registered",content:Text("Please wait for the admin to approve your request",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"I Understand",buttonColor:primary,confirmTextColor: Colors.white);
                  }
                  else{
                    Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){Get.back();},titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.red,fontWeight: FontWeight.w600),title: "Registration Failed",content:Text("an error encountered while processing your registration, please try again later. If problem persists please contact the administrator",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"Okay",buttonColor: primary,confirmTextColor: Colors.white);
                  }
                 });
                }
        
                setState(() {
                  
                });
              }, child: Text("Submit",style: Theme.of(context).textTheme.titleMedium?.copyWith(color:primary)),)  
              ]),                
            ])))),
            
        ]))))));
  }
}

