import 'package:flutter/material.dart';

import 'model.dart';

final categories = [
  Category(
    title: "Category A",
    color: Colors.teal.shade100,
    subCategories: [
      SubCategory(
          title: 'SubCat. A1',
          operations: [200, 500, 192],
          color: Colors.teal.shade200),
      SubCategory(
          title: 'SubCat. A2',
          operations: [100, 1200, 19],
          color: Colors.teal.shade300),
      SubCategory(
          title: 'SubCat. A3',
          operations: [1000, 210],
          color: Colors.teal.shade600),
    ],
  ),
  Category(
    title: "Category B",
    color: Colors.orange,
    subCategories: [
      SubCategory(
        title: 'SubCat. B1',
        operations: [200, 50, 72],
        color: Colors.orange.shade200,
      ),
      SubCategory(
        title: 'SubCat. B2',
        operations: [10, 119, 24],
        color: Colors.orange.shade600,
      ),
    ],
  ),
  Category(
    color: Colors.purple,
    title: "Category C",
    subCategories: [
      SubCategory(
          title: 'SubCat. C1',
          operations: [79, 81, 72],
          color: Colors.purple.shade200),
      SubCategory(
          title: 'SubCat. C2',
          operations: [1009, 279, 24],
          color: Colors.purple.shade100),
      SubCategory(
          title: 'SubCat. C3',
          operations: [37, 90],
          color: Colors.purple.shade600),
      SubCategory(
          title: 'SubCat. C4',
          operations: [333, 678, 123],
          color: Colors.purple.shade800),
    ],
  ),
  Category(
    color: Colors.teal,
    title: "Category D",
    subCategories: [
      SubCategory(
          title: 'SubCat. C1',
          operations: [719, 81, 72],
          color: Colors.teal.shade200),
      SubCategory(
          title: 'SubCat. C2',
          operations: [243, 279, 24],
          color: Colors.teal.shade100),
      SubCategory(
          title: 'SubCat. C3',
          operations: [312, 90],
          color: Colors.teal.shade600),
      SubCategory(
          title: 'SubCat. C4',
          operations: [333, 678, 123],
          color: Colors.teal.shade800),
    ],
  ),
];
