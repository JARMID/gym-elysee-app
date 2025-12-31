// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchModel _$BranchModelFromJson(Map<String, dynamic> json) => BranchModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      wilaya: json['wilaya'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone'] as String,
      openingHours: Map<String, String>.from(json['opening_hours'] as Map),
      ramadanHours: _ramadanHoursFromJson(json['ramadan_hours']),
      capacity: (json['capacity'] as num).toInt(),
      equipment:
          (json['equipment'] as List<dynamic>).map((e) => e as String).toList(),
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      coaches: (json['coaches'] as List<dynamic>?)
          ?.map((e) => CoachModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      programs: (json['programs'] as List<dynamic>?)
          ?.map((e) => ProgramModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BranchModelToJson(BranchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'wilaya': instance.wilaya,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
      'opening_hours': instance.openingHours,
      'ramadan_hours': _ramadanHoursToJson(instance.ramadanHours),
      'capacity': instance.capacity,
      'equipment': instance.equipment,
      'photos': instance.photos,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'tags': instance.tags,
      'coaches': instance.coaches,
      'programs': instance.programs,
    };
