// import 'package:flutter/material.dart';
//
// import '../lib_exp.dart';
//
// class DeepLinkHelper {
//   static String parseBaseUtiToBaseUrls(Uri? uri) {
//     if (AppData.appMode == AppMode.dev && kDebugMode) {
//       uri = Uri.parse(
//         "https://qrorder.dev.bersian.ai/?m=demo4&o=so1&tno=2",
//         // "https://qrorder.bersian.ai/?m=demo2&o=so1&tbl=1",
//       );
//       //https://qrorder.dev.bersian.ai/?m=demo4&o=so2&t=so2t1&tbl=10
//     }
//
//     printDebugLog(tag: 'DeepLinkHelper', message: uri.toString());
//
//     Map<String, String>? params = uri?.queryParameters;
//     return BaseDeepLink(
//       merchant: params?['m'],
//       outlet: params?['o'],
//       terminal: params?["t"],
//       tableNo: params?["tno"] ?? params?["tbl"],
//     );
//   }
//
//   Future<void> appLinkHandler(Uri? uri) async {
//     if (uri == null) return;
//     /// EXAMPLE URL:
//     /*
//     https://bincang-visual.cloud/room/room-id
//     */
//     final segments = uri.pathSegments;
//     final queryParams = uri.queryParameters;
//
//
//
//
//     // navigate specific path
//     if (segments.isNotEmpty) {
//       // update email
//       if (segments.first == "room" && segments.length >= 2) {
//         String? token = segments[1];
//         Navigator.pushNamed(
//           context,
//           '/preview',
//           arguments: {'roomId': roomId, 'isNewMeeting': false},
//         );
//       }
//       // update email
//       if (segments.first == "blog" && segments.length >= 2) {
//         String? slug = segments[1];
//         if (context != null) {
//           context.goExtra(
//             ArticleNav.articleDetail.fullpath,
//             queryParams: {"slug": slug},
//           );
//           return;
//         }
//       }
//
//     }
//
//   }
// }
