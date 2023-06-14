class Meal {
  final int calories, id;
  final String carbs, fat, image, imageType, protein, title;
  Meal({
    required this.id,
    required this.title,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.image,
    required this.imageType,
    required this.protein,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      title: map['title'],
      calories: map['calories'],
      carbs: map['carbs'],
      fat: map['fat'],
      image: map['image'],
      imageType: map['imageType'],
      protein: map['protein'],
    );
  }
}
