// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
// import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_state.dart';
// import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class MyFoodsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FoodBloc, FoodState>(
//       builder: (context, state) {
//         if (state is FoodLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is FoodError) {
//           return Center(
//             child: Text(
//               '${AppLocalizations.of(context)!.error}',
//               style: const TextStyle(color: Colors.red, fontSize: 16),
//             ),
//           );
//         } else if (state is FoodLoaded) {
//           final foodList = state.foodList;

//           return ListView.builder(
//             itemCount: foodList.length,
//             itemBuilder: (context, index) {
//               final foodItem = foodList[index];
//               return Container(
//                 margin: const EdgeInsets.symmetric(vertical: 8.0),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.withOpacity(0.8),
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 child: ListTile(
//                   title: Text(
//                     foodItem.name ?? '',
//                     style: const TextStyle(
//                       color: Colors.brown,
//                       fontSize: 20,
//                     ),
//                   ),
//                   subtitle: Text(
//                     '${AppLocalizations.of(context)!.calories}: ${foodItem.category}',
//                     style: const TextStyle(
//                       color: Colors.black54,
//                       fontSize: 16,
//                     ),
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () {
//                           // showDialog(
//                           //   context: context,
//                           //   builder: (BuildContext context) {
//                           //     return EditFoodDialog(
//                           //       food: foodItem,
//                           //       onEdit: (updatedFood) {
//                           //       //   context
//                           //       //       .read<FoodBloc>()
//                           //       //       .add(UpdateFoodEvent(updatedFood));
//                           //       // },
//                           //     );
//                           //   },
//                           // );
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: Text(AppLocalizations.of(context)!
//                                     .confirm_deletion),
//                                 content: Text(AppLocalizations.of(context)!
//                                     .confirm_food_deletion),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: Text(
//                                         AppLocalizations.of(context)!.cancel),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       // context.read<FoodBloc>().add(
//                                       //     DeleteFoodEvent(foodItem.id ?? 0));
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: Text(
//                                         AppLocalizations.of(context)!.delete),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }

//         return Center(
//             child: Text(AppLocalizations.of(context)!.no_food_available));
//       },
//     );
//   }
// }
