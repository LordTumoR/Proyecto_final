import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/food/food_tabbar_searchfood.dart';

class FoodTab extends StatefulWidget {
  @override
  _FoodTabState createState() => _FoodTabState();
}

class _FoodTabState extends State<FoodTab> {
  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(LoadRandomFoods());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.food_list),
          bottom: TabBar(
            indicatorColor: const Color.fromARGB(255, 181, 208, 7),
            indicatorWeight: 4.0,
            labelColor: const Color.fromARGB(255, 220, 220, 8),
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: const Icon(Icons.fastfood, size: 30),
                text: AppLocalizations.of(context)!.my_foods,
              ),
              Tab(
                icon: const Icon(Icons.search, size: 30),
                text: AppLocalizations.of(context)!.search_foods,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //MyFoodsTab(),
            SearchFoodsTab(),
          ],
        ),
      ),
    );
  }
}
