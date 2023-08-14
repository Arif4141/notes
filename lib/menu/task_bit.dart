// import 'package:date_field/date_field.dart';
// import 'package:flutter/material.dart';
//
// class TaskBit extends StatelessWidget {
//   TextEditingController product = new TextEditingController();
//   List<DateTime> selectedDate = [];
//
//   TaskBit({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListBody(
//       children: <Widget>[
//         Row(
//           children: <Widget>[
//             Container(
//               width: 200,
//               padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
//               child: TextFormField(
//                 controller: product,
//                 decoration: const InputDecoration(
//                     labelText: 'Product Name', border: OutlineInputBorder()),
//               ),
//             ),
//             DateTimeField(
//               decoration: const InputDecoration(
//                   hintText: 'Please select your birthday date and time'),
//               selectedDate: selectedDate,
//               onDateSelected: (DateTime value) {
//                 setState(() {
//                   selectedDate = value;
//                 });
//               },
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
