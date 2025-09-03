import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/component/transparent_grid_widget.dart';
import 'package:flutter_boilerplate/home/data/menu_item_data.dart';

class TopMenuSectionWidget extends StatefulWidget {
  const TopMenuSectionWidget({super.key});

  @override
  State<TopMenuSectionWidget> createState() => _TopMenuSectionWidgetState();
}

class _TopMenuSectionWidgetState extends State<TopMenuSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return   GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.0,
        mainAxisSpacing: 14.0,
        childAspectRatio: 0.8, // 타이틀 공간을 위해 세로를 더 길게
      ),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Column(
          children: [
            // 이미지 부분
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: TransparentGridWidget(
                    tileSize: 20.0,
                    lightColor: Colors.white,
                    darkColor: Colors.grey.shade300,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Padding(
                        padding: EdgeInsets.all(
                          menuItems[index].padding,
                        ),
                        child: Image.asset(menuItems[index].imagePath),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 타이틀 부분
            SizedBox(height: 8),
            Text(
              menuItems[index].title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
