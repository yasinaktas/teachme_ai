enum KnowledgeLevel {
  novice,      
  beginner,    
  intermediate, 
  advanced,    
  expert       
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
