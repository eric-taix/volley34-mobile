

extension Extension on String {
  bool isNullOrEmpty() => this == null || this.trim() == '';

  bool isNotNullAndNotEmpty() => this != null && this.trim() != '';
}