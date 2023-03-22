class Category {
  final int id;
  final int qa_id;
  final String category;

  const Category({
    this.id = 0,
    required this.qa_id,
    required this.category,
  });

  Map<String, dynamic> categoryMap() {
    return {
      'qa_id': qa_id,
      'category': category,
    };
  }
}
