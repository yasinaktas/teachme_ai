enum KnowledgeLevel {
  novice,       // Very new
  beginner,     // Knows basics
  intermediate, // Solid understanding
  advanced,     // High skill level
  expert        // Complete mastery
}

extension KnowledgeLevelExtension on KnowledgeLevel {
  String get label {
    switch (this) {
      case KnowledgeLevel.novice:
        return "Novice";
      case KnowledgeLevel.beginner:
        return "Beginner";
      case KnowledgeLevel.intermediate:
        return "Intermediate";
      case KnowledgeLevel.advanced:
        return "Advanced";
      case KnowledgeLevel.expert:
        return "Expert";
    }
  }
}
