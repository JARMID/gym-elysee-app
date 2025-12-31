class BlogArticle {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String author;
  final String date;
  final String readTime;
  final String imageUrl;
  final List<BlogContentBlock> content;

  const BlogArticle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.author,
    required this.date,
    required this.readTime,
    required this.imageUrl,
    required this.content,
  });
}

enum BlogBlockType { heading, paragraph, list, quoteWithAuthor }

class BlogContentBlock {
  final BlogBlockType type;
  final String text; // For heading, paragraph, or quote
  final List<String>? listItems; // For simple bullets
  final List<Map<String, String>>?
  structuredListItems; // For "Title - Description" items
  final String? secondaryText; // For quote author

  const BlogContentBlock({
    required this.type,
    this.text = '',
    this.listItems,
    this.structuredListItems,
    this.secondaryText,
  });
}
