class CustomUtils {
  static String? convertOptions(String key) {
    switch (key) {
      case "region":
        return "\u{1F4CD} 지역 :";
      case "school":
        return "\u{1F393} 학력 :";
      case "religion":
        return "\u{1F64F} 종교 :";
      case "policy":
        return "\u{1F3AD} 정치 :";
      case "smoke":
        return "\u{1F6AC} 흡연 :";
      case "drink":
        return "\u{1F377} 음주 :";
      case "drive":
        return "\u{1F698} 차량 :";
      case "weight":
        return "\u{1F4AA} 체형 :";
    }
    return null;
  }

  static String? convertInputs(String key) {
    switch (key) {
      case "location":
        return "\u{1F6B6} 위치 :";
      case "job":
        return "\u{1F4BC} 직업 :";
    }
    return null;
  }

  static String? convertBio(String key) {
    switch (key) {
      case "prefer":
        return "\u{1F6B6} 선호 :";
      case "deny":
        return "\u{1F4BC} 거부 :";
      case "dating":
        return "\u{1F4BC} 데이트 :";
      case "hobby":
        return "\u{1F4BC} 취미 :";
      case "more":
        return "\u{1F4BC} 하고 싶은 말 :";
    }
    return null;
  }
}
