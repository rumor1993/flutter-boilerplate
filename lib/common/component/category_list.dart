import 'package:flutter/material.dart';
import 'category_chip.dart';

class CategoryList extends StatefulWidget {
  final List<String> categories;
  final Function(String)? onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    this.onCategorySelected,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: 25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: widget.categories[index],
                    isSelected: index == selectedIndex,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      widget.onCategorySelected?.call(widget.categories[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "더보기",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
