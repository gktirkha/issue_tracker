import 'package:flutter/material.dart';
import '../../shared/models/issues_model.dart';
import '../../shared/utils/util_methods.dart';
import '../../shared/utils/static_data.dart';

class SortedListProvider with ChangeNotifier {
  List<Issue> _sortedList = [];
  List<Issue> get sortedList => [..._sortedList];

  Map<String, bool> sortedStatusMap = {
    CREATION_DATE: false,
    UPDATE_DATE: false,
    CREATED_BY: false,
    PRIORITY: false,
    STATUS: false,
  };

  void setSortedList(List<Issue> list) {
    _sortedList.clear();
    _sortedList.addAll(list);
    notifyListeners();
  }

  void sortIssuesByCreationDate() {
    sortedStatusMap[CREATION_DATE] = !sortedStatusMap[CREATION_DATE]!;
    sortByCreationDate(_sortedList, dec: sortedStatusMap[CREATION_DATE]!);
    notifyListeners();
  }

  void sortIssuesByUpdateDate() {
    sortedStatusMap[UPDATE_DATE] = !sortedStatusMap[UPDATE_DATE]!;
    sortByCreationDate(_sortedList, dec: sortedStatusMap[UPDATE_DATE]!);
    notifyListeners();
  }

  void sortIssuesByPriority() {
    sortedStatusMap[PRIORITY] = !sortedStatusMap[PRIORITY]!;
    sortByPriority(_sortedList, dec: sortedStatusMap[PRIORITY]!);
    notifyListeners();
  }

  void sortIssuesByStatus() {
    sortedStatusMap[STATUS] = !sortedStatusMap[STATUS]!;
    sortByStatus(_sortedList, dec: sortedStatusMap[STATUS]!);
    notifyListeners();
  }

  void sortIssuesByOwner() {
    sortedStatusMap[CREATED_BY] = !sortedStatusMap[CREATED_BY]!;
    sortByCreatedBy(_sortedList, dec: sortedStatusMap[CREATED_BY]!);
    notifyListeners();
  }
}
