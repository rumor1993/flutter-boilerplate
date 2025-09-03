import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/component/transparent_grid_widget.dart';
import 'package:flutter_boilerplate/editor/view/basic_template_editor.dart';
import 'package:flutter_boilerplate/home/model/tempate_item.dart';

import '../model/template_category.dart';

class TemplateCategorySectionWidget extends StatelessWidget {
  final TemplateCategory category;

  const TemplateCategorySectionWidget({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryTitle(),
        _buildTemplateGrid(context),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCategoryTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        category.title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTemplateGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: category.templates.length,
      itemBuilder: (context, index) {
        final template = category.templates[index];
        return _buildTemplateItem(context, template);
      },
    );
  }

  Widget _buildTemplateItem(BuildContext context, TemplateItem template) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BasicTemplateEditor(
              templateImagePath: template.imagePath,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TransparentGridWidget(
                  tileSize: 15,
                  lightColor: Colors.white,
                  darkColor: Colors.grey.shade300,
                  child: Padding(
                    padding: EdgeInsets.all(template.padding),
                    child: Image.asset(
                      template.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            template.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}