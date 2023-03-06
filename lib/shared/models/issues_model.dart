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
  String? assignedToId;
  String createdById;

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
    this.assignedToId,
    required this.createdById,
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
          json["status"] != UNASSIGNED ? json["assignedTo"]["name"] : null,
      assignedToId:
          json["status"] != UNASSIGNED ? json["assignedTo"]["_id"] : null,
      createdById: json["createdBy"]["_id"],
    );
  }
}
