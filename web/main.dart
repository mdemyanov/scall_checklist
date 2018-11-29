import 'dart:html';

import 'package:naumen_smp_jsapi/naumen_smp_jsapi.dart';

import 'package:scall_checklist/todo_list.dart';

void main() async {
  String checkAttrCode = 'chekListStr';
  Top.injectJsApi(Top, Window);
  TodoList.fromServiceCall(checkAttrCode);
}

