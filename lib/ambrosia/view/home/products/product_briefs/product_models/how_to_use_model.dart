class HowToUseStep {
  final String title;
  final String description;
  final String image;
  final int stepNumber;

  HowToUseStep({
    required this.title,
    required this.description,
    required this.image,
    required this.stepNumber,
  });

  factory HowToUseStep.fromJson(Map<String, dynamic> json) {
    return HowToUseStep(
      title: json['title'],
      description: json['description'],
      image: "https://ambrosiaayurved.in/${json['image']}",
      stepNumber: int.tryParse(json['step_number']) ?? 0,
    );
  }
}
