class Prediction {
  final int? id;
  final String imagePath;
  final String label;
  final double confidence;
  final String date;

  Prediction({
    this.id,
    required this.imagePath,
    required this.label,
    required this.confidence,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'label': label,
      'confidence': confidence,
      'date': date,
    };
  }

  factory Prediction.fromMap(Map<String, dynamic> map) {
    return Prediction(
      id: map['id'],
      imagePath: map['imagePath'],
      label: map['label'],
      confidence: map['confidence'],
      date: map['date'],
    );
  }
}