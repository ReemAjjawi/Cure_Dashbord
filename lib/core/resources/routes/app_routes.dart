// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// class AppRoutes {
//   static Route onGenerateRoutes(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         var box = Hive.box('projectBox');
//         String? token = box.get('token');
// // {latitude: 51.5315, longtitude: 4.4598}
//         if (token != null) {
//           return _materialRoute((SignUpScreen()));
//         } else {
//           return _materialRoute(HomePage());
//         }

//       case '/BicycleDetailsScreen':
//         final args = settings.arguments as DetailArguments;
//         return _materialRoute(BicycleDetailsScreen(
//             bicycle: args.bicycle, hubId: args.hubId, hubIdto: args.hubIdto));

//       case '/SuccessScreen':
//         return _materialRoute(
//             SuccessScreen(model: settings.arguments as BalanceModel));
//    case '/AddMoneyScreen':
//         return _materialRoute(
//             AddMoneyScreen(code: settings.arguments as String));

//       default:
//         return _materialRoute(WelcomeScreen());
//     }
//   }

//   static Route<dynamic> _materialRoute(Widget view) {
//     return MaterialPageRoute(builder: (_) => view);
//   }
// }
