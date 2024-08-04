import 'package:flutter/foundation.dart';

class Crop {
  String name;
  DateTime plantingDate;
  DateTime estimatedHarvestDate;
  DateTime? actualHarvestDate;
  bool isHarvested;

  Crop({
    required this.name,
    required this.plantingDate,
    required this.estimatedHarvestDate,
    this.actualHarvestDate,
    this.isHarvested = false,
  });

  // Convert a Crop object into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'plantingDate': plantingDate.toIso8601String(),
      'estimatedHarvestDate': estimatedHarvestDate.toIso8601String(),
      'actualHarvestDate': actualHarvestDate?.toIso8601String(),
      'isHarvested': isHarvested,
    };
  }

  // Convert a JSON object into a Crop object
  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      name: json['name'],
      plantingDate: DateTime.parse(json['plantingDate']),
      estimatedHarvestDate: DateTime.parse(json['estimatedHarvestDate']),
      actualHarvestDate: json['actualHarvestDate'] != null
          ? DateTime.parse(json['actualHarvestDate'])
          : null,
      isHarvested: json['isHarvested'],
    );
  }
  Crop copyWith({
    String? name,
    DateTime? plantingDate,
    DateTime? estimatedHarvestDate,
    bool? isHarvested,
    DateTime? actualHarvestDate,
  }) {
    return Crop(
      name: name ?? this.name,
      plantingDate: plantingDate ?? this.plantingDate,
      estimatedHarvestDate: estimatedHarvestDate ?? this.estimatedHarvestDate,
      isHarvested: isHarvested ?? this.isHarvested,
      actualHarvestDate: actualHarvestDate ?? this.actualHarvestDate,
    );}
}
