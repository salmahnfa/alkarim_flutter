class VersionCheckResponse{
  final bool success;
  final Data data;
  final String message;

  VersionCheckResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  VersionCheckResponse.fromJson(Map<String, dynamic> json)
  : success = json['success'],
    data = Data.fromJson(json['data']),
    message = json['message'];
}

class Data {
  final String version;
  final bool maintenanceStatus;
  final bool versionStatus;
  final bool showPopup;
  final String playstoreLink;

  Data ({
    required this.version,
    required this.maintenanceStatus,
    required this.versionStatus,
    required this.showPopup,
    required this. playstoreLink
  });

  Data.fromJson(Map<String, dynamic> json)
  : version = json['version'],
    maintenanceStatus = json['maintenance_status'],
    versionStatus = json['version_status'] == 1,
    showPopup = json['show_popup'] == 1,
    playstoreLink = json['playstore_link'];
}