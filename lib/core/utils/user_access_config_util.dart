class UserAccessConfigUtil {
  static String getCurrentUserAccessConfiguration(String? attributeValue) {
    Map userAccessConfigMapping = getUserAccessConfigMapping();
    return userAccessConfigMapping[attributeValue] ?? '';
  }

  static Map getUserAccessConfigMapping() {
    return {
      'jkHzIytM0Gl': 'Owner',
      'SM2zW2CxBOW': 'Co-Owner',
      'p6BBRleATJe': 'Normal',
    };
  }
}
