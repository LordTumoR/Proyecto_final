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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6DBE45),
                   Color(0xFF6DBE45),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Nutrición y Dietas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: Icon(Icons.restaurant, size: 26),
                text: 'Mis Dietas',
              ),
              Tab(
                icon: Icon(Icons.search, size: 26),
                text: 'Buscar Dietas',
              ),
              Tab(
                icon: Icon(Icons.favorite, size: 26),
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
        backgroundColor: const Color(0xFFF0FFF0),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          color: const Color(0xFF6DBE45),
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  tooltip: 'Filtrar dietas',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => FilterNutritionDialog(),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                  tooltip: 'Nueva dieta',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => CreateNutritionRecordDialog(),
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
