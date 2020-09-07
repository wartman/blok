package todo.ui;

using Blok;

class TodoInput extends Component {
  @prop var onSave:(value:String)->Void;
  @prop var requestClose:()->Void = null;
  @prop var initialValue:String = '';
  @prop var placeholder:String = '';
  
  var ref:js.html.InputElement;

  function clickOff(e:js.html.Event) {
    if (e.target != ref) {
      js.Browser.window.removeEventListener('click', clickOff);
      if (requestClose != null) requestClose();
    }
  }

  @effect
  function setupListener() {
    ref.focus();
    if (requestClose != null) {
      js.Browser.window.addEventListener('click', clickOff);
    }
  }
  
  @dispose
  function cleanup() {
    js.Browser.window.removeEventListener('click', clickOff);
  }

  override function render(context:Context):VNode {
    return Ui.input({
      ref: node -> ref = cast node,
      value: initialValue,
      placeholder: placeholder,
      onInput: ev -> {
        if (ev.key == 'Enter') {
          onSave(ref.value);
          if (requestClose != null) requestClose();
          ref.value = '';
        } else if (ev.key == 'Escape') {
          if (requestClose != null) requestClose();
          ref.value = '';
        }
      }
    });
  }
}
