// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:ottu/Networkutils/networkUtils.dart';
// import 'package:ottu/generated/l10n.dart';
// import 'package:ottu/models/fetchpaymenttransaction.dart' as c;
// import 'package:ottu/widget/dialogs.dart';

// ///delete card dialog to delete saved card.
// class DeleteCardDialog {
//   static showDialogs(BuildContext context, String deleteurl,
//       List<c.Card> deleteCard, int i) async {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) => StatefulBuilder(
//         builder: ((context, setState) => AlertDialog(
//               title: Text(S().DeleteCard),
//               content: Text(S().Areyousureyouwanttodeletethiscard),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context, 'Cancel');
//                   },
//                   child: Text(S().Ok),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     NetworkUtils().deleteCard(
//                       deleteurl,
//                       () {
//                         setState(() {
//                           deleteCard.removeAt(i);
//                           Navigator.of(context).pop();
//                           Dialogs().showProgressDialog(context);
//                           print('object');
//                           Future.delayed(const Duration(seconds: 1), () {
//                             Navigator.of(context).pop();
//                           });
//                         });
//                       },
//                       context,
//                     );
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }
