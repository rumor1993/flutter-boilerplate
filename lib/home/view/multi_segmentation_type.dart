enum MultiSegmentationType {
  background(0, 'background'),
  hair(1, 'hair'),
  bodySkin(2, 'body-skin'),
  faceSkin(3, 'face-skin'),
  clothes(4, 'clothes'),
  others(5, 'others (accessories)');

  const MultiSegmentationType(this.classIndex, this.description);

  final int classIndex;
  final String description;

  // 편의 메서드들
  static MultiSegmentationType fromIndex(int index) {
    return MultiSegmentationType.values.firstWhere(
          (cls) => cls.classIndex == index,
      orElse: () => MultiSegmentationType.background,
    );
  }
}
