import '../../static_data.dart';

class Issue {
  String id;
  String title;
  String description;
  String priority;
  String createdBy;
  String status;
  List? comments;
  String createdAt;
  String updatedAt;
  String? assignedTo;
  String? asignedToId;

  Issue({
    this.comments,
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    this.asignedToId,
  });

  factory Issue.fromJson(dynamic json) {
    return Issue(
      id: json["_id"],
      title: json["title"],
      description: json["description"],
      priority: json["priority"],
      createdBy: json["createdBy"]["name"],
      status: json["status"],
      comments: json["comments"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      assignedTo:
          json["status"] == ASSIGNED ? json["assignedTo"]["name"] : null,
      asignedToId:
          json["status"] == ASSIGNED ? json["assignedTo"]["_id"] : null,
    );
  }
}
