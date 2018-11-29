@JS()
library jsApi;

import 'dart:js';
import 'dart:async';

import 'package:naumen_smp_jsapi/naumen_smp_jsapi.dart';
import 'package:js/js.dart';

class ServiceCall {

  String _serviceId;
  StreamController<bool> _updates;

  static Future<ServiceCall> getServiceCall() async {
    ObjectCard card = await getCurrentContextObject();
    if(card.service != null) {
      return ServiceCall(card.service.UUID);
    }
    return ServiceCall();
  }

  ServiceCall([this._serviceId]) {
    _updates = StreamController<bool>();
    updateBOLink('service').listen(this.setServiceId);
  }

  void setServiceId(BOLink service) {
    if(service != null) {
      _serviceId = service.newValue != null ? service.newValue.UUID : null;
      _updates.add(fieldsFilled);
    }
  }

  String get serviceId => _serviceId;

  bool get isAddForm => JsApi.isAddForm();

  List<String> get fields => [_serviceId];

  bool get fieldsFilled => fields.every((e) => e != null);

  Stream<bool> get updates => _updates.stream;
}

Stream<BOLink> updateBOLink(String attrCode) {
  final controller = StreamController<BOLink>();
  JsApi.addFieldChangeListener(attrCode, allowInterop((event) => controller.add(event as BOLink)));
  return controller.stream;
}

Future<ObjectCard> getCurrentContextObject() {
  final completer = new Completer<ObjectCard>();
  JsApi.commands.getCurrentContextObject().then(
      allowInterop(completer.complete),
      allowInterop(completer.completeError)
  );
  return completer.future;
}

@JS()
@anonymous
abstract class ObjectCard {
  external BObject get service;
}