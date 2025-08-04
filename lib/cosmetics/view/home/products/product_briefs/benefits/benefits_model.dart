class BenefitItem {
  final String title;
  final String image;
  final String description;

  BenefitItem({
    required this.title,
    required this.image,
    required this.description,
  });

  factory BenefitItem.fromJson(Map<String, dynamic> json) {
    return BenefitItem(
      title: json['title'] ?? '',
      image: "https://ambrosiaayurved.in/${json['image']}",
      description: json['description'] ?? '',
    );
  }
}
