class FoodEntityDatabase {
  final int id;
  final String name;
  final String brand;
  final String category;
  final double? calories;
  final double? carbohydrates;
  final double? protein;
  final double? fat;
  final double? fiber;
  final double? sugar;
  final double? sodium;
  final double? cholesterol;
  String? mealtype;
  final DateTime? date;
  final String? imageUrl;

  FoodEntityDatabase({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    this.calories,
    this.carbohydrates,
    this.protein,
    this.fat,
    this.fiber,
    this.sugar,
    this.sodium,
    this.cholesterol,
    this.mealtype,
    this.date,
    this.imageUrl,
  });

  @override
  String toString() {
    return 'FoodEntity{id: $id, name: $name, brand: $brand, category: $category, calories: $calories, carbohydrates: $carbohydrates, protein: $protein, fat: $fat, fiber: $fiber, sugar: $sugar, sodium: $sodium, cholesterol: $cholesterol}';
  }
}
