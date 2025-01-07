import 'dart:async';
import 'dart:io';

import 'package:breakfast_locator/plugin.dart';
import 'package:breakfast_locator/views/calendar.dart';
import 'package:breakfast_locator/views/evaluate.dart';
import 'package:breakfast_locator/views/login.dart';
import 'package:breakfast_locator/views/map.dart';
import 'package:breakfast_locator/views/profile.dart';
import 'package:breakfast_locator/views/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:breakfast_locator/custom/colors.dart';
import 'package:breakfast_locator/views/home.dart';

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';


class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    this.data,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final Map<String, dynamic>? data;
}

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}




Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // await _configureLocalTimeZone();

  const AndroidInitializationSettings initializationSettingsAndroid =
       AndroidInitializationSettings('@mipmap/ic_launcher');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      "asdas",
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      "asdasd",
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );


  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: selectNotificationStream.add,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // String initialRoute = HomePage.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
    // initialRoute = SecondPage.routeName;
  }

  

  runApp(MyApp(notificationAppLaunchDetails));
}

class MyApp extends StatelessWidget {
  const MyApp(this.notificationAppLaunchDetails, {
    Key? key,
  }) : super(key: key);
  
  final notificationAppLaunchDetails;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        alignment: Alignment.center,
                                        padding:const EdgeInsets.only(left:20,right:20,top:10,bottom:10),
                                        backgroundColor: primary,                            
          )
          
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        useMaterial3: true,
      ),
      home: const MainSplash(),
      getPages: [
        GetPage(
          name:'/home',
          page:()=> HomePage(notificationAppLaunchDetails),
          // transitionDuration: Duration(milliseconds: 1000),
          transition: Transition.rightToLeftWithFade
        ),
        GetPage(
          name:'/map',
          page:()=> const MapPage(),
          // transitionDuration: Duration(milliseconds: 1000),
          transition: Transition.rightToLeftWithFade
        ),
        GetPage(
          name:'/login',
          page:()=> const LoginPage(),
          // transitionDuration: Duration(milliseconds: 1000),
          transition: Transition.noTransition,
        ),
        GetPage(
          name:'/calendar',
          page:()=> const CalendarPage(),
          // transitionDuration: Duration(milliseconds: 1000),
          transition: Transition.rightToLeftWithFade
        ),
        GetPage(
          name:'/register',
          page:()=> const RegisterPage(),
          // transitionDuration: Duration(milliseconds: 1000),
          transition: Transition.noTransition,
        ),
        GetPage(
          name:'/evaluation',
          page:()=> const EvaluationPage(),
          // transitionDuration: Duration(milliseconds: 1000),
          transition: Transition.noTransition,
        ),
        GetPage(
          name:'/profile',
          page:()=> const ProfilePage(),
          // transitionDuration: Duration(milliseconds: 1000),
          transition: Transition.noTransition,
        ),
      ]
    );
  }
}




class MainSplash extends StatelessWidget{
  const MainSplash({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child:Scaffold(
        backgroundColor: primary,
        body: Container(padding:EdgeInsets.only(left:24,right:24),width:double.infinity,child:
          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
            
            Image.asset('assets/logo.png',width: 150,),
            const SizedBox(height:24),
            
            Text("BCBP",style:Theme.of(context).primaryTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800),textAlign: TextAlign.center,),
            const SizedBox(height:8),
            Text("EVENT MANAGEMENT",style:Theme.of(context).primaryTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
            const SizedBox(height:24),

            Container(width: double.infinity,child:FilledButton(style: FilledButton.styleFrom(backgroundColor:Colors.white),onPressed: (){
              Get.toNamed('/home');
            }, child: Text("SEARCH EVENT",style:Theme.of(context).textTheme.titleMedium))),
            const SizedBox(height:8),
            Container(width: double.infinity,child:FilledButton(style: FilledButton.styleFrom(backgroundColor:Colors.white),onPressed: (){
              Get.toNamed('/login');
            }, child: Text("LOGIN",style:Theme.of(context).textTheme.titleMedium))),
            const SizedBox(height:16),
          ],)
        
        )));
  
  }
}

