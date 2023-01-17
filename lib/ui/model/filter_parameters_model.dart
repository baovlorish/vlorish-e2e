import 'package:equatable/equatable.dart';

class FilterParametersModel extends Equatable {
  final List<FilterCategory> personalCategories;
  final DateTime? periodStart;
  final List<FilterCategory> businessCategories;
  final DateTime? periodEnd;

  late final Map<FilterCategory, List<FilterCategory>> personalMap;
  late final Map<FilterCategory, List<FilterCategory>> businessMap;
  late final Map<FilterCategory, List<FilterCategory>> allMap;

  FilterParametersModel(
      {required this.personalCategories,
      required this.periodStart,
      required this.businessCategories,
      required this.periodEnd}) {
    personalMap = {};
    businessMap = {};
    personalCategories.forEach((element) {
      if (element.categories != null) {
        personalMap[element] = element.categories!;
      }
    });
    businessCategories.forEach((element) {
      if (element.categories != null) {
        businessMap[element] = element.categories!;
      }
    });
    allMap = _combineMaps();
  }

  factory FilterParametersModel.fromJson(dynamic json) {
    var personalCategories = <FilterCategory>[];
    var businessCategories = <FilterCategory>[];

    for (var item in json['personalCategories']) {
      personalCategories.add(FilterCategory.fromJson(item));
    }
    for (var item in json['businessCategories']) {
      businessCategories.add(FilterCategory.fromJson(item));
    }
    for (var item in json['exceptionalCategories']) {
      personalCategories.add(FilterCategory.fromJson(item));
      businessCategories.add(FilterCategory.fromJson(item));
    }
    return FilterParametersModel(
      personalCategories: personalCategories,
      businessCategories: businessCategories,
      periodStart: json['periodStart'] != null
          ? DateTime.parse(json['periodStart'])
          : null,
      periodEnd:
          json['periodEnd'] != null ? DateTime.parse(json['periodEnd']) : null,
    );
  }

  Map<FilterCategory, List<FilterCategory>> _combineMaps() {
    var map = <FilterCategory, List<FilterCategory>>{};
    map.addAll(personalMap);
    map.addAll(businessMap);
    var otherExpKeys = map.keys
        .where((element) =>
            element.id.contains('941435d2-313b-4a99-b62c-e17fc9d52d4e') ||
            element.id.contains('5305617c-0bd4-4dd7-8a05-b4202ccf4297'))
        .toList();
    if (otherExpKeys.length > 1) {
      var values = <FilterCategory>[];
      for (var item in otherExpKeys) {
        item.categories?.forEach((element) {
          values.add(element);
        });
      }
      _combineValues(values, '2a3c8f8d-7401-466b-a8ec-e6f5bfe75870',
          '824e6410-7355-4152-bacf-ddb615648758');
      _combineValues(values, '01a1ae66-671e-4263-8d95-744e36b64a06',
          '8bd3911e-93dc-45a3-a55b-cba281ce7db9');
      var newOtherExp = FilterCategory(
          name: otherExpKeys[0].name,
          id: [
            '941435d2-313b-4a99-b62c-e17fc9d52d4e',
            '5305617c-0bd4-4dd7-8a05-b4202ccf4297'
          ],
          categories: values);
      map[newOtherExp] = values;
      map.remove(otherExpKeys[0]);
      map.remove(otherExpKeys[1]);
    }
    var incomeKeys = map.keys
        .where((element) =>
            element.id.contains('938beaea-4e0a-458a-a6d2-27ed1e5b1de3') ||
            element.id.contains('0d4cf5cc-4d0f-4bde-9e71-7fedd9fae0c2'))
        .toList();
    if (incomeKeys.length > 1) {
      var values = <FilterCategory>[];
      for (var item in incomeKeys) {
        item.categories?.forEach((element) {
          values.add(element);
        });
      }
      _combineValues(values, 'baf5e5c1-54e1-474b-b554-00915f6df107',
          '070b7df2-3c54-465f-b5a3-2de0a6b2649f');
      _combineValues(values, 'f6ed2cd2-cd3b-42f4-8861-fe5627026200',
          'bd473fea-ff7a-4e0f-8d9d-2bbd9fc835f7');
      var newIncome = FilterCategory(
          name: incomeKeys[0].name,
          id: [
            '938beaea-4e0a-458a-a6d2-27ed1e5b1de3',
            '0d4cf5cc-4d0f-4bde-9e71-7fedd9fae0c2'
          ],
          categories: values);
      map[newIncome] = values;
      map.remove(incomeKeys[0]);
      map.remove(incomeKeys[1]);
    }
    return map;
  }

  Map<FilterCategory, List<FilterCategory>> currentMap(int? usageType) {
    return usageType == 1
        ? personalMap
        : usageType == 2
            ? businessMap
            : allMap;
  }

  void _combineValues(List<FilterCategory> values, String id1, String id2) {
    if (values
            .where((element) =>
                element.id.contains(id1) || element.id.contains(id2))
            .toList()
            .length >
        1) {
      var name = values.firstWhere((element) => element.id.contains(id1)).name;
      values.removeWhere((element) => element.id.contains(id1));
      values.removeWhere((element) => element.id.contains(id2));
      values.add(FilterCategory(name: name, id: [id1, id2]));
    }
  }

  @override
  List<Object?> get props =>
      [personalCategories, periodStart, businessCategories, periodEnd];
}

class FilterCategory extends Equatable {
  final String name;
  final List<String> id;
  final List<FilterCategory>? categories;

  const FilterCategory({required this.name, required this.id, this.categories});

  factory FilterCategory.fromJson(Map<String, dynamic> json) {
    var categories;
    if (json['categories'] != null) {
      categories = <FilterCategory>[];
      for (var item in json['categories']) {
        categories.add(FilterCategory.fromJson(item));
      }
    }

    return FilterCategory(
      id: [json['id']],
      name: json['name'],
      categories: categories,
    );
  }

  @override
  List<Object?> get props => [id, name, categories];
}
