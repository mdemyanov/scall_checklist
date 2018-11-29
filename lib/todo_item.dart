import 'dart:html';
import 'dart:svg';

class TodoItem {
  String _title;
  bool _checked = false;
  SvgElement _decor;
  InputElement _input;
  DivElement _text;
  LabelElement labelElement = LabelElement();
  Function _finish;
  Element _checkedElement;
  Element _notCheckedElement;

  TodoItem(this._title, this._checkedElement, this._notCheckedElement,
      this._finish) {
    _decor = SvgElement.svg(
        '''<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 200 25"
             class="todo__icon">
            <use xlink:href="#todo__box" class="todo__box"></use>
            <use xlink:href="#todo__check" class="todo__check"></use>
            <use xlink:href="#todo__circle" class="todo__circle"></use>
        </svg>''');
    _input = Element.html('''<input class="todo__state" type="checkbox"/>''');
    _input.checked = _checked;
    _input.onClick.listen(this.check);
    _text = Element.html('''<div class="todo__text">${_title}</div>''');
    labelElement.className = 'todo';
    labelElement..append(_input)..append(_decor)..append(_text);
    append(_notCheckedElement);
  }

  void append(Element el) => el.append(labelElement);

  void check(Event _) {
    _input.disabled = true;
    if (_input.checked) {
      append(_checkedElement);
    } else {
      append(_notCheckedElement);
    }
    if (_notCheckedElement.children.length == 0) {
      _finish();
    }
  }
}
