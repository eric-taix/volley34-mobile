String getClassificationCategory(String? division) {
  switch (division) {
    case "EX":
      return "Excellence";
    case "HO":
      return "Honneur";
    case "PR":
      return "Promotion";
    case "AC":
      return "Accession";
    case "L1":
      return "Loisirs 1";
    default:
      return "";
  }
}

String getClassificationPool(String? pool) {
  if (pool == "0")
    return "";
  else
    return "Poule $pool";
}
