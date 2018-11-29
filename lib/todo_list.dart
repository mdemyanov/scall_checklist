import 'dart:html';
import 'dart:js';

import 'package:naumen_smp_jsapi/naumen_smp_jsapi.dart';

import 'todo_item.dart';
import 'service_call.dart';

class TodoList {
  final Element _checked = querySelector('#checked.todo-list');
  final Element _notChecked = querySelector('#not-checked.todo-list');
  String _checkAttrCode;
  ServiceCall _serviceCall;

  static String Function() noNeed = () => 'не требуется';
  static String Function() complete = () => 'заполнен';
  static String Function() empty = () => null;

  static Future<TodoList> fromServiceCall(String checkAttrCode) async {
    ServiceCall serviceCall = await ServiceCall.getServiceCall();

    return TodoList(serviceCall, checkAttrCode);
  }

  TodoList(this._serviceCall, this._checkAttrCode) {
    if (_serviceCall.fieldsFilled) {
      update();
    }
    _serviceCall.updates.listen((bool filled) {
      if (filled) {
        update();
      } else {
        cancel();
      }
    });
  }

  void update() async {
    Map service = await SmpAPI.get(_serviceCall.serviceId);
    String settings = service['checkList'];
    if (settings != null) {
      JsApi.registerAttributeToModification(
          _checkAttrCode, allowInterop(empty));
      List<String> list = settings
          .split(RegExp(r'\n\s*'))
          .where((String text) => text.length > 1)
          .toList();
      list.forEach((String text) {
        TodoItem(text, _checked, _notChecked, () {
          JsApi.registerAttributeToModification(
              _checkAttrCode, allowInterop(complete));
        });
      });
    } else {
      cancel();
    }
  }

  void cancel() {
    _checked.innerHtml = '';
    _notChecked.innerHtml = '';
    JsApi.registerAttributeToModification(_checkAttrCode, allowInterop(noNeed));
  }
}
