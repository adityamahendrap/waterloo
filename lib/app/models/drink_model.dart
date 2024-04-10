class DrinkModel {
  late String id;
  late double amount;
  late String type;
  late DateTime datetime;

  DrinkModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.datetime,
  });

  DrinkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    type = json['type'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'datetime': datetime,
    };
  }
}

class WaterModel {
  late String id;
  late String userId;
  late List<DrinkModel> drinks;
  late DateTime datetime;

  WaterModel({
    required this.id,
    required this.userId,
    required this.drinks,
    required this.datetime,
  });

  WaterModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    drinks = (json['drinks'] as List)
        .map((e) => DrinkModel(
              id: e['id'],
              amount: e['amount'],
              type: e['type'],
              datetime: e['datetime'],
            ))
        .toList();
    datetime = json['datetime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'drinks': drinks.map((e) => e.toMap()).toList(),
      'datetime': datetime,
    };
  }
}
