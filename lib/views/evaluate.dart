import 'package:breakfast_locator/controller/account.dart';
import 'package:breakfast_locator/controller/breakfast.dart';
import 'package:breakfast_locator/custom/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});


  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  late TextEditingController _terating,_tefeedback;

  late dynamic _efeedback;
  final _breakfast = Get.put(Breakfast());
  final _account = Get.put(Account());
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    
    _terating = TextEditingController();
    _tefeedback = TextEditingController();
    _terating.text = "1";
    _efeedback = null;
   
  }

 
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
    canPop: false,
    child:Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primary,
        leading:  IconButton(icon:Icon(Icons.arrow_back_rounded),onPressed: (){Get.back();},),
        title: Text("Evaluate Event",style:Theme.of(context).primaryTextTheme.titleLarge)),
      body:
      
      SingleChildScrollView(child:Container(
        padding: const EdgeInsets.only(left:16,right:16,top:40,bottom:10),
        
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
              

              Text('Please fill up the evaluation form',style:Theme.of(context).textTheme.titleMedium),

              const SizedBox(height:16),
              DropdownButtonFormField(
                  value: _terating.text,
                  style:Theme.of(context).textTheme.bodyLarge,
                  
                  // dropdownColor: ,
                  
                  decoration:  InputDecoration(
                    labelText: "Rate the event (1-10)",
                    labelStyle: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(color:primary),
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
                    
                    errorStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    
                  ),
                  
                  icon: const Icon(Icons.keyboard_arrow_down,color:primary),
                  items: [1,2,3,4,5,6,7,8,9,10].map((items){
                    return DropdownMenuItem(value:items.toString(),child:Text(items.toString()));
                  }).toList(),
                  onChanged: (value) {
                      _terating.text = value!;
                      setState(() {});
                    },
                ),
              const SizedBox(height:16),

              TextFormField(
                controller:_tefeedback,
                style:Theme.of(context).textTheme.bodyLarge,
                maxLines: 5,
                onChanged: (val){},
                decoration:  InputDecoration(
                  labelText: "Feedback/Comment",
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
                  errorText: _efeedback,
                  errorStyle: Theme.of(context).textTheme.bodyMedium
                ),
              ),
              
              const SizedBox(height:24),
              Container(width:double.infinity,child:FilledButton(style:FilledButton.styleFrom(backgroundColor: primary),child:Text("Submit",style:Theme.of(context).primaryTextTheme.titleMedium),onPressed: (){
                  Map<String,dynamic> data = {
                    'account_id':_account.user['account_id'],
                    'event_id':_breakfast.selected_event['event_id'],
                    'evaluation_rating':_terating.text,
                    'evaluation_feedback':_tefeedback.text
                  };
                   Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),title: "Processing",content:Text("Please wait for a while your evaluation is being processed!",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),);
                  _breakfast.submitEvaluation(data).then((res){
                    Get.back();
                    if(res==true){
                      Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){
                        Get.toNamed('/calendar');
                      },titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:primary,fontWeight: FontWeight.w600),title: "Successfully Evaluated",content:Text(""),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"Proceed",buttonColor:primary,confirmTextColor: Colors.white);
                    }
                    else{
                      Get.defaultDialog(barrierDismissible: false,onWillPop: () async{return false;},onConfirm: (){Get.back();},titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.red,fontWeight: FontWeight.w600),title: "Evaluation Failed",content:Text("an error encountered while processing your evaluation, please try again later. If problem persists please contact the administrator",textAlign: TextAlign.center,),contentPadding: const EdgeInsets.all(16),titlePadding: const EdgeInsets.only(top:16),textConfirm:"Okay",buttonColor: primary,confirmTextColor: Colors.white);
                    }
                  });

              },))
            ])),

    )));
  }
}
