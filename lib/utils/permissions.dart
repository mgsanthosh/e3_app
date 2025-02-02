List<String> getUserPermissions(String role) {
  if (role == "ADMIN") {
    return ["LOCATIONS", "ADD USER"];
  } else if (role == "MANAGER") {
    return [""];
  } else {
    return [];
  }
}