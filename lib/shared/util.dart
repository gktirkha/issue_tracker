import '../static_data.dart';
import 'models/issues_model.dart';
import 'dart:math';

List<Issue> sortByCreationDate(List<Issue> originalList, {bool dec = true}) {
  originalList.sort(
    dec
        ? (a, b) => a.createdAt.compareTo(b.createdAt)
        : (b, a) => a.createdAt.compareTo(b.createdAt),
  );
  return originalList;
}

List<Issue> sortByUpdatedDate(List<Issue> originalList, {bool dec = true}) {
  originalList.sort(
    dec
        ? (a, b) => a.updatedAt.compareTo(b.updatedAt)
        : (b, a) => a.updatedAt.compareTo(b.updatedAt),
  );
  return originalList;
}

List<Issue> sortByPriority(List<Issue> originalList, {bool dec = true}) {
  originalList.sort(
    dec
        ? (a, b) => priorityMap[a.priority]!.compareTo(priorityMap[b.priority]!)
        : (b, a) =>
            priorityMap[a.priority]!.compareTo(priorityMap[b.priority]!),
  );
  return originalList;
}

List<Issue> sortByTitle(List<Issue> originalList, {bool dec = true}) {
  originalList.sort(
    dec
        ? (a, b) => a.title.compareTo(b.title)
        : (b, a) => a.title.compareTo(b.title),
  );
  return originalList;
}

List<Issue> sortByCreatedBy(List<Issue> originalList, {bool dec = true}) {
  originalList.sort(
    dec
        ? (a, b) => a.createdBy.compareTo(b.createdBy)
        : (b, a) => a.createdBy.compareTo(b.createdBy),
  );
  return originalList;
}

String getIssueDayString(String date) {
  String dayString;
  DateTime issueDate = DateTime.parse(date);
  DateTime cuurentDate = DateTime.now();
  int dayDiff = cuurentDate.day - issueDate.day;
  switch (dayDiff) {
    case 0:
      dayString = "today";
      break;

    case 1:
      dayString = "yesterday";
      break;

    default:
      dayString = "$dayDiff days ago";
      break;
  }
  return dayString;
}

List<Issue> sortByStatus(List<Issue> originalList, {bool dec = true}) {
  originalList.sort(
    dec
        ? (a, b) => statusMap[a.status]!.compareTo(statusMap[b.status]!)
        : (b, a) => statusMap[a.status]!.compareTo(statusMap[b.status]!),
  );
  return originalList;
}

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
