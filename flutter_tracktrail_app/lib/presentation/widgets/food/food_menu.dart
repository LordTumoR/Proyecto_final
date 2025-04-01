import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/food/create_food_dialog.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/food/edit_food_dialog.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/food/filter_food_dialog.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/food/food_tabbar_myfood.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/food/food_tabbar_searchfood.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/food/scanner_tab.dart';

class FoodTab extends StatefulWidget {
  final int dietId;
  final bool isUserDiet;

  const FoodTab({required this.dietId, required this.isUserDiet, Key? key})
      : super(key: key);

  @override
  _FoodTabState createState() => _FoodTabState();
}

class _FoodTabState extends State<FoodTab> {
  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(
          LoadDatabaseFoods(
            dietId: widget.dietId,
            name: null,
            minCalories: null,
            maxCalories: null,
            category: null,
            brand: null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.food_list,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 252, 224, 179),
            bottom: TabBar(
              indicatorColor: const Color(0xFFFFD54F),
              indicatorWeight: 4.0,
              labelColor: const Color(0xFFF9A825),
              unselectedLabelColor: Colors.grey[600],
              tabs: [
                Tab(
                  icon: const Icon(Icons.fastfood,
                      size: 30, color: Color.fromARGB(255, 247, 152, 0)),
                  text: AppLocalizations.of(context)!.my_foods,
                ),
                if (widget.isUserDiet)
                  Tab(
                    icon: const Icon(Icons.search,
                        size: 30, color: Color.fromARGB(255, 255, 157, 0)),
                    text: AppLocalizations.of(context)!.search_foods,
                  ),
                if (widget.isUserDiet)
                  const Tab(
                    icon: Icon(Icons.scanner,
                        size: 30, color: Color.fromARGB(255, 255, 157, 0)),
                    child: Text('Scannear'),
                  ),
              ],
            )),
        body: Container(
          color: const Color.fromARGB(255, 245, 232, 212),
          child: TabBarView(
            children: [
              DatabaseFoodsTab(
                  dietId: widget.dietId, isUserDiet: widget.isUserDiet),
              SearchFoodsTab(dietId: widget.dietId),
              ScannerTab(dietId: widget.dietId),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 252, 224, 179),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list,
                    color: Color.fromARGB(255, 247, 152, 0)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        FilterFoodDialog(dietId: widget.dietId),
                  );
                },
              ),
              if (widget.isUserDiet)
                IconButton(
                  icon: const Icon(Icons.add,
                      color: Color.fromARGB(255, 247, 152, 0)),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          CreateFoodDialog(dietId: widget.dietId),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
