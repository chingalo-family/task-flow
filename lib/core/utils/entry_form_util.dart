import '../constants/user_metadata_reference.dart';

class EntryFormUtil {
  static Map<String, dynamic> getUserAccountPayload({
    required String username,
    required String password,
    required String email,
    required String firstName,
    required String surname,
    required String phoneNumber,
  }) {
    const organisationUnits = [
      {"id": UserMetadataReference.defaultOrgUnitId},
    ];
    return {
      "username": username,
      "password": password,
      "userRoles": UserMetadataReference.userRoles
          .map((userRoleId) => {"id": userRoleId})
          .toList(),
      "email": email,
      "firstName": firstName,
      "surname": surname,
      "phoneNumber": phoneNumber,
      "organisationUnits": organisationUnits,
      "dataViewOrganisationUnits": organisationUnits,
      "teiSearchOrganisationUnits": organisationUnits,
      "userGroups": UserMetadataReference.userGroups
          .map((groupId) => {"id": groupId})
          .toList(),
    };
  }
}
