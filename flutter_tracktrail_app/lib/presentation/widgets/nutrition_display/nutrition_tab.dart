import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/nutrition_display/nutririon_search.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/nutrition_display/nutrition_create.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/nutrition_display/nutrition_favorites.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/nutrition_display/nutrition_filter.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/nutrition_display/nutrition_listview.dart';

class NutritionMenu extends StatefulWidget {
  @override
  _NutritionMenuState createState() => _NutritionMenuState();
}

class _NutritionMenuState extends State<NutritionMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6DBE45),
                  Color(0xFFB0E57C),
                ],
              ),
            ),
          ),
          title: const Text(
            'Nutrición y Dietas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: Icon(Icons.restaurant, size: 30),
                text: 'Mis Dietas',
              ),
              Tab(
                icon: Icon(Icons.search, size: 30),
                text: 'Buscar Dietas',
              ),
              Tab(
                icon: Icon(Icons.favorite, size: 30),
                text: 'Favoritas',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NutritionDisplayTab(),
            NutritionDisplayTabSearch(),
            NutritionDisplayTabFavorites(),
          ],
        ),
        backgroundColor: const Color(0xFFB0E57C),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFF6DBE45),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FilterNutritionDialog();
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateNutritionRecordDialog();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
