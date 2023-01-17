import 'package:flutter/material.dart';

mixin GetStatsColor {
  Color mapColor(int number) {
    return _numberToColor[number % 8 + 1]!;
  }

  final _numberToColor = <int, Color>{
    1: Color.fromRGBO(120, 23, 82, 1),
    2: Color.fromRGBO(62, 144, 129, 1),
    3: Color.fromRGBO(255, 135, 108, 1),
    4: Color.fromRGBO(162, 22, 23, 1),
    5: Color.fromRGBO(69, 96, 116, 1),
    6: Color.fromRGBO(206, 206, 206, 1),
    7: Color.fromRGBO(43, 175, 177, 1),
    8: Color.fromRGBO(148, 158, 167, 1),
  };

  Color mapDebtCategoryColor(String id) {
    var map = {
      // personal
      'a5c48559-93d7-4693-84bc-4a07938d8f0c': Color.fromRGBO(120, 23, 82, 1),
      //	Credit Cards
      '58ecc507-5b64-4619-ac99-79830742dcbb': Color.fromRGBO(62, 144, 129, 1),
      //	Student Loan
      '59909b73-f83d-4476-9814-df5d2deef7dd': Color.fromRGBO(255, 135, 108, 1),
      //Auto Loan
      '50017583-1ada-4cbc-9a80-433a34018dcc': Color.fromRGBO(162, 22, 23, 1),
      //	Personal Loan
      'cad04b67-92d8-4da3-b4c5-80c3571f0166': Color.fromRGBO(69, 96, 116, 1),
      //Mortgage loan
      '55d6d875-b6ec-4959-9c79-dc16076871d8': Color.fromRGBO(206, 206, 206, 1),
      //Back Taxes
      '38696ad1-96d4-4f3e-9521-4cbb0b1dbd45': Color.fromRGBO(43, 175, 177, 1),
      //Medical Bills
      'ec4552a2-a758-4a1d-afd3-fefcb22cecb4': Color.fromRGBO(148, 158, 167, 1),
      //Other debt
      '34f613f4-900b-4b2f-969f-b2fa0eb812a5': Color.fromRGBO(241, 162, 185, 1),
      //Alimony

      // Business
      'd9211d07-aa45-4afc-80a0-6188c2e704e3': Color.fromRGBO(120, 23, 82, 1),
      // Credit Cards
      '80c7d42c-c3df-4629-8c84-717abc35249d': Color.fromRGBO(128, 138, 197, 1),
      // Business Loan
      '768b3861-e495-4b58-8d65-cf2155f9f82e': Color.fromRGBO(255, 135, 108, 1),
      // Auto Loan
    };

    return map[id] ?? Color.fromRGBO(120, 23, 82, 1);
  }
}
