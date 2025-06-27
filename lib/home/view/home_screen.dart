import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/component/category_list.dart';
import '../../common/component/news_card.dart';
import '../../common/component/vertical_news_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'didim',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          Transform.translate(
            offset: const Offset(-8, 0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "오늘의 추천 레시피",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CategoryList(
                    categories: const ['전체', '음식', '여행', '게임'],
                    onCategorySelected: (category) {
                      // TODO: 카테고리 선택 시 동작 구현
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNewsCardList(),
                  const SizedBox(height: 32),
                  _buildVerticalSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCardList() {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return NewsCard(
            title: "맛있는 식단 ${index + 1}",
            date: "2024.12.${index + 1}",
            viewCount: (index + 1) * 123,
            imageUrl: 'assets/images/food_$index.jpg',
            onTap: () {
              // TODO: 카드 탭 시 동작 구현
            },
          );
        },
      ),
    );
  }

  Widget _buildVerticalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "5분 완성 간단 레시피",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "더보기",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: List.generate(3, (index) {
            return VerticalNewsCard(
              title: "공릉동 맛집 탐방 ${index + 1}번째 이야기 - 숨겨진 보석같은 식당을 찾아서",
              imageUrl: 'assets/images/food_$index.jpg',
              onTap: () {
                // TODO: 카드 탭 시 동작 구현
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFoodBackgroundSection() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100], // 기본 배경색
      ),
      child: ClipRRect(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.grey.withValues(alpha: 0.1), // 오렌지 색조 추가
              BlendMode.overlay,
            ),
            child: Image.asset(
              'assets/images/food-background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
